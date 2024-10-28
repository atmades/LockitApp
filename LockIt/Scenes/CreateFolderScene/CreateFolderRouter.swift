import UIKit

@objc protocol CreateFolderRoutingLogic {
    func cancelCreatingFolder()
    func goBackAndReloadList()
}

protocol CreateFolderDataPassing {
    var dataStore: CreateFolderDataStore? { get }
}

class CreateFolderRouter: NSObject, CreateFolderRoutingLogic, CreateFolderDataPassing {
    weak var viewController: CreateFolderViewController?
    var dataStore: CreateFolderDataStore?
    
    func cancelCreatingFolder() {
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
