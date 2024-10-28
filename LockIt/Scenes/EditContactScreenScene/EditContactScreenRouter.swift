import UIKit

@objc protocol EditContactScreenRoutingLogic {
    func cancel()
    func goBackAndReloadList()
}

protocol EditContactScreenDataPassing {
    var dataStore: EditContactScreenDataStore? { get }
}

class EditContactScreenRouter: NSObject, EditContactScreenRoutingLogic, EditContactScreenDataPassing {
    weak var viewController: EditContactScreenViewController?
    var dataStore: EditContactScreenDataStore?
    
    func cancel() {
        viewController?.dismiss(animated: true)
    }
    
    func goBackAndReloadList() {
        viewController?.dismiss(animated: true) { [weak self] in
            guard self != nil else { return }
            guard let identifier = self?.dataStore?.notificationIdentifier else { return }
            let updatedSystemName = self?.dataStore?.updatedSystemNameForCallBack
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: updatedSystemName)
        }
    }
}
