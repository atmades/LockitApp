import UIKit

protocol MaskingScreenPresentationLogic {
    func presentFolderName(response: MaskingScreen.Folder.Response)
}

class MaskingScreenPresenter: MaskingScreenPresentationLogic {
    weak var viewController: MaskingScreenDisplayLogic?
    
    func presentFolderName(response: MaskingScreen.Folder.Response) {
        viewController?.displayTitle(viewModel: MaskingScreen.Folder.ViewModel(folderName: response.folderName, counterVC: response.counterVC))
    }
}
