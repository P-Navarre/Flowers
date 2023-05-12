//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import FlowerItemData
import FlowerCategoryData

public extension FlowerItem {
    private enum Constants {
        static let listCount: Int = 50
    }
    
    static var mockList: [FlowerItem] {        
        let categories = FlowerCategory.mockList.map { $0.id }
        
        return (0..<Constants.listCount).compactMap { index in
            guard let category: Int = categories.randomElement() else {
                return nil
            }
            
            return FlowerItem(
                id: String(index),
                title: "title_\(index)",
                categoryId: category,
                description: "description_\(index)",
                imagesUrl: ImageUrls(
                    small: Bool.random(with: 0.75) ? "small_url_\(index)" : nil,
                    full: Bool.random(with: 0.75) ? "thumb_url_\(index)" : nil
                    )
            )
        }
        
    }
    
}
