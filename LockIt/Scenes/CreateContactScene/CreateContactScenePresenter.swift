import UIKit

protocol CreateContactScenePresentationLogic {
    func presentAvatar(response: CreateContactScene.ContactData.Response)
    func presentErrorNotSaved(response: String)
}

class CreateContactScenePresenter: CreateContactScenePresentationLogic {
    weak var viewController: CreateContactSceneDisplayLogic?
    
    func presentAvatar(response: CreateContactScene.ContactData.Response) {
        viewController?.displayContactData(viewModel: CreateContactScene.ContactData.ViewModel(image: response.image))
    }
    
    func presentErrorNotSaved(response: String) {
        viewController?.displayError(viewModel: CreateContactScene.Error.ViewModel(message: response))
    }
    
}
