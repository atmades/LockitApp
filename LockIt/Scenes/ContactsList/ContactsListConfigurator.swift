import UIKit

final class ContactsListConfigurator {
    static let sharedInstance = ContactsListConfigurator()
    
    private init() {}
    
    func configure(viewController: ContactsListViewController) {
        let interactor = ContactsListInteractor()
        let presenter = ContactsListPresenter()
        let router = ContactsListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
