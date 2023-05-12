//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public protocol FlowerCategoryData {
    func fetch() async throws -> [FlowerCategory]
}

final public class FlowerCategoryDataImpl {

    struct Dependencies {
        let repository: FlowerCategoryRepository
        init(repository: FlowerCategoryRepository = FlowerCategoryRepositoryImpl()) {
            self.repository = repository
        }
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public init() {
        self.dependencies = Dependencies()
    }

}

// MARK: - FlowerCategoryData
extension FlowerCategoryDataImpl: FlowerCategoryData {

    public func fetch() async throws -> [FlowerCategory] {
        try await self.dependencies.repository.get()
    }
}


