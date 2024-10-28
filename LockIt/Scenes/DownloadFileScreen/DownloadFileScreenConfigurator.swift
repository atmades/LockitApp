import UIKit

final class DownloadFileScreenConfigurator {
    static let sharedInstance = DownloadFileScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: DownloadFileScreenViewController) {
        let interactor = DownloadFileScreenInteractor()
        let presenter = DownloadFileScreenPresenter()
        let router = DownloadFileScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
