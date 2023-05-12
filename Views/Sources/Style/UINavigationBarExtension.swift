//
//  Flowers
//
//  Pierre Navarre
//

import UIKit

public extension UINavigationBar {
    
    static private var customScrollEdgeAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.brand.color
        appearance.titleTextAttributes = [
            .font : Font.bold.withSize(22),
            .foregroundColor : UIColor.white
        ]
        
        let backIndicator = appearance.backIndicatorImage
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        
        appearance.setBackIndicatorImage(backIndicator, transitionMaskImage: backIndicator)
        
        return appearance
    }
    
    static private var customStandardAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font : Font.bold.withSize(22),
            .foregroundColor : Color.brand.color
        ]
                
        let backIndicator = appearance.backIndicatorImage
            .withTintColor(Color.brand.color)
            .withRenderingMode(.alwaysOriginal)
        
        appearance.setBackIndicatorImage(backIndicator, transitionMaskImage: backIndicator)
        
        return appearance
    }
    
    func configureAppearance() {
        self.standardAppearance = Self.customStandardAppearance
        self.scrollEdgeAppearance = Self.customScrollEdgeAppearance
    }
    
}
