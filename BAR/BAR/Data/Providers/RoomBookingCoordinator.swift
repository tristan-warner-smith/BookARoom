//
//  RoomBookingCoordinator.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import Foundation

protocol RoomBookingCoordinating {
    func book(roomName: String) async throws
}

actor RoomBookingCoordinator: RoomBookingCoordinating {
    private let bookingURL: URL
    private lazy var decoder: JSONDecoder = JSONDecoder()
    private let dataProvider: DataProviding

    init(
        dataProvider: DataProviding = URLSession.shared,
        url: URL? = URL(string: "https://wetransfer.github.io/bookRoom.json")
    ) {
        guard let url = url else {
            fatalError("RoomBookingProvider URL was not a valid URL")
        }
        self.dataProvider = dataProvider
        self.bookingURL = url
    }

    func book(roomName: String) async throws {
        debugPrint("Book room '\(roomName)' requested")

        let data = try await dataProvider.data(from: bookingURL)
        // NOTE: The endpoint is hardcoded to always report success so handling it here is of minimal value
        _ = try decoder.decode(BookRoomResponse.self, from: data)
    }
}
