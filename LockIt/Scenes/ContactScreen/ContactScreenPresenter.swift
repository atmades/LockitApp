import UIKit

protocol ContactScreenPresentationLogic {
    func presentContactData(response: ContactScreen.ContactData.Response)
    func presentSharing(response: ContactScreen.ShareData.Response)
    func presentResultOfSavingToPhoneBook(response: ContactScreen.Saved.Response)
}

class ContactScreenPresenter: ContactScreenPresentationLogic {
    weak var viewController: ContactScreenDisplayLogic?
    
    func presentContactData(response: ContactScreen.ContactData.Response) {
        viewController?.displayContactData(viewModel: ContactScreen.ContactData.ViewModel(avatar: response.avatar, name: response.name, phone: response.phone, mail: response.mail))
    }
    
    func presentSharing(response: ContactScreen.ShareData.Response) {
        viewController?.displaySharing(viewModel: ContactScreen.ShareData.ViewModel(vCard: response.vCard))
    }
    
    func presentResultOfSavingToPhoneBook(response: ContactScreen.Saved.Response) {
        viewController?.displayAlertSavedContact(viewModel: ContactScreen.Saved.ViewModel(title: response.title, message: response.message))
    }
}
