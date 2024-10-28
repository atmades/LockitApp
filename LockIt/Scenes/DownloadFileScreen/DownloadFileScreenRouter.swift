import UIKit

@objc protocol DownloadFileScreenRoutingLogic {
    func routeToBack()
    func goBackAndReloadList()
}

protocol DownloadFileScreenDataPassing {
    var dataStore: DownloadFileScreenDataStore? { get }
}

class DownloadFileScreenRouter: NSObject, DownloadFileScreenRoutingLogic, DownloadFileScreenDataPassing {
    weak var viewController: DownloadFileScreenViewController?
    var dataStore: DownloadFileScreenDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
    
    func goBackAndReloadList() {
        viewController?.dismiss(animated: true) { [weak self] in
            guard self != nil else { return }
            guard let identifier = self?.dataStore?.notificationIdentifier else { return }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
        }
    }
}
