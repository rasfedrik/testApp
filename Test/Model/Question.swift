//
//  Question.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import Foundation

// MARK: - Item
struct User: Codable {
    let userID: Int?
    let count: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case count, name
    }
}
