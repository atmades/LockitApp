import UIKit

final class RepeatPassCodeScreenConfigurator {
    static let sharedInstance = RepeatPassCodeScreenConfigurator()
    
    private init() {}

    func configure(viewController: RepeatPassCodeScreenViewController) {
        let interactor = RepeatPassCodeScreenInteractor()
        let presenter = RepeatPassCodeScreenPresenter()
        let router = RepeatPassCodeScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
