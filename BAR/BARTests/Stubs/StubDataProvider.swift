//
//  StubDataProvider.swift
//  BARTests
//
//  Created by Tristan Warner-Smith on 03/01/2022.
//

import Foundation
@testable import BAR

final class StubDataProvider: DataProviding {

    var errorToThrow: Error?
    var dataToReturn: Data?

    func data(from url: URL) async throws -> Data {
        if let error = errorToThrow {
            throw error
        } else if let data = dataToReturn {
            return data
        } else {
            throw StubError.some
        }
    }
}
