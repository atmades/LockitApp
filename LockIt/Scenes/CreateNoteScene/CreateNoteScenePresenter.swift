import UIKit

protocol CreateNoteScenePresentationLogic {
    func presentErrorNotSaved(response: String)
}

class CreateNoteScenePresenter: CreateNoteScenePresentationLogic {
  weak var viewController: CreateNoteSceneDisplayLogic?
    
    func presentErrorNotSaved(response: String) {
        viewController?.displayError(viewModel: CreateNoteScene.Error.ViewModel(message: response))
    }
}
