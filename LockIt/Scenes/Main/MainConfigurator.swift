import UIKit

final class MainConfigurator {
    static let sharedInstance = MainConfigurator()
    
    private init() {}
    
    func configure(viewController: MainViewController) {
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
  
        viewController.router = router
        router.dataStore = interactor
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
