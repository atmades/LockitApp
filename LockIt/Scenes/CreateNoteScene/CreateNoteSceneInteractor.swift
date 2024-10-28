import UIKit

protocol CreateNoteSceneBusinessLogic {
    func saveNote(name: String, item: ItemForSave , completion: @escaping() -> Void)
}

protocol CreateNoteSceneDataStore {
    var path: URL { get set }
    var notificationIdentifier: String { get set }
}

class CreateNoteSceneInteractor: CreateNoteSceneBusinessLogic, CreateNoteSceneDataStore {
    var presenter: CreateNoteScenePresentationLogic?
    var worker: CreateNoteSceneWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var notificationIdentifier: String = ""
    
    private let fileManager = FileManagerNEW()
    
    func saveNote(name: String, item: ItemForSave , completion: @escaping() -> Void) {
        let isAvailableName = fileManager.isAvailableName(name: name, url: path)
        
        if isAvailableName {
            fileManager.saveItem(save: item, at: path, name: name) { result in
                switch result {
                case .success():
                    completion()
                case .failure(let error):
                    print("failure saveItem")
                    self.presenter?.presentErrorNotSaved(response: error.localizedDescription)
                }
            }
        } else {
            print("Ошибка при переименовании:")
            print("имя уже есть")
            self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
        }
    }
}
