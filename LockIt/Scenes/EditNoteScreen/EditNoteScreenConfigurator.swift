import UIKit

final class EditNoteScreenConfigurator {
    static let sharedInstance = EditNoteScreenConfigurator()
    
    private init() {}
    
    func configure(viewController: EditNoteScreenViewController) {
        let interactor = EditNoteScreenInteractor()
        let presenter = EditNoteScreenPresenter()
        let router = EditNoteScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
