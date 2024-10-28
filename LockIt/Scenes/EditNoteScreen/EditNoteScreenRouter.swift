import UIKit

@objc protocol EditNoteScreenRoutingLogic {
    func cancel()
    func goBackAndReloadList()
}

protocol EditNoteScreenDataPassing {
    var dataStore: EditNoteScreenDataStore? { get }
}

class EditNoteScreenRouter: NSObject, EditNoteScreenRoutingLogic, EditNoteScreenDataPassing {
    weak var viewController: EditNoteScreenViewController?
    var dataStore: EditNoteScreenDataStore?
    
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
