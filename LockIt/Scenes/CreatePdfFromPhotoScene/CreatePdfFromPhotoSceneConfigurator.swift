import UIKit

final class CreatePdfFromPhotoSceneConfigurator {
    static let sharedInstance = CreatePdfFromPhotoSceneConfigurator()
    
    private init() {}

    func configure(viewController: CreatePdfFromPhotoSceneViewController) {
        let interactor = CreatePdfFromPhotoSceneInteractor()
        let presenter = CreatePdfFromPhotoScenePresenter()
        let router = CreatePdfFromPhotoSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
