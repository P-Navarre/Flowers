//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public protocol FlowerItemData {
    func fetch() async throws -> [FlowerItem]
}

final public class FlowerItemDataImpl {

    struct Dependencies {
        let repository: FlowerItemRepository
        init(repository: FlowerItemRepository = FlowerItemRepositoryImpl()) {
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

// MARK: - FlowerItemData
extension FlowerItemDataImpl: FlowerItemData {

    public func fetch() async throws -> [FlowerItem] {
        try await self.dependencies.repository.getItems()
    }
}
