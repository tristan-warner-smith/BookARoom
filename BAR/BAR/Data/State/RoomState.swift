//
//  RoomState.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import Foundation

struct RoomState {
    let name: String
    let numberOfAvailableSpots: Int
    let thumbnail: URL?
}

extension RoomState: Equatable {}
