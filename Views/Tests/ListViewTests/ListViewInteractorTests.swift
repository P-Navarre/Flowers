//
//  Flowers
//
//  Pierre Navarre
//

import XCTest
import FlowerCategoryData
import FlowerItemData
import TestsHelpers

@testable import ListView

final class ListViewInteractorTests: XCTestCase {
    private var interactorUnderTesting: ListViewInteractor!
    
    private var listViewPresenterSpy: ListViewPresenterSpy!
    private var flowerCategoryDataSpy: FlowerCategoryDataSpy!
    private var flowerItemDataSpy: FlowerItemDataSpy!
    private var imageLoaderSpy: ImageLoaderSpy!
    
    override func setUp() {
        super.setUp()
        self.listViewPresenterSpy = ListViewPresenterSpy()
        self.flowerCategoryDataSpy = FlowerCategoryDataSpy()
        self.flowerItemDataSpy = FlowerItemDataSpy()
        self.imageLoaderSpy = ImageLoaderSpy()
        self.interactorUnderTesting = ListViewInteractor(
            presenter: self.listViewPresenterSpy,
            dependencies: .init(
                flowerCategoryData: flowerCategoryDataSpy,
                flowerItemData: flowerItemDataSpy,
                imageLoader: self.imageLoaderSpy
            )
        )
    }
    
    func test_load_CategoriesSuccess_and_ListingSuccess() async {
        // Arrange
        let categories = FlowerCategory.mockList
        self.flowerCategoryDataSpy.stubbedFetchResult = Result { categories }
        let items = FlowerItem.mockList
        self.flowerItemDataSpy.stubbedFetchResult = Result { items }
        
        // Act
        await self.interactorUnderTesting.loaadData()
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedWillStartLoading)
        XCTAssert(self.listViewPresenterSpy.invokedShowItems)
        
        let parameters = self.listViewPresenterSpy.invokedShowItemsParameters
        XCTAssertEqual(parameters?.items, items)
        let categoriesDict: [Int: String] = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0.name) }
        )
        XCTAssertEqual(parameters?.categories, categoriesDict)
    }
    
    func test_load_CategoriesError_and_ListingSuccess() async {
        // Arrange
        self.flowerCategoryDataSpy.stubbedFetchResult = Result { throw NSError() }
        let items = FlowerItem.mockList
        self.flowerItemDataSpy.stubbedFetchResult = Result { items }
        
        // Act
        await self.interactorUnderTesting.loaadData()
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedWillStartLoading)
        XCTAssertFalse(self.listViewPresenterSpy.invokedShowItems)
        XCTAssert(self.listViewPresenterSpy.invokedShowError)
    }
    
    func test_load_CategoriesSuccess_and_ListingError() async {
        // Arrange
        let categories = FlowerCategory.mockList
        self.flowerCategoryDataSpy.stubbedFetchResult = Result { categories }
        self.flowerItemDataSpy.stubbedFetchResult = Result { throw NSError() }
        
        // Act
        await self.interactorUnderTesting.loaadData()
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedWillStartLoading)
        XCTAssertFalse(self.listViewPresenterSpy.invokedShowItems)
        XCTAssert(self.listViewPresenterSpy.invokedShowError)
    }
    
    func test_prefetch() async {
        // Arrange
        let categories = FlowerCategory.mockList
        self.flowerCategoryDataSpy.stubbedFetchResult = Result { categories }
        let items = FlowerItem.mockList
        self.flowerItemDataSpy.stubbedFetchResult = Result { items }
        await self.interactorUnderTesting.loaadData()
        
        let prefetchCount: Int = items.isEmpty ? 0 : (0..<items.count).randomElement()!
        let itemIds = (0..<prefetchCount).map { index in
            items[index].id
        }
        
        // Act
        await self.interactorUnderTesting.prefetchItems(withIds: itemIds)
        
        // Assert
        let expectedUrls: [String] = itemIds
            .compactMap { id in
                items.first(where: { $0.id == id })?.imageUrls.small?.url
            }.map { url in
                url.absoluteString
            }.sorted()
        
        let invokedCacheImageCount = await self.imageLoaderSpy.getInvokedCacheImageCount()
        XCTAssertEqual(invokedCacheImageCount, expectedUrls.count)
        
        let invokedCacheImageParametersList = await self.imageLoaderSpy.getInvokedCacheImageParametersList()
        let invokedUrls: [String] = invokedCacheImageParametersList.map { url in
            url.absoluteString
        }.sorted()

        XCTAssertEqual(invokedUrls, expectedUrls)
    }
    
    func test_didSelectItem() async {
        // Arrange
        let categories = FlowerCategory.mockList
        self.flowerCategoryDataSpy.stubbedFetchResult = Result { categories }
        let items = FlowerItem.mockList
        self.flowerItemDataSpy.stubbedFetchResult = Result { items }
        await self.interactorUnderTesting.loaadData()
        
        guard let selected = (0..<items.count).randomElement() else { return }
        
        // Act
        await self.interactorUnderTesting.didSelectItem(withId: items[selected].id)
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedPresentDetail)
        let item = items[selected]
        XCTAssertEqual(self.listViewPresenterSpy.invokedPresentDetailParameters?.item, item)
        let categoriesDict: [Int: String] = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0.name) }
        )
        let category = categoriesDict[item.categoryId]
        XCTAssertEqual(self.listViewPresenterSpy.invokedPresentDetailParameters?.category, category)
    }
}
