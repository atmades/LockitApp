import UIKit

final class MaskingScreenConfigurator {
    static let sharedInstance = MaskingScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: MaskingScreenViewController) {
        let interactor = MaskingScreenInteractor()
        let presenter = MaskingScreenPresenter()
        let router = MaskingScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
