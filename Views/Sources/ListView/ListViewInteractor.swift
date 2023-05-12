//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import FlowerCategoryData
import FlowerItemData
import ImageLoader

protocol ListViewInteractorInput {
    func loaadData() async
    func prefetchItems(withIds itemIds: [String]) async
    func didSelectItem(withId itemIds: String) async
}

actor ListViewInteractor {
    
    struct Dependencies {
        let flowerCategoryData: FlowerCategoryData
        let flowerItemData: FlowerItemData
        let imageLoader: ImageLoaderProtocol
        
        init(flowerCategoryData: FlowerCategoryData = FlowerCategoryDataImpl(),
             flowerItemData: FlowerItemData = FlowerItemDataImpl(),
             imageLoader: ImageLoaderProtocol = ImageLoader.shared
        ) {
            self.flowerCategoryData = flowerCategoryData
            self.flowerItemData = flowerItemData
            self.imageLoader = imageLoader
        }
    }
    
    // MARK: - Properties
    private let presenter: ListViewPresenterInput
    private let dependencies: Dependencies

    private var items: [FlowerItem]?
    private var categories: [Int: String]?
    
    // MARK: - Initialization
    init(
        presenter: ListViewPresenterInput,
        dependencies: Dependencies = .init()
    ) {
        self.presenter = presenter
        self.dependencies = dependencies
    }
    
}

// MARK: - ListViewInteractorInput
extension ListViewInteractor: ListViewInteractorInput {
    
    func loaadData() async {
        await self.presenter.willStartLoading()
        
        do {
            async let categoriesResponse = self.dependencies.flowerCategoryData.fetch()
            async let listingResponse = self.dependencies.flowerItemData.fetch()

            let categoriesList = try await categoriesResponse
            
            let categories: [Int: String] = Dictionary(
                uniqueKeysWithValues: categoriesList.map { ($0.id, $0.name) }
            )
            self.categories = categories

            let items = try await listingResponse
            self.items = items

            await self.presenter.showItems(items, categories: categories)
        } catch let error {
            let retry: ()->Void = {
                Task { [weak self] in
                    await self?.loaadData()
                }
            }
            await self.presenter.showError(error, retryHandler: retry)
        }
        
    }
    
    func prefetchItems(withIds itemIds: [String]) async {
        let selection = itemIds.compactMap { id in
            self.items?.first { $0.id == id }
        }
        
        let urls: [URL] = selection.compactMap { item in
            item.imageUrls.small?.url
        }
    
        await withTaskGroup(of: Void.self, body: { group in
            urls.forEach { url in
                group.addTask {
                    await self.dependencies.imageLoader.cacheImage(from: url)
                }
            }
        })
    }
    
    func didSelectItem(withId itemId: String) async {
        guard let item = self.items?.first(where: { $0.id == itemId }) else { return }
        let category = self.categories?[item.categoryId]
        await self.presenter.presentDetail(for: item, category: category)
    }
}
