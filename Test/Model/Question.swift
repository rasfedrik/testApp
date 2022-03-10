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
    let answersCount: Int?
    let owner: Owner?
    let lastEditDate: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case lastEditDate = "last_edit_date"
        case answersCount = "answer_count"
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
    let isAccepted: Bool?
    let score: Int?
    let lastEditDate: Int?

    enum CodingKeys: String, CodingKey {
        case answerID = "answer_id"
        case isAccepted = "is_accepted"
        case lastEditDate = "last_edit_date"
        case owner, title, body, score
    }
}

struct Owner: Codable {
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
    }
}

