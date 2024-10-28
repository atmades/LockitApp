import UIKit

@objc protocol DocumentScreenRoutingLogic {
    func routeToBack()
}

protocol DocumentScreenDataPassing {
    var dataStore: DocumentScreenDataStore? { get }
}

class DocumentScreenRouter: NSObject, DocumentScreenRoutingLogic, DocumentScreenDataPassing {
    weak var viewController: DocumentScreenViewController?
    var dataStore: DocumentScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}
