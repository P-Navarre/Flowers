//
//  Flowers
//
//  Pierre Navarre
//

import UIKit

public enum Font {
    case regular, medium, demiBold, bold
    
    var name: String {
        switch self {
        case .regular: return "AvenirNext-Regular"
        case .medium: return "AvenirNext-Medium"
        case .demiBold: return "AvenirNext-DemiBold"
        case .bold: return "AvenirNext-Bold"
        }
    }
    
    public func withSize(_ size: CGFloat) -> UIFont {
        UIFont(name: self.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

