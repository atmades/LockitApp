import UIKit

final class CreateNoteSceneConfigurator {
    static let sharedInstance = CreateNoteSceneConfigurator()
    
    private init() {}
    
    func configure(viewController: CreateNoteSceneViewController) {
        let interactor = CreateNoteSceneInteractor()
        let presenter = CreateNoteScenePresenter()
        let router = CreateNoteSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
