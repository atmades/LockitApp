import UIKit

final class EditContactScreenConfigurator {
    static let sharedInstance = EditContactScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: EditContactScreenViewController) {
        let interactor = EditContactScreenInteractor()
        let presenter = EditContactScreenPresenter()
        let router = EditContactScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
