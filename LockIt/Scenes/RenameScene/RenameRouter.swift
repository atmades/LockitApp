import UIKit

@objc protocol RenameRoutingLogic {
    func cancelRename()
    func goBackAndReloadList()
}

protocol RenameDataPassing {
    var dataStore: RenameDataStore? { get }
}

class RenameRouter: NSObject, RenameRoutingLogic, RenameDataPassing {
    weak var viewController: RenameViewController?
    var dataStore: RenameDataStore?
    var notificationIdentifier: String = ""
    
    func cancelRename() {
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
