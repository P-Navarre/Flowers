//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import APIClient

protocol FlowerCategoryRepository {
    func get() async throws -> [FlowerCategory]
}

final class FlowerCategoryRepositoryImpl {

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

// MARK: - FlowerCategoryRepository
extension FlowerCategoryRepositoryImpl: FlowerCategoryRepository {
    func get() async throws -> [FlowerCategory] {
        let dtoItems: [CategoryDTO] = try await DefaultAPI.categoriesGetWithRequestBuilder().asyncExecute().body
        return dtoItems.map { item in
            FlowerCategory(id: item.id, name: item.name)
        }
    }
}
