//
//  ResponseBody.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import Foundation

/*
 {
     "status": 200,
     "message": "요청 성공",
     "data": { ... }
 }

 // 생성 성공 (201 Created)
 {
     "status": 201,
     "message": "생성 완료",
     "data": { ... }
 }

 // 삭제 성공 (204 No Content)
 {
     "status": 204,
     "message": "처리 완료",
     "data": null
 }

 */

public struct ResponseBody<T: Decodable>: Decodable {
    var status: Int
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
}

// 에러 응답용 (data 없이 code, message만)
public struct ErrorResponseBody: Decodable {
    var status: Int?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
