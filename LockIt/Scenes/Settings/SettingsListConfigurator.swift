import UIKit

final class SettingsListConfigurator {
    static let sharedInstance = SettingsListConfigurator()
    
    private init() {}
    
    func configure(viewController: SettingsListViewController) {
        let interactor = SettingsListInteractor()
        let presenter = SettingsListPresenter()
        let router = SettingsListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
