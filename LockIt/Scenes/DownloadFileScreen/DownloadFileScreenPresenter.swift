import UIKit

protocol DownloadFileScreenPresentationLogic {
    func presentCurrentData(response: DownloadFileScreen.CurrentData.Response)
}

class DownloadFileScreenPresenter: DownloadFileScreenPresentationLogic {
    weak var viewController: DownloadFileScreenDisplayLogic?
    
    func presentCurrentData(response: DownloadFileScreen.CurrentData.Response) {
        let name = (response.pdfName as NSString).deletingPathExtension
        viewController?.displayCurrentData(viewModel: DownloadFileScreen.CurrentData.ViewModel(pdfData: response.pdfData, pdfName: name))
    }
}
