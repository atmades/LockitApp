import UIKit

final class BiometryScreenConfigurator {
    static let sharedInstance = BiometryScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: BiometryScreenViewController) {
        let interactor = BiometryScreenInteractor()
        let presenter = BiometryScreenPresenter()
        let router = BiometryScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
