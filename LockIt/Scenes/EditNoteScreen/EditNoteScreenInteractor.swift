import UIKit

protocol EditNoteScreenBusinessLogic {
    func save(name: String, textNote: String?, completion: @escaping () -> Void)
    func getCurrentData()
}
protocol EditNoteScreenDataStore {
    var path: URL { get set }
    var currentName: String { get set }
    var notificationIdentifier: String { get set }
}

class EditNoteScreenInteractor: EditNoteScreenBusinessLogic, EditNoteScreenDataStore {
    var presenter: EditNoteScreenPresentationLogic?
    var worker: EditNoteScreenWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var currentName = ""
    var notificationIdentifier: String = ""
    
    private let fileManager = FileManagerNEW()
    private var response: NoteForSave?
    
    func getCurrentData() {
        switch fileManager.getFile(name: currentName, url: path) {
        case .success(let item):
            if let noteItem = item.item as? NoteForSave {
                response = noteItem
                presenter?.presentCurrentData(response: EditNoteScreen.CurrentData.Response(name: currentName, textNote: noteItem.text))
            }
        case .failure(let error):
            print("Ошибка при получении данных: \(error.localizedDescription)")
            self.presenter?.presentErrorNotSaved(response: FileManagerError.anyError.localizedDescription)
        }
    }
    
    func save(name: String, textNote: String?, completion: @escaping () -> Void) {
        guard var note = response else { return }
       
        note.text = textNote
        
        fileManager.saveItem(save: note, at: path, name: currentName) { result in
            switch result {
            case .success():
                if name != self.currentName {
                    let isAvailable = self.fileManager.isAvailableName(name: name, url: self.path)
                    
                    if isAvailable {
                        self.fileManager.renameFile(url: self.path, currentName: self.currentName, newName: name) { result in
                            switch result {
                            case .success():
                                print("Успешное переименование")
                                completion()
                            case .failure(let error):
                                print("Ошибка при переименовании: \(error.localizedDescription)")
                                self.presenter?.presentErrorNotSaved(response: FileManagerError.anyError.localizedDescription)
                            }
                        }
                    } else {
                        print("Ошибка при переименовании:")
                        self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
                    }
                }
                completion()
            case .failure(let error):
                print("Ошибка сохранения: \(error.localizedDescription)")
                self.presenter?.presentErrorNotSaved(response: FileManagerError.anyError.localizedDescription)
            }
        }
    }

}
