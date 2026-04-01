//
//  ApiClient.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import Alamofire
import UIKit

public class ApiClient<R: Router> {
    
    private let session: Session
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(
        session: Session,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    public func request<T: Decodable>(_ router: R) async -> Result<T, NetworkError> {
        let request: URLRequest
        do {
            request = try router.asURLRequest()
        } catch {
            return .failure(.urlError)
        }
        
        let result = await session.request(request).serializingData().response

        // 에러 처리
        if let error = result.error {
            if let afError = error.asAFError {
                switch afError {
                case .sessionTaskFailed(let underlying as URLError) where underlying.code == .notConnectedToInternet:
                    return .failure(.noInternet)
                case .explicitlyCancelled:
                    return .failure(.cancelled)
                default:
                    return .failure(.requestFailed(afError.localizedDescription))
                }
            }
            return .failure(.requestFailed(error.localizedDescription))
        }

        guard let response = result.response else {
            return .failure(.invalidResponse)
        }

        if 200..<300 ~= response.statusCode {
            // data가 없는 경우 (204 No Content 등)
            guard let data = result.data else {
                if T.self == EmptyResponseDto.self {
                    return .success(EmptyResponseDto() as! T)
                }
                return .failure(.dataNil)
            }

            // 1) ResponseBody<T> 시도
            if let wrapped = try? decoder.decode(ResponseBody<T>.self, from: data) {
                if let payload = wrapped.data {
                    return .success(payload)
                } else if T.self == EmptyResponseDto.self {
                    // data 필드가 없는 성공 응답 처리
                    return .success(EmptyResponseDto() as! T)
                } else {
                    return .failure(.dataNil)
                }
            }
            // 2) T 직접 디코딩 폴백
            if let direct = try? decoder.decode(T.self, from: data) {
                return .success(direct)
            }

            // 디코딩 실패 시 raw data 출력 (디버깅용)
            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.error("Decoding failed for: \(jsonString)")
            }

            return .failure(.failToDecode("Unable to decode as ResponseBody or direct T"))

        } else { // 실패 (4xx, 5xx)
            guard let data = result.data else {
                return .failure(.dataNil)
            }

            // 실패 ResponseBody 파싱 시도
            if let errorBody = try? decoder.decode(ErrorResponseBody.self, from: data) {
                return .failure(.serverFailed(code: errorBody.status ?? response.statusCode,
                                              message: errorBody.message ?? "no message"))
            }
            // 파싱 실패하면 기존 에러
            return .failure(.serverError(response.statusCode))
        }
    }

    /// Multipart 업로드 (JSON + 이미지)
    public func upload<T: Decodable, E: Encodable>(
        _ router: R,
        body: E,
        image: UIImage?
    ) async -> Result<T, NetworkError> {
        let url = router.baseURL.appendingPathComponent(router.path)

        let uploadEncoder = JSONEncoder()
        guard let jsonData = try? uploadEncoder.encode(body) else {
            return .failure(.failToDecode(""))
        }
        
//        if let object = try? JSONSerialization.jsonObject(with: jsonData),
//           let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
//           let prettyString = String(data: prettyData, encoding: .utf8)
//        {
//            print(prettyString)
//        } else {
//            print("❌ JSON 변환 실패")
//        }
        
        let result = await session.upload(
            multipartFormData: { formData in
                formData.append(jsonData, withName: "request", mimeType: "application/json")

                if let image = image,
                   let imageData = image.jpegData(compressionQuality: 0.8) {
                    formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                }
            },
            to: url,
            headers: router.headers
        )
        .serializingData()
        .response

        // 에러 처리
        if let error = result.error {
            if let afError = error.asAFError {
                switch afError {
                case .sessionTaskFailed(let underlying as URLError) where underlying.code == .notConnectedToInternet:
                    return .failure(.noInternet)
                case .explicitlyCancelled:
                    return .failure(.cancelled)
                default:
                    return .failure(.requestFailed(afError.localizedDescription))
                }
            }
            return .failure(.requestFailed(error.localizedDescription))
        }

        guard let response = result.response else {
            return .failure(.invalidResponse)
        }

        if 200..<300 ~= response.statusCode {
            guard let data = result.data else {
                if T.self == EmptyResponseDto.self {
                    return .success(EmptyResponseDto() as! T)
                }
                return .failure(.dataNil)
            }

            if let wrapped = try? decoder.decode(ResponseBody<T>.self, from: data) {
                if let payload = wrapped.data {
                    return .success(payload)
                } else if T.self == EmptyResponseDto.self {
                    return .success(EmptyResponseDto() as! T)
                } else {
                    return .failure(.dataNil)
                }
            }

            if let direct = try? decoder.decode(T.self, from: data) {
                return .success(direct)
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.error("Decoding failed for: \(jsonString)")
            }

            return .failure(.failToDecode("Unable to decode as ResponseBody or direct T"))

        } else {
            guard let data = result.data else {
                return .failure(.dataNil)
            }

            if let errorBody = try? decoder.decode(ErrorResponseBody.self, from: data) {
                return .failure(.serverFailed(code: errorBody.status ?? response.statusCode,
                                              message: errorBody.message ?? "no message"))
            }
            return .failure(.serverError(response.statusCode))
        }
    }
}

