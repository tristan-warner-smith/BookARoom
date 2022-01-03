//
//  RoomsDataProvider.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import Foundation

protocol RoomsDataProviding {
    func rooms() async throws -> [RoomState]
}

actor RoomsDataProvider: RoomsDataProviding {
    private let dataProvider: DataProviding
    private let roomsURL: URL
    private lazy var decoder: JSONDecoder = JSONDecoder()

    init(
        dataProvider: DataProviding = URLSession.shared,
        url: URL? = URL(string: "https://wetransfer.github.io/rooms.json")
    ) {
        guard let url = url else {
            fatalError("RoomsDataProvider URL was not a valid URL")
        }
        self.dataProvider = dataProvider
        self.roomsURL = url
    }

    func rooms() async throws -> [RoomState] {

        let data = try await dataProvider.data(from: roomsURL)
        let roomsResponse = try decoder.decode(RoomsResponse.self, from: data)
        let roomStates = roomsResponse
            .rooms
            .map { roomResponse in
                RoomState(
                    name: roomResponse.name,
                    numberOfAvailableSpots: roomResponse.spots,
                    thumbnail: roomResponse.thumbnail
                )
            }.sorted(by: { first, second in
                first.numberOfAvailableSpots > second.numberOfAvailableSpots
            })

        return roomStates
    }
}
