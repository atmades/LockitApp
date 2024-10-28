import UIKit

final class CreateContactSceneConfigurator {
    static let sharedInstance = CreateContactSceneConfigurator()
    
    private init() {}
    
    func configure(viewController: CreateContactSceneViewController) {
        let interactor = CreateContactSceneInteractor()
        let presenter = CreateContactScenePresenter()
        let router = CreateContactSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
