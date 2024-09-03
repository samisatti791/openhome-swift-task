//
//  PersonalityResponse.swift
//  Task
//
//  Created by Satti on 03/09/2024.
//

import Foundation
struct PersonalityResponse: Codable {
    let personality: Personality

    struct Personality: Codable {
        let name: String
        let imageFile: String

        enum CodingKeys: String, CodingKey {
            case name
            case imageFile = "image_file"
        }
    }
}
