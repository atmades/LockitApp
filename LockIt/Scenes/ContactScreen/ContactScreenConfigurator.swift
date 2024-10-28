import UIKit

final class ContactScreenConfigurator {
    static let sharedInstance = ContactScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: ContactScreenViewController) {
        let interactor = ContactScreenInteractor()
        let presenter = ContactScreenPresenter()
        let router = ContactScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
