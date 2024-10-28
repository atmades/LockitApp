import UIKit

protocol DocumentScreenPresentationLogic {
    func presentCurrentData(response: DocumentScreen.CurrentData.Response)
    func presentSharing(response: DocumentScreen.Share.Response)
}

class DocumentScreenPresenter: DocumentScreenPresentationLogic {
    weak var viewController: DocumentScreenDisplayLogic?
    
    func presentCurrentData(response: DocumentScreen.CurrentData.Response) {
        let name = (response.pdfName as NSString).deletingPathExtension
        viewController?.displayCurrentData(viewModel: DocumentScreen.CurrentData.ViewModel(pdfData: response.pdfData, pdfName: name))
    }
    
    func presentSharing(response: DocumentScreen.Share.Response) {
        viewController?.displaySharing(viewModel: DocumentScreen.Share.ViewModel(temporaryURL: response.temporaryURL))
    }
    
}


