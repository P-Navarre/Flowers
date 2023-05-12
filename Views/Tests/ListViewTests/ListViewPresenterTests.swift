//
//  Flowers
//
//  Pierre Navarre
//

import XCTest
import FlowerCategoryData
import FlowerItemData
import TestsHelpers
import Style

@testable import ListView

final class ListViewPresenterTests: XCTestCase {
    private var presenterUnderTesting: ListViewPresenter!
    
    private var listViewControllerSpy: ListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        self.listViewControllerSpy = ListViewControllerSpy()
        self.presenterUnderTesting = ListViewPresenter(viewController: self.listViewControllerSpy)
    }
    
    func test_willStartLoading() async {
        // Arrange
        
        // Act
        await self.presenterUnderTesting.willStartLoading()
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedShowError)
            XCTAssert(self.listViewControllerSpy.invokedShowErrorParameters?.model == nil)
            XCTAssert(self.listViewControllerSpy.invokedShowLoader)
            XCTAssert(self.listViewControllerSpy.invokedShowLoaderParameters?.isRunning == true)
        }
    }
    
    func test_showItems() async {
        // Arrange
        let categories: [Int: String] = Dictionary(
            uniqueKeysWithValues: FlowerCategory.mockList.map { ($0.id, $0.name) }
        )
        let items = FlowerItem.mockList
        
        // Act
        await self.presenterUnderTesting.showItems(items, categories: categories)
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedShowError)
            XCTAssert(self.listViewControllerSpy.invokedShowErrorParameters?.model == nil)
            XCTAssert(self.listViewControllerSpy.invokedShowLoader)
            XCTAssert(self.listViewControllerSpy.invokedShowLoaderParameters?.isRunning == false)
            
            XCTAssert(self.listViewControllerSpy.invokedShowContent)
            let model = self.listViewControllerSpy.invokedShowContentParameters?.model
            XCTAssertEqual(model?.count, items.count)
            
            guard items.count > 0 else { return }
            let index = (0..<items.count).randomElement()!
            let cellModel = model?[index]
            let items = items[index]
            let style = ListViewPresenter.FlowerItemCellStyle()
            XCTAssertEqual(cellModel?.id, items.id)
            XCTAssertEqual(cellModel?.placeHolder, Image.placeHolderSquare)
            XCTAssertEqual(cellModel?.imageUrl, items.imageUrls.small?.url)
            XCTAssertEqual(cellModel?.category.string, categories[items.categoryId])
            XCTAssert(cellModel?.category.hasAttributes(style.categoryAttributes) == true)
            XCTAssertEqual(cellModel?.title.string, items.title)
            XCTAssert(cellModel?.title.hasAttributes(style.titleAttributes) == true)
        }
    }
    
    func test_showError() async {
        // Arrange
        let error = NSError()
        
        let exp = expectation(description: "retry")
        let retry: ()->Void = {
            exp.fulfill()
        }
        
        // Act
        await self.presenterUnderTesting.showError(error, retryHandler: retry)
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedShowLoader)
            XCTAssert(self.listViewControllerSpy.invokedShowLoaderParameters?.isRunning == false)
            
            XCTAssertEqual(self.listViewControllerSpy.invokedShowErrorCount, 2)
            XCTAssert(self.listViewControllerSpy.invokedShowErrorParametersList[0].model == nil)
            
            let model = self.listViewControllerSpy.invokedShowErrorParametersList[1].model
            let style = ListViewPresenter.ErrorViewStyle()
            XCTAssertEqual(model?.message.string, Localized.errorMessage.stirng)
            XCTAssert(model?.message.hasAttributes(style.messageAttributes) == true)
            XCTAssertEqual(model?.buttonBackground, style.buttonBackgroundColor)
            XCTAssertEqual(model?.buttonTitle.string, Localized.loadRetryButton.stirng)
            XCTAssert(model?.buttonTitle.hasAttributes(style.buttonTitleAttributes) == true)
            model?.retryHandler()
            waitForExpectations(timeout: 0)
        }
        
    }
    
    func test_presentDetail() async {
        // Arrange
        let item = FlowerItem.mockList.randomElement()!
        let category = "category_name"
        
        // Act
        await self.presenterUnderTesting.presentDetail(for: item, category: category)
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedPresentDetail)
            XCTAssertEqual(self.listViewControllerSpy.invokedPresentDetailParameters?.item, item)
            XCTAssertEqual(self.listViewControllerSpy.invokedPresentDetailParameters?.category, category)
        }
    }
}
