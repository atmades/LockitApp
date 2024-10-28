import UIKit

protocol DownloadFileScreenBusinessLogic { 
    func getCurrentData()
    func saveFile(completion: @escaping() -> Void)
}
protocol DownloadFileScreenDataStore {
    var path: URL { get set }
    var pdfData: Data { get set }
    var pdfName: String { get set }
    var notificationIdentifier: String { get set }
}

class DownloadFileScreenInteractor: DownloadFileScreenBusinessLogic, DownloadFileScreenDataStore {
    var presenter: DownloadFileScreenPresentationLogic?
    var worker: DownloadFileScreenWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var pdfData = Data()
    var pdfName = ""
    var notificationIdentifier: String = UUID().uuidString
    
    private var fileManager: FileManagerProtocol
    
    init(fileManager: FileManagerProtocol = FileManagerNEW()) {
        self.fileManager = fileManager
    }
    
    func getCurrentData() {
        presenter?.presentCurrentData(response: DownloadFileScreen.CurrentData.Response(pdfData: pdfData, pdfName: pdfName))
    }
    
    func saveFile(completion: @escaping() -> Void) {
        let item = PdfForSave(uuid: UUID().uuidString, creationDate: Date(), pdf: pdfData)
        let nameChecked = fileManager.makeNameWithNameAvialable(name: pdfName, url: path)
        fileManager.saveItem(save: item, at: path, name: nameChecked) { result in
            switch result {
            case .success():
                completion()
            case .failure(_):
                print("failure")
            }
        }
    }
    
    
    
}
