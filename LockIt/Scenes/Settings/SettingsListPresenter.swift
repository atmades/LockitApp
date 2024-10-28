import UIKit

protocol SettingsListPresentationLogic {
    func presentError(response: String)
    func presentFolderName(response: SettingsList.Folder.Response)
}

class SettingsListPresenter: SettingsListPresentationLogic {
    weak var viewController: SettingsListDisplayLogic?
    
    func presentError(response: String) {
        viewController?.displayError(viewModel: SettingsList.Error.ViewModel(message: response))
    }
    
    func presentFolderName(response: SettingsList.Folder.Response) {
        viewController?.displayTitle(viewModel: SettingsList.Folder.ViewModel(folderName: response.folderName, counterVC: response.counterVC))
    }
    
}
