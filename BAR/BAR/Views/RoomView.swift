//
//  RoomView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct RoomView: View {
    let room: Room

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.secondary)
                .scaledToFit()

            HStack {
                VStack(alignment: .leading) {
                    Text(room.name)
                    Text("\(room.spots)")
                }
                Spacer()
                Button(action: {

                }, label: {
                    Text("Book!")
                })
            }
        }
        .padding(.horizontal)
        .background()
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {

        let room = Room(
            name: "Ljerka",
            spots: 43,
            // swiftlint:disable:next line_length
            thumbnail: URL(string: "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")
        )

        return Group {
            ForEach(Preview.devices) { device in
                RoomView(room: room)
                    .padding()
                    .background(.black)
                    .previewDevice(device)
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}
