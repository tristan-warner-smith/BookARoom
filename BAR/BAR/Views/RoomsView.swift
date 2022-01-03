//
//  RoomsView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct RoomsView: View {

    @ObservedObject var state: RoomsState
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                header
                .frame(maxWidth: .infinity, alignment: .leading)

                if !state.rooms.isEmpty {
                    list
                }
            }
        }
        .overlay(emptyState)
        .overlay(refresh, alignment: .topTrailing)
        .padding(.horizontal)
        .onChange(of: state.loadState) { loadState in
            withAnimation {
                let loading = loadState == .loading
                guard isLoading != loading else { return }

                isLoading = loading
            }
        }
    }

    var header: some View {
        VStack(alignment: .leading) {
            HStack {
            Text("Rooms")
                .font(.largeTitle)
            }
            // swiftlint:disable:next line_length
            Text("Odio nisi, lectus dis nulla. Ultrices maecenas vitae rutrum dolor ultricies donec risus sodales. Tempus quis et.")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }

    var emptyState: some View {
        Text("There are no rooms available to book")
            .italic()
            .padding()
            .opacity(state.rooms.isEmpty ? 1 : 0)
    }

    @ViewBuilder
    var list: some View {
        RoomsListView(rooms: state.rooms, book: { roomName in
            Task {
                await state.book(roomName: roomName)
            }
        })
    }

    var refresh: some View {
        Button(action: {
            Task {
                await state.load()
            }
        }, label: {
            Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
        })
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.thickMaterial)
        )
        .disabled(isLoading)
        .opacity(isLoading ? 0 : 1)
        .accessibilityLabel("Reload room availability")
    }
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {

        let roomScenarios: [(name: String, rooms: [RoomState] )] = [
            ("Has rooms", Preview.rooms),
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
