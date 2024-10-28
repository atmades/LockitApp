import UIKit

final class CreateFolderConfigurator {
    static let sharedInstance = CreateFolderConfigurator()
    
    private init() {}
    
    func configure(viewController: CreateFolderViewController) {
        let interactor = CreateFolderInteractor()
        let presenter = CreateFolderPresenter()
        let router = CreateFolderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
