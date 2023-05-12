//
//  Flowers
//
//  Pierre Navarre
//

import UIKit

public enum Image {
    case placeHolderSquare, placeHolderLandscape
    
    public var image: UIImage? {
        switch self {
        case .placeHolderSquare: return UIImage(named: "PlaceholderSquare")
        case .placeHolderLandscape: return UIImage(named: "PlaceholderLandscape")
        }
    }
}
