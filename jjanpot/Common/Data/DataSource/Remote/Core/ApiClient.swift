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

    // MARK: - 이미지 압축 설정
    private let imageQualityStart: CGFloat = 0.5  // 초기 품질 (0.0~1.0)
    private let imageQualityDecrement: CGFloat = 0.1  // 매번 감소할 품질 (0.0~1.0)
    private let imageQualityMinimum: CGFloat = 0.1  // 최소 품질 (이 이상으로 유지)
    private let imageMaxSizeBytes: Int = 1 * 1024 * 1024  // 최대 크기: 5MB

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
        imageData: Data?
    ) async -> Result<T, NetworkError> {

        let url = router.baseURL.appendingPathComponent(router.path)
        let uploadEncoder = JSONEncoder()

        let jsonData: Data
        do {
            jsonData = try uploadEncoder.encode(body)
        } catch {
            Logger.error("JSON encoding failed: \(error.localizedDescription)")
            return .failure(.failToDecode("JSON encoding failed: \(error.localizedDescription)"))
        }

        // 이미지 데이터 압축
        let compressedImageData = imageData.flatMap { self.compressImage($0) }

        let result = await session.upload(
            multipartFormData: { formData in
                formData.append(jsonData, withName: "request", mimeType: "application/json")

                if let imageData = compressedImageData {
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

    // MARK: - Private Methods

    private func compressImage(_ data: Data) -> Data? {
        if let uiImage = UIImage(data: data) {
            var quality: CGFloat = imageQualityStart
            var compressedData = uiImage.jpegData(compressionQuality: quality) ?? data

            // 최대 크기 초과시 품질 낮춰서 재압축
            while compressedData.count > imageMaxSizeBytes && quality > imageQualityMinimum {
                quality -= imageQualityDecrement
                compressedData = uiImage.jpegData(compressionQuality: quality) ?? data
            }

            return compressedData.count <= imageMaxSizeBytes ? compressedData : nil
        }
        return data.count <= imageMaxSizeBytes ? data : nil
    }
}

