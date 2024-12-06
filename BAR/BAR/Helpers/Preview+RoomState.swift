//
//  Preview+RoomState.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

import Foundation

extension Preview {
    static let rooms = [
        RoomState(
            name: "Multiple Spots",
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
            name: "Landscape",
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
}
