import UIKit

@objc protocol NotesListRoutingLogic {
    func routeToCreateFolderScreen()
    func routeToCreateNoteScreen()
    func routeToEditNoteScreen()
    func routeToRenameScreen()
    func routeToSubList()
    func routeToBack()
}

protocol NotesListDataPassing {
    var dataStore: NotesListDataStore? { get }
}

class NotesListRouter: NSObject, NotesListRoutingLogic, NotesListDataPassing {
    weak var viewController: NotesListViewController?
    var dataStore: NotesListDataStore?
    
    func routeToCreateFolderScreen() {
        let vc = CreateFolderViewController()
        var destinationDS = vc.router?.dataStore
        passCreateFolderScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToCreateNoteScreen() {
        let vc = CreateNoteSceneViewController()
        var destinationDS = vc.router?.dataStore
        passCreateNoteScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToEditNoteScreen() {
        let vc = EditNoteScreenViewController()
        var destinationDS = vc.router?.dataStore
        passEditNoteScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToRenameScreen() {
        let vc = RenameViewController()
        var destinationDS = vc.router?.dataStore
        passRenameScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToSubList() {
        guard let viewControllerWeakSelf = viewController else { return }
        let vc = NotesListViewController()
        var destinationDS = vc.router?.dataStore
        passSubList(destination: &destinationDS)
        passCounterVC(destination: &destinationDS)
        viewControllerWeakSelf.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}

private extension NotesListRouter {
    
    func passCreateFolderScreen(destination: inout CreateFolderDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passCreateNoteScreen(destination: inout CreateNoteSceneDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passRenameScreen(destination: inout RenameDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.itemPresent = dataStore?.selectedItem
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
        destination?.root = dataStore?.root 
    }
    
    func passEditNoteScreen(destination: inout EditNoteScreenDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
//        destination?.itemPresent = dataStore?.selectedItem
        destination?.currentName = dataStore?.selectedItem?.name ?? ""
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passSubList(destination: inout NotesListDataStore?) {
        destination?.path = dataStore?.folderURLForRoute ?? URL(fileURLWithPath: "")
        destination?.folderName = dataStore?.folderNameForRoute ?? ""
    }
    
    func passCounterVC(destination: inout NotesListDataStore?) {
        guard let counter = dataStore?.countVC else { return }
        destination?.countVC = counter + 1
    }
}
