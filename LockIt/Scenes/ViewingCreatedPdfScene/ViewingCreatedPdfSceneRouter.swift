import UIKit

@objc protocol ViewingCreatedPdfSceneRoutingLogic {
    func routeToBack()
}

protocol ViewingCreatedPdfSceneDataPassing {
    var dataStore: ViewingCreatedPdfSceneDataStore? { get }
}

class ViewingCreatedPdfSceneRouter: NSObject, ViewingCreatedPdfSceneRoutingLogic, ViewingCreatedPdfSceneDataPassing {
    weak var viewController: ViewingCreatedPdfSceneViewController?
    var dataStore: ViewingCreatedPdfSceneDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
}


