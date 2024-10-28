import UIKit

@objc protocol ContactsListRoutingLogic {
    func routeToCreateFolderScreen()
    func routeToCreateContactScreen()
    func routeToRenameScreen() 
    func routeToEditScreen()
    func routeToContactScreen()
    func routeToSubList()
    func routeToBack()
}

protocol ContactsListDataPassing {
    var dataStore: ContactsListDataStore? { get }
}

class ContactsListRouter: NSObject, ContactsListRoutingLogic, ContactsListDataPassing {
    weak var viewController: ContactsListViewController?
    var dataStore: ContactsListDataStore?
    
    func routeToCreateFolderScreen() {
        let vc = CreateFolderViewController()
        var destinationDS = vc.router?.dataStore
        passCreateFolderScreen(destination: &destinationDS)
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
    
    func routeToCreateContactScreen() {
        let vc = CreateContactSceneViewController()
        var destinationDS = vc.router?.dataStore
        passCreateContactScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToEditScreen() {
        let vc = EditContactScreenViewController()
        var destinationDS = vc.router?.dataStore
        passEditScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToContactScreen() {
        let vc = ContactScreenViewController()
        var destinationDS = vc.router?.dataStore
        passContactScreen(destination: &destinationDS)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToSubList() {
        guard let viewControllerWeakSelf = viewController else { return }
        let vc = ContactsListViewController()
        var destinationDS = vc.router?.dataStore
        passFilesList(destination: &destinationDS)
        passCounterVC(destination: &destinationDS)
        viewControllerWeakSelf.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }    
}

private extension ContactsListRouter {
    func passCreateFolderScreen(destination: inout CreateFolderDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passRenameScreen(destination: inout RenameDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.itemPresent = dataStore?.selectedFolderForRename
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
        destination?.root = dataStore?.root
    }
    
    func passEditScreen(destination: inout EditContactScreenDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
//        destination?.itemPresent = dataStore?.selectedContactForEdit
        destination?.currentSystemName = dataStore?.selectedContactForEdit?.name ?? ""
        print(#function)
        print(dataStore?.selectedContactForEdit?.name)
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passCreateContactScreen(destination: inout CreateContactSceneDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passContactScreen(destination: inout ContactScreenDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.currentSystemName = dataStore?.selectedContactForEdit?.name ?? ""
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passFilesList(destination: inout ContactsListDataStore?) {
        destination?.path = dataStore?.folderURLForRoute ?? URL(fileURLWithPath: "")
        destination?.folderName = dataStore?.folderNameForRoute ?? ""
    }
    
    func passCounterVC(destination: inout ContactsListDataStore?) {
        guard let counter = dataStore?.countVC else { return }
        destination?.countVC = counter + 1
    }
}
