import UIKit

final class CameraTrapScreenConfigurator {
    static let sharedInstance = CameraTrapScreenConfigurator()
    
    private init() {}

    func configure(viewController: CameraTrapScreenViewController) {
        let interactor = CameraTrapScreenInteractor()
        let presenter = CameraTrapScreenPresenter()
        let router = CameraTrapScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
