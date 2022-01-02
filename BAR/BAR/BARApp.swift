//
//  BARApp.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

@main
struct BARApp: App {
    let rooms: [Room] = []

    var body: some Scene {
        WindowGroup {
            RoomsView(rooms: rooms)
        }
    }
}
