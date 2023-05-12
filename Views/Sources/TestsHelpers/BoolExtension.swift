//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public extension Bool {
    
    static func random(with probability: Double) -> Bool {
        let value = Double.random(in: 0..<1)
        return value < probability
    }
    
}
