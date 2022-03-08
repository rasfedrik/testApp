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
    let tags: [String?]
    let questionID: Int?
    let answersCount: Int?
    let owner: Owner?
    let lastEditDate: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case answersCount = "answer_count"
        case owner, tags, title
        case lastEditDate = "last_edit_date"
    }
}

struct Owner: Codable {
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
    }
}


