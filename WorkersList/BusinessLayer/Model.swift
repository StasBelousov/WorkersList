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
    let firstName: String?
    let lastName: String?
    let userTag: String?
    let department: String?
    var departmentTitle: String? {
        get {
            switch department {
            case "back_office":
                return "Back Office"
            case "analytics":
                return "Analytics"
            case "android":
                return "Android"
            case "qa":
                return "QA"
            case "support":
                return "Support"
            case "ios":
                return "iOS"
            case "hr":
                return "HR"
            case "frontend":
                return "Frontend"
            case "design":
                return "Design"
            case "management":
                return "Management"
            case "backend":
                return "Backend"
            case "pr":
                return "PR"
            default:
                return "Other"
            }
        }
    }
    
    let position: String?
    let birthday: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName
        case lastName
        case userTag
        case position
        case birthday
        case phone
        case department
    }
    
}
