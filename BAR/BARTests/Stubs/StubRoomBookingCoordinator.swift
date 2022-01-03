//
//  StubRoomBookingCoordinator.swift
//  BARTests
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

@testable import BAR

final class StubRoomBookingCoordinator: RoomBookingCoordinating {

    var bookCalls: Int = 0

    func book(roomName: String) async throws {
        bookCalls += 1
    }
}
