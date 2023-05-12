//
//  Flowers
//
//  Pierre Navarre
//

import UIKit
import ImageLoader
import Style

public final class ImageView: UIImageView {
    struct Dependencies {
        let imageLoader: ImageLoaderProtocol
        init(imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
            self.imageLoader = imageLoader
        }
    }
    
    public var placeHolder: UIImage?
    
    private let dependencies: Dependencies
    private var url: URL?
    
    public override convenience init(frame: CGRect) {
        self.init(frame: frame, dependencies: .init())
    }
    
    init(frame: CGRect, dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadImage(from url: URL?) async {
        self.url = url
        self.image = self.placeHolder
        guard let url = url else { return }
        let image = try? await self.dependencies.imageLoader.image(from: url)
        guard url == self.url, // Check that the url has not been modified
              let image = image else { return }
        self.image = image
    }
}
