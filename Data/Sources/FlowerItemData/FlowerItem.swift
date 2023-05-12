//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public struct FlowerItem {
    
    public var id: String
    public var title: String
    public var categoryId: Int
    public var description: String
    public var imageUrls: ImageUrls
    
    public init(id: String, title: String, categoryId: Int, description: String, imagesUrl: ImageUrls) {
        self.id = id
        self.title = title
        self.categoryId = categoryId
        self.description = description
        self.imageUrls = imagesUrl
    }
    
}

extension FlowerItem: Equatable {
    public static func == (lhs: FlowerItem, rhs: FlowerItem) -> Bool {
        lhs.id == rhs.id
    }
}

public extension FlowerItem {
    
    struct ImageUrls {
        public var small: String?
        public var full: String?
        
        public init(small: String? = nil, full: String? = nil) {
            self.small = small
            self.full = full
        }
    }
    
}
