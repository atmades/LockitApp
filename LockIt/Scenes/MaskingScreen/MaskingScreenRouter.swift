import UIKit

@objc protocol MaskingScreenRoutingLogic {
    func routeToBack()
}

protocol MaskingScreenDataPassing {
    var dataStore: MaskingScreenDataStore? { get }
}

class MaskingScreenRouter: NSObject, MaskingScreenRoutingLogic, MaskingScreenDataPassing {
    weak var viewController: MaskingScreenViewController?
    var dataStore: MaskingScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}


