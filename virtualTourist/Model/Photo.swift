//
//  Photo.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 11/02/21.
//

import Foundation

struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
}
