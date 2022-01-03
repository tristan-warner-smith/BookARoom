//
//  RoomThumbnailView.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct RoomThumbnailView: View {
    @State var animateProgress: Bool = false
    let url: URL?

    enum Style {
        static let minimumHeight: Double = 44
        static let imageCornerRadius: Double = 11
        static let imageAspectRatio: Double = 328.0 / 220.0
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: Style.minimumHeight)
                    .rotationEffect(.degrees(animateProgress ? 0 : -180), anchor: .center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: Style.imageCornerRadius, style: .continuous)
                            .fill(.thickMaterial)
                    )
                    .onAppear {
                        withAnimation(.default.speed(0.5).repeatForever(autoreverses: false)) {
                            animateProgress = true
                        }
                    }
                    .onDisappear { animateProgress = false }
            case .failure:
                VStack {
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: Style.minimumHeight)

                    Text("Couldn't fetch the image for this room")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: Style.imageCornerRadius, style: .continuous)
                        .fill(.thickMaterial)
                )
            case .success(let image):
                image
                    .resizable()

                    .cornerRadius(Style.imageCornerRadius)
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(Style.imageAspectRatio, contentMode: .fill)
        .frame(maxWidth: .infinity)
    }
}

struct RoomThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        // NOTE: To see these states you have to run the preview
        let scenarios: [(name: String, url: URL?)] = [
            ("No URL", nil),
            // swiftlint:disable:next line_length
            ("Valid URL", URL(string: "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")),
            ("Invalid URL", URL(string: "https://images.unsploosh"))
        ]
        return Group {
            ForEach(scenarios, id: \.name) { scenario in
                RoomThumbnailView(url: scenario.url)
                    .previewDisplayName(scenario.name)
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}
