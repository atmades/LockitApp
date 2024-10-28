import UIKit

protocol RenameBusinessLogic {
    func printPath()
    func rename(name: String, completion: @escaping () -> Void)
    func getCurrentName()
}
protocol RenameDataStore {
    var path: URL { get set }
    var itemPresent: ItemForPresent? { get set }
    var root: RootFolders? { get set }
    var notificationIdentifier: String { get set }
}

class RenameInteractor: RenameBusinessLogic, RenameDataStore {
    var presenter: RenamePresentationLogic?
    var worker: RenameWorker?
    var path: URL = URL(fileURLWithPath: "")
    var itemPresent: ItemForPresent?
    var root: RootFolders?
    var notificationIdentifier: String = ""
    
    private let fileManager = FileManagerNEW()
    
    func printPath() {
        print(path.path())
    }
    
    func getCurrentName() {
        presenter?.presentCurrentName(response: Rename.CurrentData.Response(name: itemPresent?.name))
    }
}

extension RenameInteractor {
    // Рабочая версия
    func rename(name: String, completion: @escaping () -> Void) {
        if itemPresent?.type == .folder {
            renameFolder(name: name) {
                ClipboardManager.shared.updateFolderURL(oldFolderName: self.itemPresent?.name ?? "", newFolderName: name, root: self.root)
                completion() }
        } else {
            renameFile(newName: name) {
                ClipboardManager.shared.updateFileListFileURL(urlToFile: self.path, newName: name, root: self.root)
                completion() }
        }
    }
    
    // Рабочая версия
    func renameFile(newName: String, completion: @escaping () -> Void) {
        guard let file = itemPresent else { return }
        let isAvailable = FileManagerNEW().isAvailableName(name: newName, url: path)
        
        if isAvailable {
            fileManager.renameFile(url: path, currentName: file.name, newName: newName) { result in
                switch result {
                case .success():
                    print("Успешное переименование")
                    completion()
                case .failure(let error):
                    print("Ошибка при переименовании: \(error.localizedDescription)")
                    self.presenter?.presentErrorNotSaved(response: error.localizedDescription)
                }
            }
        } else {
            print("Ошибка при переименовании:")
            self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
        }
        
    }
    // Рабочая версия
    func renameFolder(name: String, completion: @escaping () -> Void) {
        guard let folder = itemPresent else { return }
        let sourceURL = path.appendingPathComponent(folder.name)
        let isAvailable = FileManagerNEW().isAvailableName(name: name, url: path)
        
        if isAvailable {
            fileManager.renameFolderRecursively(at: sourceURL, to: name) { result in
                switch result {
                case .success:
                    print("Успешное переименование")
                    completion() // Вызов замыкания по завершению успешного переименования
                case .failure(let error):
                    print("Ошибка при переименовании: \(error.localizedDescription)")
                }
            }
        } else {
            print("Имя уже существует")
            self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
        }
    }
}
