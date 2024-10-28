import UIKit

protocol CreatePdfFromPhotoSceneBusinessLogic {
    func getCurrentData()
    func createAndSavePDF(images: [UIImage], completion: @escaping() -> Void)
    func createPdf(images: [UIImage])
    func savePdf(completion: @escaping() -> Void)
}

protocol CreatePdfFromPhotoSceneDataStore {
    var path: URL { get set }
    var notificationIdentifier: String { get set }
    var pdfData: Data? { get set }
    var pdfName: String { get set }
}

class CreatePdfFromPhotoSceneInteractor: CreatePdfFromPhotoSceneBusinessLogic, CreatePdfFromPhotoSceneDataStore {
    var presenter: CreatePdfFromPhotoScenePresentationLogic?
    var worker: CreatePdfFromPhotoSceneWorker?
    
    private var fileManager: FileManagerProtocol
    private let pdfManager: PDFManagerProtocol
    
    var path: URL = URL(fileURLWithPath: "")
    var notificationIdentifier: String = UUID().uuidString
    var pdfName = ""
    var defaultName = "Document"
    var pdfData: Data?
    
    init(fileManager: FileManagerProtocol = FileManagerNEW(),
         pdfManager: PDFManagerProtocol = PDFManager() ) {
        self.fileManager = fileManager
        self.pdfManager = pdfManager
    }
    
    func getCurrentData() {
        defaultName = defaultName + ".pdf"
        pdfName = self.fileManager.makeNameWithNameAvialable(name: defaultName, url: self.path)
        pdfName = pdfName.replacingOccurrences(of: ".pdf", with: "")
        presenter?.presentCurrentdata(response: CreatePdfFromPhotoScene.CurrentData.Response(name: pdfName))
    }
    
    func createPdf(images: [UIImage]) {
        guard !images.isEmpty else {
            presenter?.presentError(response: "Добавьте изображения")
            return
        }
        pdfManager.createPDF(from: images) { result in
            switch result {
            case .success(let pdfData):
                print("PDF успешно создан!")
                self.pdfData = pdfData
                self.presenter?.presentCreatedPDF(response: CreatePdfFromPhotoScene.CreatedPDF.Response(pdfData: pdfData))
            case .failure(let error):
                print("Ошибка создания PDF: \(error.localizedDescription)")
                self.presenter?.presentError(response: error.localizedDescription)
            }
        }
    }
    
    func savePdf(completion: @escaping() -> Void) {
        guard let pdfData = pdfData else {
            self.presenter?.presentError(response: "Документ не создан")
            return }
        let item = PdfForSave(uuid: UUID().uuidString, creationDate: Date(), pdf: pdfData)
        var nameChecked = pdfName.replacingOccurrences(of: ".", with: "_")
        nameChecked = nameChecked + ".pdf"
        let isAvailableName = fileManager.isAvailableName(name: nameChecked, url: path)
        
        if isAvailableName == false {
            nameChecked = self.fileManager.makeNameWithNameAvialable(name: nameChecked, url: self.path)
        }
        self.fileManager.saveItem(save: item, at: self.path, name: nameChecked) { result in
            switch result {
            case .success():
                print("pdf is saved")
                completion()
            case .failure(_):
                print("failure save file")
            }
        }
    }
    
    func createAndSavePDF(images: [UIImage], completion: @escaping() -> Void) {
        pdfManager.createPDF(from: images) { result in
            switch result {
            case .success(let pdfData):
                print("PDF успешно создан!")
                
                self.pdfData = pdfData
                // Saving pdf
                let item = PdfForSave(uuid: UUID().uuidString, creationDate: Date(), pdf: pdfData)
                let nameChecked = self.fileManager.makeNameWithNameAvialable(name: self.pdfName, url: self.path)
                self.fileManager.saveItem(save: item, at: self.path, name: nameChecked) { result in
                    switch result {
                    case .success():
                        print("pdf is saved")
                        completion()
                    case .failure(_):
                        print("failure save file")
                    }
                }
            case .failure(let error):
                print("Ошибка создания PDF: \(error.localizedDescription)")
            }
        }
    }
    
    func saveFile(pdfData: Data, completion: @escaping() -> Void) {
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
