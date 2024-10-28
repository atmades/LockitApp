import UIKit

protocol EditContactScreenPresentationLogic {
    func presentErrorNotSaved(response: String)
    func presentCurrentData(response: EditContactScreen.CurrentData.Response)
    func updateAvatar(response: EditContactScreen.NewAvatar.Response)
}

class EditContactScreenPresenter: EditContactScreenPresentationLogic {
    weak var viewController: EditContactScreenDisplayLogic?
    
    func presentCurrentData(response: EditContactScreen.CurrentData.Response) {
        viewController?.displayCurrentData(viewModel: EditContactScreen.CurrentData.ViewModel(name: response.name, lastName: response.lastName, phone: response.phone, email: response.email, avatarImage: response.avatarImage))
    }
    
    func updateAvatar(response: EditContactScreen.NewAvatar.Response) {
        viewController?.displayUpdatedAvatar(viewModel: EditContactScreen.NewAvatar.ViewModel(image: response.image))
    }
    
    func presentErrorNotSaved(response: String) {
        viewController?.displayError(viewModel: EditContactScreen.Error.ViewModel(message: response))
    }
    
}
