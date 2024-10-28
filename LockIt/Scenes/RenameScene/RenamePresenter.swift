import UIKit

protocol RenamePresentationLogic {
    func presentCurrentName(response: Rename.CurrentData.Response)
    func presentErrorNotSaved(response: String)
}

class RenamePresenter: RenamePresentationLogic {
  weak var viewController: RenameDisplayLogic?
    
    func presentCurrentName(response: Rename.CurrentData.Response) {
        viewController?.displayCurrentData(viewModel: Rename.CurrentData.ViewModel(name: response.name))
    }
    
    func presentErrorNotSaved(response: String) {
        viewController?.displayError(viewModel: Rename.Error.ViewModel(message: response))
    }
    
}
