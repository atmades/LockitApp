import UIKit

@objc protocol ContactScreenRoutingLogic {
    func routeToEditScreen()
    func routeToBack()
}

protocol ContactScreenDataPassing {
    var dataStore: ContactScreenDataStore? { get }
}

class ContactScreenRouter: NSObject, ContactScreenRoutingLogic, ContactScreenDataPassing {
    weak var viewController: ContactScreenViewController?
    var dataStore: ContactScreenDataStore?
    
    func routeToEditScreen() {
        let vc = EditContactScreenViewController()
        var destinationDS = vc.router?.dataStore
        passEditScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }

    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

private extension ContactScreenRouter {
    func passEditScreen(destination: inout EditContactScreenDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.currentSystemName = dataStore?.currentSystemName ?? ""
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
//        destination?.itemPresent = dataStore?.contact
    }
}
