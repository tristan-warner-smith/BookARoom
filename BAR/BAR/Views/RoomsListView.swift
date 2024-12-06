//
//  RoomsListView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

import SwiftUI

struct RoomsListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let rooms: [RoomState]
    let book: (String) -> Void

    enum Style {
        static let gridItemSpacing: Double = 20
        static let numberOfCardsInGrid: Int = 3
    }

    var body: some View {
        if rooms.count == 0 {
            EmptyView()
        } else if horizontalSizeClass == .regular {
            let columns = (0..<Style.numberOfCardsInGrid)
                .map { _ in
                    GridItem(.flexible(), spacing: Style.gridItemSpacing)
                }
            LazyVGrid(columns: columns) {
                ForEach(rooms, id: \.name) { room in
                    RoomView(room: room, book: { roomName in
                        book(roomName)
                    })
                }
            }
        } else {
            VStack(spacing: 0) {
                ForEach(rooms, id: \.name) { room in
                    RoomView(room: room, book: { roomName in
                        book(roomName)
                    })
                }
            }
        }
    }
}

struct RoomsListView_Previews: PreviewProvider {
    static var previews: some View {

        let roomScenarios: [(name: String, rooms: [RoomState] )] = [
            ("Has rooms", Preview.rooms),
            ("No rooms", [])
        ]

        return Group {
            ForEach(Preview.devices) { device in
                ForEach(roomScenarios, id: \.name) { scenario in
                    ScrollView(.vertical) {
                        RoomsListView(rooms: scenario.rooms, book: { _ in })
                            .padding()
                    }
                    .previewLayout(.sizeThatFits)
                    .previewDevice(device)
                    .previewDisplayName("\(scenario.name) - \(device.rawValue)")
                }
            }
        }
    }
}
