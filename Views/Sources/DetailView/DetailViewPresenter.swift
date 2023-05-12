//
//  Flowers
//
//  Pierre Navarre
//

import UIKit
import FlowerItemData
import Style

protocol DetailViewPresenterInput {
    func willAppear(for item: FlowerItem, category: String?)
}

@MainActor
final class DetailViewPresenter {
    private weak var viewController: DetailViewControllerInput?
    
    init(viewController: DetailViewControllerInput) {
        self.viewController = viewController
    }
}

// MARK: - DetailViewPresenterInput
extension DetailViewPresenter: DetailViewPresenterInput {
    func willAppear(for item: FlowerItem, category: String?) {
        let model = self.cellModel(for: item, category: category, style: DetailViewlStyle())
        self.viewController?.showContent(model)
    }
}

// MARK: - DetailViewlStyle
private extension DetailViewPresenter {
    
    struct DetailViewlStyle {
        let categoryAttributes: [NSAttributedString.Key : Any]
        let idAttributes: [NSAttributedString.Key : Any]
        let titleAttributes: [NSAttributedString.Key : Any]
        let descripionAttributes: [NSAttributedString.Key : Any]
        
        init() {
            self.categoryAttributes = [
                .font: Font.regular.withSize(17),
                .foregroundColor : UIColor.systemGray
                
            ]
            self.idAttributes = [
                .font: Font.regular.withSize(12),
                .foregroundColor : UIColor.systemGray
            ]
            self.titleAttributes = [.font: Font.medium.withSize(18)]
            self.descripionAttributes = [.font: Font.regular.withSize(16)]
        }
    }
    
    func cellModel(for item: FlowerItem, category: String?, style: DetailViewlStyle) -> DetailViewModel {
        let category = NSAttributedString(
            string: category ?? "",
            attributes: style.categoryAttributes
        )
        
        let id = NSAttributedString(
            string: Localized.detailId.stirng + String(item.id),
            attributes: style.idAttributes
        )
        
        let title = NSAttributedString(
            string: item.title,
            attributes: style.titleAttributes
        )
        
        let description = NSAttributedString(
            string: item.description,
            attributes: style.descripionAttributes
        )

        return DetailViewModel(
            placeHolder: Image.placeHolderLandscape,
            imageUrl: item.imageUrls.full?.url,
            category: category,
            id: id,
            title: title,
            description: description
        )
    }
}
