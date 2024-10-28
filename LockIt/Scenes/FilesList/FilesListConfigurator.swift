import UIKit

final class FilesListConfigurator {
    static let sharedInstance = FilesListConfigurator()
    
    private init() {}
    
    func configure(viewController: FilesListViewController) {
        let interactor = FilesListInteractor()
        let presenter = FilesListPresenter()
        let router = FilesListRouter()

        viewController.router = router
        router.dataStore = interactor
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
    }
}
