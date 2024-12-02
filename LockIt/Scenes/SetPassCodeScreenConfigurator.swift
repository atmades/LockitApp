import UIKit

final class SetPassCodeScreenConfigurator {
    static let sharedInstance = SetPassCodeScreenConfigurator()
    
    private init() {}

    func configure(viewController: SetPassCodeScreenViewController) {
        let interactor = SetPassCodeScreenInteractor()
        let presenter = SetPassCodeScreenPresenter()
        let router = SetPassCodeScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
