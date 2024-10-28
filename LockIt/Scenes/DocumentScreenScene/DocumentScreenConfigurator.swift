import UIKit

final class DocumentScreenConfigurator {
    static let sharedInstance = DocumentScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: DocumentScreenViewController) {
        let interactor = DocumentScreenInteractor()
        let presenter = DocumentScreenPresenter()
        let router = DocumentScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
