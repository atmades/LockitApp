import UIKit

final class NotesListConfigurator {
    static let sharedInstance = NotesListConfigurator()
    
    private init() {}
    
    func configure(viewController: NotesListViewController) {
        let interactor = NotesListInteractor()
        let presenter = NotesListPresenter()
        let router = NotesListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
