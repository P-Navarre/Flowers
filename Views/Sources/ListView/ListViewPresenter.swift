//
//  Flowers
//
//  Pierre Navarre
//

import UIKit
import FlowerItemData
import Style

protocol ListViewPresenterInput {
    func willStartLoading() async
    func showItems(_ items: [FlowerItem], categories: [Int: String]) async
    func showError(_ error: Error, retryHandler: @escaping ()->Void) async
    func presentDetail(for item: FlowerItem, category: String?) async
    // methods are async for unit test purpose
}


final class ListViewPresenter {
    private weak var viewController: ListViewControllerInput?
    
    init(viewController: ListViewControllerInput) {
        self.viewController = viewController
    }
}

// MARK: - ListViewPresenterInput
extension ListViewPresenter: ListViewPresenterInput {
    func willStartLoading() async {
        await MainActor.run {
            self.viewController?.showError(nil)
            self.viewController?.showLoader(true)
        }
    }
    
    func showItems(_ items: [FlowerItem], categories: [Int: String]) async {
        let style = FlowerItemCellStyle()
    
        let model = items.map({ item in
            self.cellModel(for: item, categories: categories, style: style)
        })
        
        await MainActor.run {
            self.viewController?.showError(nil)
            self.viewController?.showLoader(false)
            self.viewController?.showContent(model)
        }
    }
    
    func showError(_ error: Error, retryHandler: @escaping ()->Void) async {
        let style = ErrorViewStyle()
        
        let model = ErrorViewModel(
            message: NSAttributedString(string: Localized.errorMessage.stirng, attributes: style.messageAttributes),
            buttonBackground: style.buttonBackgroundColor,
            buttonTitle: NSAttributedString(
                string: Localized.loadRetryButton.stirng, attributes: style.buttonTitleAttributes
            ),
            retryHandler: retryHandler
        )
        
        await MainActor.run {
            self.viewController?.showError(nil)
            self.viewController?.showLoader(false)
            self.viewController?.showError(model)
        }
    }

    func presentDetail(for item: FlowerItem, category: String?) async {
        await MainActor.run {
            self.viewController?.presentDetail(for: item, category: category)
        }
    }
}

// MARK: - FlowerItemCellStyle
extension ListViewPresenter {
    
    struct FlowerItemCellStyle {
        let categoryAttributes: [NSAttributedString.Key : Any]
        let titleAttributes: [NSAttributedString.Key : Any]
        
        init() {
            self.categoryAttributes = [
                .font: Font.regular.withSize(17),
                .foregroundColor : UIColor.systemGray
                
            ]
            self.titleAttributes = [.font: Font.medium.withSize(17)]
        }
    }
    
    private func cellModel(for item: FlowerItem, categories: [Int: String], style: FlowerItemCellStyle) -> FlowerItemCellModel {
        let category = NSAttributedString(
            string: String(categories[item.categoryId] ?? ""),
            attributes: style.categoryAttributes
        )
        
        let title = NSAttributedString(
            string: item.title,
            attributes: style.titleAttributes
        )
        
        return FlowerItemCellModel(
            id: item.id, placeHolder: Image.placeHolderSquare, imageUrl: item.imageUrls.small?.url,
            category: category, title: title
        )
    }
}

// MARK: - ErrorViewStyle
extension ListViewPresenter {
    struct ErrorViewStyle {
        let messageAttributes: [NSAttributedString.Key : Any]
        let buttonBackgroundColor: UIColor = Color.brand.color
        let buttonTitleAttributes: [NSAttributedString.Key : Any]
        
        init() {
            let messageStyle = NSMutableParagraphStyle()
            messageStyle.alignment = .center
            self.messageAttributes = [
                .font: Font.medium.withSize(20),
                .paragraphStyle: messageStyle
            ]
            
            self.buttonTitleAttributes = [
                .font: Font.medium.withSize(20),
                .foregroundColor: UIColor.white
            ]
        }
    }
}
