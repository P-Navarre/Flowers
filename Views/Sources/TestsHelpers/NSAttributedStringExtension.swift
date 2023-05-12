//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public extension NSAttributedString {
    func hasAttributes(_ expectedAttributes: [NSAttributedString.Key : Any]) -> Bool {
        guard self.length > 0 else { return true }
        let attributes = self.attributes(at: 0, effectiveRange: nil)
        return NSDictionary(dictionary: attributes).isEqual(to: expectedAttributes)
    }
}
