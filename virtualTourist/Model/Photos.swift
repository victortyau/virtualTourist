//
//  Photos.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 11/03/21.
//

import Foundation

struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}
