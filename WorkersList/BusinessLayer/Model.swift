//
//  Model.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import Foundation

// MARK: - UsersData
struct UsersData: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let id: String?
    let avatarURL: String?
    let firstName, lastName, userTag, department: String?
    let position, birthday, phone: String?

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName, lastName, userTag, department, position, birthday, phone
    }
    
   

   
}
