import UIKit

final class ViewingCreatedPdfSceneConfigurator {
    static let sharedInstance = ViewingCreatedPdfSceneConfigurator()
    
    private init() {}

    func configure(viewController: ViewingCreatedPdfSceneViewController) {
        let interactor = ViewingCreatedPdfSceneInteractor()
        let presenter = ViewingCreatedPdfScenePresenter()
        let router = ViewingCreatedPdfSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
