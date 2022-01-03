//
//  RoomsView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct RoomsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var state: RoomsState

    enum Style {
        static let gridItemSpacing: Double = 20
        static let numberOfCardsInGrid: Int = 3
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Rooms")
                        .font(.largeTitle)

                    // swiftlint:disable:next line_length
                    Text("Odio nisi, lectus dis nulla. Ultrices maecenas vitae rutrum dolor ultricies donec risus sodales. Tempus quis et.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if !state.rooms.isEmpty {
                    list
                }
            }
        }
        .overlay(emptyView.opacity(state.rooms.isEmpty ? 1 : 0))
        .padding(.horizontal)
    }

    var emptyView: some View {
        Text("There are no rooms available to book")
            .italic()
            .padding()
    }

    @ViewBuilder
    var list: some View {

        if horizontalSizeClass == .regular {
            let columns = (0..<Style.numberOfCardsInGrid)
                .map { _ in
                    GridItem(.flexible(), spacing: Style.gridItemSpacing)
                }
            LazyVGrid(columns: columns) {
                ForEach(state.rooms, id: \.name) { room in
                    RoomView(room: room, book: { roomName in
                        Task {
                            await state.book(roomName: roomName)
                        }
                    })
                }
            }
        } else {
            VStack(spacing: 0) {
                ForEach(state.rooms, id: \.name) { room in
                    RoomView(room: room, book: { roomName in
                        Task {
                            await state.book(roomName: roomName)
                        }
                    })
                }
            }
        }
    }
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {

        let rooms = [
            RoomState(
                name: "Many Spots",
                numberOfAvailableSpots: 43,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")
            ),
            RoomState(
                name: "Single Spot",
                numberOfAvailableSpots: 1,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1497366858526-0766cadbe8fa?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80")
            ),
            RoomState(
                name: "Empty",
                numberOfAvailableSpots: 0,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1497366858526-0766cadbe8fa?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80")
            ),
            RoomState(
                name: "Helmold",
                numberOfAvailableSpots: 86,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1539872209618-fb1770aa6ff8?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1251&q=80")
            ),
            RoomState(
                name: "Portrait Image",
                numberOfAvailableSpots: 16,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1540760029765-138c8f6d2eac?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=634&q=80")
            )
        ]

        let roomScenarios: [(name: String, rooms: [RoomState] )] = [
            ("Has rooms", rooms),
            ("No rooms", [])
        ]

        return Group {
            ForEach(Preview.devices) { device in
                ForEach(roomScenarios, id: \.name) { scenario in
                    let roomProvider = PreviewRoomProvider(rooms: scenario.rooms)
                    let state = RoomsState(roomsProvider: roomProvider)

                    RoomsView(state: state)
                        .task { await state.load() }
                        .previewDevice(device)
                        .previewDisplayName("\(scenario.name) - \(device.rawValue)")
                }
            }
        }
    }
}

private final class PreviewRoomProvider: RoomsDataProviding {
    var roomsToReturn: [RoomState] = []

    init(rooms: [RoomState]) {
        roomsToReturn = rooms
    }

    func rooms() async throws -> [RoomState] {
        roomsToReturn
    }
}
