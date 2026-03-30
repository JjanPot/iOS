//
//  Router.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import Alamofire

public protocol Router {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var body: Encodable? { get }
    var encoding: Encoding? { get }
}

extension Router {
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method

        // 헤더 추가
        if let headers = headers {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.name) }
        }

        // body가 있으면 request body로 인코딩
        if let body = body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            request.httpBody = try encoder.encode(body)

            // body가 있어도 parameters가 있으면 query string으로 추가
            if let parameters = parameters {
                request = try URLEncoding.queryString.encode(request, with: parameters)
            }
            return request
        }

        // body가 없으면 parameters 처리
        let finalEncoding: Encoding
        if let customEncoding = encoding {
            finalEncoding = customEncoding
        } else if [.post, .put, .patch].contains(method) {
            finalEncoding = .json
        } else {
            finalEncoding = .url
        }

        // 파라미터 인코딩
        switch finalEncoding {
        case .json:
            request = try JSONEncoding.default.encode(request, with: parameters)
        case .url:
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}

// MARK: - Encoding

public enum Encoding {
    case json
    case url
}
