import UIKit

@objc protocol ChangePasscodeScreenRoutingLogic {
    func routeToBack()
}

protocol ChangePasscodeScreenDataPassing {
    var dataStore: ChangePasscodeScreenDataStore? { get }
}

class ChangePasscodeScreenRouter: NSObject, ChangePasscodeScreenRoutingLogic, ChangePasscodeScreenDataPassing {
    weak var viewController: ChangePasscodeScreenViewController?
    var dataStore: ChangePasscodeScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}
