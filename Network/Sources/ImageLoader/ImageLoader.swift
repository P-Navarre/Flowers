//
//  Flowers
//
//  Pierre Navarre
//

import UIKit

// Protocol definition for the class responsible for loading and caching image data
public protocol ImageLoaderProtocol: AnyActor {
    func cacheImage(from url: URL) async
    func image(from url: URL) async throws -> UIImage?
}

// Simplistic implementation
public actor ImageLoader: ImageLoaderProtocol {
    public static let shared: ImageLoader = ImageLoader()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    public func cacheImage(from url: URL) async {
        _ = try? await self.session.data(from: url)
    }
    
    public func image(from url: URL) async throws -> UIImage? {
        try await UIImage(data: self.session.data(from: url).0)
    }
}
