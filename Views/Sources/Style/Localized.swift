//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public enum Localized: String {
    case errorMessage = "Load_Error_Message"
    case loadRetryButton = "Load_Retry_Button"
    
    case detailId = "Detail_ID"
    
    public var stirng: String {
        Bundle.module.localizedString(forKey: self.rawValue, value: self.rawValue, table: "Localizable")
    }
}
