//
//  Question.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import Foundation

struct JSONResponse: Codable {
    let items: [Question]?
}

struct Question: Codable {
    let count: Int?
    let name: String?
    let questionName: String?
    let answersCount: Int?
    let userName: String?
    let dateOfLastModification: Int?
}

