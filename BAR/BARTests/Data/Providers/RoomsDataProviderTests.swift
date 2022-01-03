//
//  RoomsDataProviderTests.swift
//  BARTests
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import XCTest
@testable import BAR

final class RoomsDataProviderTests: XCTestCase {

    func test_rooms_withErrorResponse_throws() async {
        let dataProvider = StubDataProvider()
        dataProvider.errorToThrow = StubError.some

        let roomsProvider = RoomsDataProvider(
            dataProvider: dataProvider
        )

        do {
            _ = try await roomsProvider.rooms()
            XCTFail("Should have thrown an error")
        } catch let error { debugPrint("Threw \(error)") }
    }

    func test_rooms_withInvalidResponse_throws() async {
        let dataProvider = StubDataProvider()
        let invalidData = Data()
        dataProvider.dataToReturn = invalidData

        let roomsProvider = RoomsDataProvider(
            dataProvider: dataProvider
        )

        do {
            _ = try await roomsProvider.rooms()
            XCTFail("Should have thrown an error")
        } catch let error { debugPrint(error) }
    }

    func test_rooms_withValidResponse_returnsData() async throws {

        let roomResponse = RoomResponse(name: "Room", spots: 1, thumbnail: nil)
        let roomsResponse = RoomsResponse(rooms: [roomResponse])
        let encoder = JSONEncoder()
        let validResponseData = try encoder.encode(roomsResponse)

        let dataProvider = StubDataProvider()
        dataProvider.dataToReturn = validResponseData

        let roomsProvider = RoomsDataProvider(
            dataProvider: dataProvider
        )

        do {
            let rooms = try await roomsProvider.rooms()
            XCTAssertEqual(rooms.count, 1)

            let roomState = try XCTUnwrap(rooms.first)
            XCTAssertEqual(roomState.name, roomResponse.name)
            XCTAssertEqual(roomState.numberOfAvailableSpots, roomResponse.spots)
            XCTAssertEqual(roomState.thumbnail, roomResponse.thumbnail)
        } catch let error {
            XCTFail("Should not throw an error but threw \(error)")
        }
    }
}
