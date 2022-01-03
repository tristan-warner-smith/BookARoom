//
//  StubRoomsDataProvider.swift
//  BARTests
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

@testable import BAR

final class StubRoomsDataProvider: RoomsDataProviding {

    var errorToThrow: Error?
    var roomsToReturn: [RoomState] = []

    func rooms() async throws -> [RoomState] {
        if let error = errorToThrow {
            throw error
        } else {
            return roomsToReturn
        }
    }
}
