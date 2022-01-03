//
//  RoomsState.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

enum RoomsLoadState: Equatable {
    case notLoaded
    case loading
    case loaded
    case failed(_ error: String)
}

@MainActor class RoomsState: ObservableObject {
    @Published private(set) var rooms: [RoomState]
    @Published private(set) var loadState: RoomsLoadState

    private let roomsProvider: RoomsDataProviding
    private let bookingCoordinator: RoomBookingCoordinating

    init(roomsProvider: RoomsDataProviding = RoomsDataProvider(dataProvider: URLSession.shared),
         bookingCoordinator: RoomBookingCoordinating = RoomBookingCoordinator(dataProvider: URLSession.shared)) {
        self.roomsProvider = roomsProvider
        self.bookingCoordinator = bookingCoordinator
        self.rooms = []
        self.loadState = .notLoaded
    }

    func load() async {

        do {
            loadState = .loading

            rooms = try await roomsProvider.rooms()

            loadState = .loaded
        } catch let error {
            loadState = .failed(error.localizedDescription)
        }
    }

    func book(roomName: String) async {

        do {
            try await bookingCoordinator.book(roomName: roomName)

            // NOTE: If we've just booked, let's trigger a background data refresh to show the updated values
            Task {
                await load()
            }
        } catch let error {
            assertionFailure("Failed to book room \(roomName) due to \(error)")
        }
    }
}
