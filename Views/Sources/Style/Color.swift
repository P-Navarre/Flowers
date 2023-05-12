//
//  Flowers
//
//  Pierre Navarre
//

import UIKit

public enum Color {
    case brand, itemCellBackground
    
    public var color: UIColor {
        switch self {
        case .brand: return UIColor(named: "BrandColor") ?? .black
        case .itemCellBackground: return UIColor(named: "ItemCellBackground") ?? .systemBackground
        }
    }
}
