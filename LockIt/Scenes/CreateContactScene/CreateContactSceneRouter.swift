import UIKit

@objc protocol CreateContactSceneRoutingLogic {
    func cancel()
    func goBackAndReloadList()
}

protocol CreateContactSceneDataPassing {
    var dataStore: CreateContactSceneDataStore? { get }
}

class CreateContactSceneRouter: NSObject, CreateContactSceneRoutingLogic, CreateContactSceneDataPassing {
    weak var viewController: CreateContactSceneViewController?
    var dataStore: CreateContactSceneDataStore?
    
    func cancel() {
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
