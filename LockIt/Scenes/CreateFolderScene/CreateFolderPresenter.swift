import UIKit

protocol CreateFolderPresentationLogic {
    func presentErrorNotSaved(response: String)
}

class CreateFolderPresenter: CreateFolderPresentationLogic {
    weak var viewController: CreateFolderDisplayLogic?
    
    func presentErrorNotSaved(response: String) {
        viewController?.displayError(viewModel: CreateFolder.Error.ViewModel(message: response))
    }
}
