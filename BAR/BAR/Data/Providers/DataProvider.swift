//
//  DataProvider.swift
//  BAR
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import Foundation

protocol DataProviding {
    func data(from url: URL) async throws -> Data
}

extension URLSession: DataProviding {
    func data(from url: URL) async throws -> Data {
        let (data, _) = try await self.data(from: url)
        return data
    }
}
