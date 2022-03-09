//
//  Question.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import Foundation

struct ResponseQuestion: Codable {
    let items: [Question]?
}

struct Question: Codable {
    let tags: [String?]
    let questionID: Int?
    let answer: Answer?
    let answerCount: Int?
    let owner: Owner?
    let lastEditDate: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case lastEditDate = "last_edit_date"
        case answerCount = "answer_count"
        case owner, tags, title, answer
    }
}

struct ResponseAnswer: Codable {
    let items: [Answer]?
}

struct Answer: Codable {
    let owner: Owner?
    let answerID: Int?
    let title: String?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case answerID = "answer_id"
        case owner, title, body
    }
}

struct Owner: Codable {
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
    }
}

