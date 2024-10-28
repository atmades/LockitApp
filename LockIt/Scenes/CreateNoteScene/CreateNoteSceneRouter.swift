import UIKit

@objc protocol CreateNoteSceneRoutingLogic {
    func cancelCreatingNote()
    func goBackAndReloadList()
}

protocol CreateNoteSceneDataPassing {
    var dataStore: CreateNoteSceneDataStore? { get }
}

class CreateNoteSceneRouter: NSObject, CreateNoteSceneRoutingLogic, CreateNoteSceneDataPassing {
    weak var viewController: CreateNoteSceneViewController?
    var dataStore: CreateNoteSceneDataStore?
    
    func cancelCreatingNote() {
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
