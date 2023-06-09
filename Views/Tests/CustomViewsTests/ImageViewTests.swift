//
//  Flowers
//
//  Pierre Navarre
//

import XCTest
import TestsHelpers
import Style

@testable import CustomViews

@MainActor
final class ImageViewTests: XCTestCase {
    private var featureUnderTesting: ImageView!
    
    private var imageLoaderSpy: ImageLoaderSpy!
    
    override func setUp() {
        super.setUp()
        self.imageLoaderSpy = ImageLoaderSpy()
        self.featureUnderTesting = ImageView(frame: .zero, dependencies: .init(imageLoader: self.imageLoaderSpy))
    }
    
    func test_load_imageLoaderSuccess() async {
        // Arrange
        let placeholder = Image.placeHolderSquare.image
        self.featureUnderTesting.placeHolder = placeholder
        let url: URL? = URL.stub
        await self.imageLoaderSpy.setStubbedImageResult( Result { UIImage.stub } )
        
        // Act
        await self.featureUnderTesting.loadImage(from: url)
        
        // Assert
        let invokedImage = await self.imageLoaderSpy.getInvokedImage()
        XCTAssert(invokedImage)
        XCTAssert(self.featureUnderTesting.image == UIImage.stub)
    }
    
    func test_load_imageLoaderSuccessReturningNil() async {
        // Arrange
        let placeholder = Image.placeHolderSquare.image
        self.featureUnderTesting.placeHolder = placeholder
        let url: URL? = URL.stub
        await self.imageLoaderSpy.setStubbedImageResult( Result { nil } )
        
        // Act
        await self.featureUnderTesting.loadImage(from: url)
        
        // Assert
        let invokedImage = await self.imageLoaderSpy.getInvokedImage()
        XCTAssert(invokedImage)
        XCTAssert(self.featureUnderTesting.image == placeholder)
    }
    
    func test_load_imageLoaderFailure() async {
        // Arrange
        let placeholder = Image.placeHolderSquare.image
        self.featureUnderTesting.placeHolder = placeholder
        let url: URL? = URL.stub
        await self.imageLoaderSpy.setStubbedImageResult( Result { throw NSError() } )
        
        // Act
        await self.featureUnderTesting.loadImage(from: url)
        
        // Assert
        let invokedImage = await self.imageLoaderSpy.getInvokedImage()
        XCTAssert(invokedImage)
        XCTAssert(self.featureUnderTesting.image == placeholder)
    }
    
    func test_load_urlNil() async {
        // Arrange
        let placeholder = Image.placeHolderSquare.image
        self.featureUnderTesting.placeHolder = placeholder
        let url: URL? = nil
        await self.imageLoaderSpy.setStubbedImageResult( Result { UIImage.stub } )
        
        // Act
        await self.featureUnderTesting.loadImage(from: url)
        
        // Assert
        let invokedImage = await self.imageLoaderSpy.getInvokedImage()
        XCTAssertFalse(invokedImage)
        XCTAssert(self.featureUnderTesting.image == placeholder)
    }
    
}
