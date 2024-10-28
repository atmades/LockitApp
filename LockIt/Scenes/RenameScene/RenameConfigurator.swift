import UIKit

final class RenameConfigurator {
    static let sharedInstance = RenameConfigurator()
    
    private init() {}
    
    func configure(viewController: RenameViewController) {
        let interactor = RenameInteractor()
        let presenter = RenamePresenter()
        let router = RenameRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
