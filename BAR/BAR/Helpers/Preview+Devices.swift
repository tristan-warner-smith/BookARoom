//
//  Preview+Devices.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import SwiftUI

struct Preview {
    static let devices: [PreviewDevice] = [
        "iPad 13 mini",
        "iPad Pro (11-inch) (3rd generation)"
    ].map { PreviewDevice(rawValue: $0) }
}

extension PreviewDevice: Identifiable {
    public var id: String { rawValue }
}
