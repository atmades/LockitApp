import UIKit

final class SupportScreenConfigurator {
    static let sharedInstance = SupportScreenConfigurator()
    
    private init() {}

    func configure(viewController: SupportScreenViewController) {
        let interactor = SupportScreenInteractor()
        let presenter = SupportScreenPresenter()
        let router = SupportScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
