//
//  RoomsView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct RoomsView: View {
    let rooms: [Room]

    var body: some View {
        VStack {
            if rooms.isEmpty {
                Text("There are no rooms to book")
            } else {
                ForEach(rooms, id: \.name) { room in
                    RoomView(room: room)
                }
            }
        }
    }
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {

        let rooms = [
            Room(
                name: "Ljerka",
                spots: 43,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")
            ),
            Room(
                name: "Mostafa",
                spots: 4,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1497366858526-0766cadbe8fa?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80")
            )
        ]

        let roomScenarios: [(name: String, rooms: [Room] )] = [
            ("Has rooms", rooms),
            ("No rooms", [])
        ]

        return Group {
            ForEach(Preview.devices) { device in
                ForEach(roomScenarios, id: \.name) { scenario in
                    RoomsView(rooms: scenario.rooms)
                        .previewDevice(device)
                        .previewDisplayName("\(scenario.name) - \(device.rawValue)")
                }
            }
        }
    }
}
