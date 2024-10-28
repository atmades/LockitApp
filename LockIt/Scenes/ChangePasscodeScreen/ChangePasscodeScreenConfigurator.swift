import UIKit

final class ChangePasscodeScreenConfigurator {
    static let sharedInstance = ChangePasscodeScreenConfigurator()
    
    private init() {}

    func configure(viewController: ChangePasscodeScreenViewController) {
        let interactor = ChangePasscodeScreenInteractor()
        let presenter = ChangePasscodeScreenPresenter()
        let router = ChangePasscodeScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
