import UIKit

protocol ImageScreenPresentationLogic {
    func presentContent(response: ImageScreen.LoadContent.Response)
    func presentSharing(response: ImageScreen.Share.Response)
}

class ImageScreenPresenter: ImageScreenPresentationLogic {
    weak var viewController: ImageScreenDisplayLogic?
    
    func presentContent(response: ImageScreen.LoadContent.Response) {
        viewController?.displayItems(viewModel: ImageScreen.LoadContent.ViewModel(itemImages: response.itemImages, index: response.index))
    }
    func presentSharing(response: ImageScreen.Share.Response) {
        viewController?.displaySharing(viewModel: ImageScreen.Share.ViewModel(temporaryURL: response.temporaryURL))
    }
}
