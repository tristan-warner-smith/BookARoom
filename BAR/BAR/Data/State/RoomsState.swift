//
//  RoomsState.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

enum RoomsLoadingState: Equatable {
    case notLoaded
    case loading
    case loaded
    case failed(_ error: String)
}

@MainActor class RoomsState: ObservableObject {
    @MainActor @Published private(set) var rooms: [RoomState]
    @MainActor @Published private(set) var loadState: RoomsLoadingState
    @MainActor @Published private(set) var lastChecked: Date?

    private var roomsProvider: RoomsDataProviding

    init(roomsProvider: RoomsDataProviding = RoomsDataProvider(dataProvider: URLSession.shared)) {
        self.roomsProvider = roomsProvider
        self.rooms = []
        self.loadState = .notLoaded
    }

    func load() async {

        do {
            loadState = .loading

            rooms = try await roomsProvider.rooms()

            lastChecked = Date()
            loadState = .loaded
        } catch let error {
            loadState = .failed(error.localizedDescription)
        }
    }

    func book(roomName: String) async {
        assertionFailure("Not yet implemented")
    }
}
