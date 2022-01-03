//
//  BARApp.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

@main
struct BARApp: App {
    @StateObject var roomsState: RoomsState = .init()

    var body: some Scene {
        WindowGroup {
            RoomsView(state: roomsState)
                .task {
                    await roomsState.load()
                }
        }
    }
}
