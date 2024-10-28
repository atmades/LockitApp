import UIKit

@objc protocol BiometryScreenRoutingLogic {
    func routeToBack()
}

protocol BiometryScreenDataPassing {
    var dataStore: BiometryScreenDataStore? { get }
}

class BiometryScreenRouter: NSObject, BiometryScreenRoutingLogic, BiometryScreenDataPassing {
    weak var viewController: BiometryScreenViewController?
    var dataStore: BiometryScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}
