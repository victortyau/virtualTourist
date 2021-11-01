//
//  Photo.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/31/21.
//

import Foundation

struct Photos: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: String
    let title: String
}
