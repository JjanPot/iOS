//
//  APINetworkLogger.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import Alamofire

public final class APINetworkLogger: EventMonitor {
    public let queue = DispatchQueue(label: "api.network.logger")

    public init() {}

    // Event called when a request is about to start
    public func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        #if DEBUG
        let url = urlRequest.url?.absoluteString ?? "No URL"
        let method = urlRequest.httpMethod ?? "Unknown"
        let bodyString = urlRequest.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "No Body"

        Logger.network("➡️ [REQUEST] \(method) \(url)")
        Logger.network("   Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        Logger.network("   Body: \(bodyString)")
        #endif
    }

    // Event called when an UploadRequest creates its Uploadable
    public func request(_ request: UploadRequest, didCreateUploadable uploadable: UploadRequest.Uploadable) {
        #if DEBUG
        let url = request.request?.url?.absoluteString ?? "No URL"
        let method = request.request?.httpMethod ?? "Unknown"

        Logger.network("📤 [UPLOAD] \(method) \(url)")

        switch uploadable {
        case .data(let data):
            Logger.network("   Type: Data (\(data.count) bytes)")
            
        case .file(let fileURL, _):
            Logger.network("   Type: File (\(fileURL.lastPathComponent))")
        case .stream(let inputStream):
            Logger.network("   Type: Stream")
        }
        #endif
    }

    // Event called when multipart form data is created
    public func request(_ request: UploadRequest, didCreateMultipartFormData multipartFormData: MultipartFormData) {
        #if DEBUG
        Logger.network("📦 [MULTIPART] Content-Length: \(multipartFormData.contentLength) bytes")
        #endif
    }

    // Event called whenever a DataRequest has parsed a response.
    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        #if DEBUG
        let status = response.response?.statusCode ?? -1
        var bodyString = ""
        if let data = response.data, let str = String(data: data, encoding: .utf8) {
            bodyString = str
        }
        // 상태 코드에 따라 이모지 구분
        let emoji = (200..<300).contains(status) ? "✅" : "❌"
        Logger.network("\(emoji) [RESPONSE] status: \(status) for: \(request)")
        Logger.network("   Body: \(bodyString)")
        #endif
    }
}
