//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import FlowerCategoryData

public extension FlowerCategory {
    private enum Constants {
        static let categoryCount: Int = 10
    }

    static var mockList: [FlowerCategory] {
        (0..<Constants.categoryCount).map { index in
            FlowerCategory(id: index, name: "name_\(index)")
        }
    }

}
