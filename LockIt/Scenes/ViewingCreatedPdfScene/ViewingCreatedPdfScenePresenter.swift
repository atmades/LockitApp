import UIKit

protocol ViewingCreatedPdfScenePresentationLogic {
    func presentCurrentData(response: ViewingCreatedPdfScene.CurrentData.Response)
}

class ViewingCreatedPdfScenePresenter: ViewingCreatedPdfScenePresentationLogic {
    weak var viewController: ViewingCreatedPdfSceneDisplayLogic?
    
    func presentCurrentData(response: ViewingCreatedPdfScene.CurrentData.Response) {
        viewController?.displayCurrentData(viewModel: ViewingCreatedPdfScene.CurrentData.ViewModel(pdfData: response.pdfData, pdfName: response.pdfName))
    }
}
