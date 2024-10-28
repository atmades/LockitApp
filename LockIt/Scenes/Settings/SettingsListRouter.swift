import UIKit

@objc protocol SettingsListRoutingLogic {
    func routeToMaskingScreen()
    func routeToCameraTrapScreen()
    func routeToBiometryScreen()
    func routeToChangePasscodeScreen()
    func routeToMailClient()
    func routeToAppleStore()
}

protocol SettingsListDataPassing {
    var dataStore: SettingsListDataStore? { get }
}

class SettingsListRouter: NSObject, SettingsListRoutingLogic, SettingsListDataPassing {
    weak var viewController: SettingsListViewController?
    var dataStore: SettingsListDataStore?
    
    func routeToMaskingScreen() {
        let vc = MaskingScreenViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToCameraTrapScreen() {
        let vc = CameraTrapScreenViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    func routeToBiometryScreen() {
        let vc = BiometryScreenViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToChangePasscodeScreen() {
        let vc = ChangePasscodeScreenViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToSupportScreen() {
        let vc = SupportScreenViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToMailClient() {
//        MailManager.shared.sendEmail(from: viewController ?? UIViewController())
    }
    
    func routeToAppleStore() {
        guard let id = dataStore?.id else { return }
        DispatchQueue.main.async {
            URL.openAppstore(id: id)
        }
    }
}

private extension SettingsListRouter {
}
