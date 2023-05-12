//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import FlowerItemData
@testable import ListView

final class ListViewPresenterSpy: ListViewPresenterInput {

    var invokedWillStartLoading = false
    var invokedWillStartLoadingCount = 0

    func willStartLoading() {
        invokedWillStartLoading = true
        invokedWillStartLoadingCount += 1
    }

    var invokedShowItems = false
    var invokedShowItemsCount = 0
    var invokedShowItemsParameters: (items: [FlowerItem], categories: [Int: String])?
    var invokedShowItemsParametersList = [(items: [FlowerItem], categories: [Int: String])]()

    func showItems(_ items: [FlowerItem], categories: [Int: String]) async {
        await MainActor.run {
            invokedShowItems = true
            invokedShowItemsCount += 1
            invokedShowItemsParameters = (items, categories)
            invokedShowItemsParametersList.append((items, categories))
        }
    }

    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (error: Error, Void)?
    var invokedShowErrorParametersList = [(error: Error, Void)]()
    var shouldInvokeShowErrorRetryHandler = false

    func showError(_ error: Error, retryHandler: @escaping ()->Void) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (error, ())
        invokedShowErrorParametersList.append((error, ()))
        if shouldInvokeShowErrorRetryHandler {
            retryHandler()
        }
    }

    var invokedPresentDetail = false
    var invokedPresentDetailCount = 0
    var invokedPresentDetailParameters: (item: FlowerItem, category: String?)?
    var invokedPresentDetailParametersList = [(item: FlowerItem, category: String?)]()

    func presentDetail(for item: FlowerItem, category: String?) {
        invokedPresentDetail = true
        invokedPresentDetailCount += 1
        invokedPresentDetailParameters = (item, category)
        invokedPresentDetailParametersList.append((item, category))
    }
}
