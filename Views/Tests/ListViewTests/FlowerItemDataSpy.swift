//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import FlowerCategoryData
import FlowerItemData

class FlowerItemDataSpy: FlowerItemData {

    var invokedFetch = false
    var invokedFetchCount = 0
    var stubbedFetchResult: Result<[FlowerItem], Error>!
    
    func fetch() async throws -> [FlowerItem] {
        invokedFetch = true
        invokedFetchCount += 1
        return try await Task { try stubbedFetchResult.get() }.value
    }
}

class FlowerCategoryDataSpy: FlowerCategoryData {

    var invokedFetch = false
    var invokedFetchCount = 0
    var stubbedFetchResult: Result<[FlowerCategory], Error>!

    func fetch() async throws -> [FlowerCategory] {
        invokedFetch = true
        invokedFetchCount += 1
        return try await Task { try stubbedFetchResult.get() }.value
    }
}
