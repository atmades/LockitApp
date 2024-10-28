import UIKit

@objc protocol SupportScreenRoutingLogic {
    func routeToBack()
}

protocol SupportScreenDataPassing {
    var dataStore: SupportScreenDataStore? { get }
}

class SupportScreenRouter: NSObject, SupportScreenRoutingLogic, SupportScreenDataPassing {
    weak var viewController: SupportScreenViewController?
    var dataStore: SupportScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}
