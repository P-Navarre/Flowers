//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import APIClient

protocol FlowerItemRepository {
    func getItems() async throws -> [FlowerItem]
}

final class FlowerItemRepositoryImpl {

    struct Dependencies {
        let api: DefaultAPI.Type
        init(api: DefaultAPI.Type = DefaultAPI.self) {
            self.api = api
        }
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

// MARK: - FlowerItemRepository
extension FlowerItemRepositoryImpl: FlowerItemRepository {
    
    func getItems() async throws -> [FlowerItem] {
        let dtoItems = try await DefaultAPI.itemsGetWithRequestBuilder().asyncExecute().body
        return dtoItems.map { item in
            FlowerItem(
                id: item.id.uuidString,
                title: item.title,
                categoryId: item.category,
                description: item.description ?? "Description manquante",
                imagesUrl: FlowerItem.ImageUrls(small: item.imageUrlSmall, full: item.imageUrlFull)
            )
        }
    }
}
