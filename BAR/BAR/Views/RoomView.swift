//
//  RoomView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct RoomView: View {
    let room: RoomState
    let book: (String) -> Void

    enum Style {
        static let minimumHeight: Double = 44
        static let cardTitle: Font = .title2.weight(.bold)
    }

    var body: some View {
        VStack(spacing: 12) {

            imageView

            HStack(alignment: .top) {
                labelsView
                Spacer()
                bookView.opacity(room.numberOfAvailableSpots > 0 ? 1 : 0)
            }
            .layoutPriority(1)
        }
        .padding(.vertical)
    }

    var imageView: some View {

        RoomThumbnailView(url: room.thumbnail)
    }

    var labelsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(room.name)
                .font(Style.cardTitle)

            Text(spotsDisplay())
                .foregroundColor(.accentColor)
        }
    }

    var bookView: some View {
        Button(
            action: { book(room.name) },
            label: {
                Text("Book!")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(minHeight: Style.minimumHeight)
                    .padding(.horizontal, 25)
                    .background(
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color.accentColor)
                    )
            }).buttonStyle(.plain)
    }

    func spotsDisplay() -> String {
        switch room.numberOfAvailableSpots {
        case 0:
            return "No spots remaining"
        case 1:
            return "1 spot remaining"
        default:
            return "\(room.numberOfAvailableSpots) spots remaining"
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {

        let scenarios: [RoomState] = [
            ("No spots", 0),
            ("1 spot", 1),
            ("Many spots", 42)
        ].map { name, spots in
            RoomState(
                name: name,
                numberOfAvailableSpots: spots,
                // swiftlint:disable:next line_length
                thumbnail: URL(string: "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")
            )
        }

        return Group {
                ForEach(scenarios, id: \.name) { scenario in
                    RoomView(room: scenario, book: { _ in })
                        .frame(maxWidth: 500)
                        .previewLayout(.sizeThatFits)
                        .previewDisplayName(scenario.name)
                }
        }
    }
}
