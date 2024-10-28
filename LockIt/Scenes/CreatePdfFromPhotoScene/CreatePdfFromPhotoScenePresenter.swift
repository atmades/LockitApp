import UIKit

protocol CreatePdfFromPhotoScenePresentationLogic {
    func presentError(response: String)
    func presentCreatedPDF(response: CreatePdfFromPhotoScene.CreatedPDF.Response)
    func presentCurrentdata(response: CreatePdfFromPhotoScene.CurrentData.Response)
}

class CreatePdfFromPhotoScenePresenter: CreatePdfFromPhotoScenePresentationLogic {
    weak var viewController: CreatePdfFromPhotoSceneDisplayLogic?
   
    func presentCurrentdata(response: CreatePdfFromPhotoScene.CurrentData.Response) {
        viewController?.displayCurrentData(viewModel: CreatePdfFromPhotoScene.CurrentData.ViewModel(name: response.name))
    }
    
    func presentError(response: String) {
        viewController?.displayError(viewModel: CreatePdfFromPhotoScene.Error.ViewModel(message: response))
    }
    
    func presentCreatedPDF(response: CreatePdfFromPhotoScene.CreatedPDF.Response) {
        viewController?.displayCeratedPDF(viewModel: CreatePdfFromPhotoScene.CreatedPDF.ViewModel(pdfData: response.pdfData))
    }
}
