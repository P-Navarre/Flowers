//
//  Flowers
//
//  Pierre Navarre
//

import Foundation
import FlowerItemData

@testable import ListView

final class ListViewControllerSpy: ListViewControllerInput {
    
    nonisolated init() {}

    var invokedShowLoader = false
    var invokedShowLoaderCount = 0
    var invokedShowLoaderParameters: (isRunning: Bool, Void)?
    var invokedShowLoaderParametersList = [(isRunning: Bool, Void)]()

    func showLoader(_ isRunning: Bool) {
        invokedShowLoader = true
        invokedShowLoaderCount += 1
        invokedShowLoaderParameters = (isRunning, ())
        invokedShowLoaderParametersList.append((isRunning, ()))
    }

    var invokedShowContent = false
    var invokedShowContentCount = 0
    var invokedShowContentParameters: (model: [FlowerItemCellModel], Void)?
    var invokedShowContentParametersList = [(model: [FlowerItemCellModel], Void)]()

    func showContent(_ model: [FlowerItemCellModel]) {
        invokedShowContent = true
        invokedShowContentCount += 1
        invokedShowContentParameters = (model, ())
        invokedShowContentParametersList.append((model, ()))
    }

    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (model: ErrorViewModel?, Void)?
    var invokedShowErrorParametersList = [(model: ErrorViewModel?, Void)]()

    func showError(_ model: ErrorViewModel?) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (model, ())
        invokedShowErrorParametersList.append((model, ()))
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
