//
//  Some.swift
//  BARTests
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

@testable import BAR

enum Some {
    static let roomName = "The Emerald Room"
    static let roomState = RoomState(name: Some.roomName, numberOfAvailableSpots: 1, thumbnail: nil)
    static let error: Error = StubError.some
}

enum StubError: Error {
    case some
}
