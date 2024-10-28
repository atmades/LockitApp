import UIKit

@objc protocol ImageScreenRoutingLogic {
    func routeToBack()
}

protocol ImageScreenDataPassing {
    var dataStore: ImageScreenDataStore? { get }
}

class ImageScreenRouter: NSObject, ImageScreenRoutingLogic, ImageScreenDataPassing {
    weak var viewController: ImageScreenViewController?
    var dataStore: ImageScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}
