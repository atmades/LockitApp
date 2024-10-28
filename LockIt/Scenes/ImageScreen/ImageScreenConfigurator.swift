import UIKit

final class ImageScreenConfigurator {
    static let sharedInstance = ImageScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: ImageScreenViewController) {
        let interactor = ImageScreenInteractor()
        let presenter = ImageScreenPresenter()
        let router = ImageScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
