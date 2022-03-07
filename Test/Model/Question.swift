//
//  Question.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import Foundation

struct Response: Codable {
    let items: [Question]?
}

struct Question: Codable {
    let questionID: Int?
    let answersCount: Int?
    let user: User?
    let lastEditDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case answersCount = "answer_count"
        case user
        case lastEditDate = "last_edit_date"
    }
}

struct User: Codable {
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
    }
}


