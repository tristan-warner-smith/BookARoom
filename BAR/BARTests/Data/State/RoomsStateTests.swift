//
//  RoomsStateTests.swift
//  BARTests
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

import Combine
import XCTest
@testable import BAR

final class RoomsStateTests: XCTestCase {

    func test_defaultsAreExpected() async {
        let roomsProvider = StubRoomsDataProvider()
        roomsProvider.roomsToReturn = [Some.roomState]

        let state = await RoomsState(roomsProvider: roomsProvider)
        let rooms = await state.rooms
        let loadState = await state.loadState
        let lastChecked = await state.lastChecked

        XCTAssertEqual(rooms, [])
        XCTAssertEqual(loadState, .notLoaded)
        XCTAssertNil(lastChecked)
    }

    // MARK: - Load

    @MainActor func test_load_succeeds_showsExpectedStateChanges() async throws {
        let roomsProvider = StubRoomsDataProvider()
        roomsProvider.roomsToReturn = [Some.roomState]

        let statesChange = expectation(description: "States should change")

        let state = RoomsState(roomsProvider: roomsProvider)
        var statesSeen = [RoomsLoadingState]()
        var cancellables = Set<AnyCancellable>()
        state
            .$loadState
            .sink { loadState in
                statesSeen.append(loadState)

                if statesSeen.count == 3 {

                    statesChange.fulfill()
                }
        }.store(in: &cancellables)

        await state.load()

        waitForExpectations(timeout: 1)

        let first = try XCTUnwrap(statesSeen.first)
        let second = try XCTUnwrap(statesSeen.dropFirst().first)
        let third = try XCTUnwrap(statesSeen.dropFirst(2).first)
        XCTAssertEqual(first, .notLoaded)
        XCTAssertEqual(second, .loading)
        XCTAssertEqual(third, .loaded)

        let lastChecked = state.lastChecked
        XCTAssertNotNil(lastChecked)

        let rooms = state.rooms
        XCTAssert(!rooms.isEmpty)

        cancellables.forEach { $0.cancel() }
    }

    func test_load_fails_hasExpectedLoadState() async {
        let roomsProvider = StubRoomsDataProvider()
        let errorDescription = Some.error.localizedDescription
        roomsProvider.errorToThrow = Some.error

        let state = await RoomsState(roomsProvider: roomsProvider)

        await state.load()

        let loadState = await state.loadState

        guard case .failed(let error) = loadState else {
            return XCTFail("Should be in failed state but was \(loadState)")
        }

        XCTAssertEqual(error, errorDescription)
    }

    // MARK: - Book

    func test_book() async {
        XCTFail("Not implemented yet")
    }
}
