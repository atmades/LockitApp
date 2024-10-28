import UIKit

protocol DocumentScreenBusinessLogic {
    func getCurrentData()
    func sharePDF()
}
protocol DocumentScreenDataStore {
    var path: URL { get set }
    var currentSystemName: String { get set }
}

class DocumentScreenInteractor: DocumentScreenBusinessLogic, DocumentScreenDataStore {
    var presenter: DocumentScreenPresentationLogic?
    var worker: DocumentScreenWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var currentSystemName = ""
    
    private let fileManager = FileManagerNEW()
    private var response: PdfForSave?
    
    
    
    func getCurrentData() {
        switch fileManager.getFile(name: currentSystemName, url: path) {
        case .success(let item):
            if let noteItem = item.item as? PdfForSave {
                response = noteItem
                presenter?.presentCurrentData(response: DocumentScreen.CurrentData.Response(pdfData: response?.pdf, pdfName: currentSystemName))
            }
        case .failure(let error):
            print("Ошибка при получении данных: \(error.localizedDescription)")
//            self.presenter?.presentErrorNotSaved(response: FileManagerError.anyError.localizedDescription)
        }
    }
    
    func sharePDF() {
        let tempDirectory = NSTemporaryDirectory()
        let pdfFileName = currentSystemName // Имя файла
        let pdfURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(pdfFileName)
        
        guard let dataPDF = response?.pdf else { return }
        // 2. Запись данных PDF во временный файл
        do {
            try dataPDF.write(to: pdfURL)
            print("PDF успешно сохранен во временный файл: \(pdfURL.path)")
            
            if FileManager.default.fileExists(atPath: pdfURL.path) {
                print("Файл существует, можно продолжать шаринг")
              
            } else {
                print("Файл не найден по пути: \(pdfURL.path)")
            }
            
            print(pdfURL)
            presenter?.presentSharing(response: DocumentScreen.Share.Response(temporaryURL: pdfURL))
        } catch {
            print("Ошибка при сохранении PDF: \(error.localizedDescription)")
        }
    }
}
