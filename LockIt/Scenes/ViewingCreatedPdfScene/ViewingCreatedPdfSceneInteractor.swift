import UIKit

protocol ViewingCreatedPdfSceneBusinessLogic {
    func getCurrentData()
}
protocol ViewingCreatedPdfSceneDataStore {
    var pdfData: Data? { get set }
    var pdfName: String { get set }
}

class ViewingCreatedPdfSceneInteractor: ViewingCreatedPdfSceneBusinessLogic, ViewingCreatedPdfSceneDataStore {
    var presenter: ViewingCreatedPdfScenePresentationLogic?
    var worker: ViewingCreatedPdfSceneWorker?
    
    var pdfData: Data?
    var pdfName = ""
    
    func getCurrentData() {
        presenter?.presentCurrentData(response: ViewingCreatedPdfScene.CurrentData.Response(pdfData: pdfData, pdfName: pdfName))
    }
}
