import UIKit

protocol EditNoteScreenPresentationLogic {
    func presentErrorNotSaved(response: String)
    func presentCurrentData(response: EditNoteScreen.CurrentData.Response)
}

class EditNoteScreenPresenter: EditNoteScreenPresentationLogic {
  weak var viewController: EditNoteScreenDisplayLogic?
    
    func presentErrorNotSaved(response: String) {
        viewController?.displayError(viewModel: EditNoteScreen.Error.ViewModel(message: response))
    }
    
    func presentCurrentData(response: EditNoteScreen.CurrentData.Response) {
        viewController?.displayCurrentData(viewModel: EditNoteScreen.CurrentData.ViewModel(name: response.name, textNote: response.textNote))
    }
}
