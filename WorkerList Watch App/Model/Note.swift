//
//  Note.swift
//  WorkerList Watch App
//
//  Created by Станислав Белоусов on 23.12.2023.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
}
