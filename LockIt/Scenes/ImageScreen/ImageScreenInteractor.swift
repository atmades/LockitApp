import UIKit

protocol ImageScreenBusinessLogic {
    func loadContent()
    func shareImage(index: Int)
}
protocol ImageScreenDataStore {
    var items: [ItemForPresent] { get set }
    var index: Int { get set }
}

class ImageScreenInteractor: ImageScreenBusinessLogic, ImageScreenDataStore {
    var presenter: ImageScreenPresentationLogic?
    var worker: ImageScreenWorker?
    
    var items: [ItemForPresent] = []
    var index: Int = 0
    
    func loadContent() {
        presenter?.presentContent(response: ImageScreen.LoadContent.Response(itemImages: items, index: index))
    }
    
    func shareImage(index: Int) {
        let tempDirectory = NSTemporaryDirectory()
        let imageName = items[index].name + ".jpg"
        let imageURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(imageName)
        
        guard let imageItem = items[index].item as? ImageForSave else { return }
        guard UIImage(data: imageItem.imageData) != nil else { return }
        // 2. Запись данных PDF во временный файл
        do {
            try imageItem.imageData.write(to: imageURL)
            print("PDF успешно сохранен во временный файл: \(imageURL.path)")
            
            if FileManager.default.fileExists(atPath: imageURL.path) {
                print("Файл существует, можно продолжать шаринг")
              
            } else {
                print("Файл не найден по пути: \(imageURL.path)")
            }
            print(imageURL)
            presenter?.presentSharing(response: ImageScreen.Share.Response(temporaryURL: imageURL))
        } catch {
            print("Ошибка при сохранении PDF: \(error.localizedDescription)")
        }
    }
}
