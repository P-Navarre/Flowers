//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import Style

struct FlowerItemCellModel: Hashable {
    let id: String
    let placeHolder: Image
    let imageUrl: URL?
    let category: NSAttributedString
    let title: NSAttributedString
}
