import UIKit

protocol CreateFolderBusinessLogic {
    func printPath()
//    func saveFolder(name: String, completion: @escaping() -> Void)
//    func saveFolder(name: String) async
    func saveFolder(name: String) async throws
}
protocol CreateFolderDataStore {
    var path: URL { get set }
    var notificationIdentifier: String { get set }
}

class CreateFolderInteractor: CreateFolderBusinessLogic, CreateFolderDataStore {
    var presenter: CreateFolderPresentationLogic?
    var worker: CreateFolderWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var notificationIdentifier: String = ""
    
    private let fileManager = FileManagerNEW()
    
    func printPath() {
        print(path.path())
        print("notificationIdentifier")
        print(notificationIdentifier)
    }
    
    func saveFolder(name: String) async throws {
        let isAvailableName = fileManager.isAvailableName(name: name, url: path)
        
        if isAvailableName {
            do {
                try await fileManager.createNewDirectory(folderName: name, at: path)
            } catch {
                print("Ошибка при создании директории")
                presenter?.presentErrorNotSaved(response: error.localizedDescription)
                throw error
            }
        } else {
            print("Ошибка при переименовании:")
            presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
            throw FileManagerError.fileAlreadyExists
        }
    }
    
//    func saveFolder(name: String, completion: @escaping() -> Void) {
//        let isAvailableName = fileManager.isAvailableName(name: name, url: path)
//        
//        if isAvailableName {
//            fileManager.createNewDirectory(folderName: name, at: path) { result in
//                switch result {
//                case .success():
//                    completion()
//                case .failure(let error):
//                    print("failure createNewDirectory")
//                    self.presenter?.presentErrorNotSaved(response: error.localizedDescription)
//                }
//            }
//        } else {
//            print("Ошибка при переименовании:")
//            self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
//        }
//    }
}


