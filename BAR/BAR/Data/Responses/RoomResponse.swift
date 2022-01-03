//
//  RoomResponse.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import Foundation

struct RoomResponse: Codable {
    let name: String
    let spots: Int
    let thumbnail: URL?
}
