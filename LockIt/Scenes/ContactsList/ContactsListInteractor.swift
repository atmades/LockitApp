import UIKit

protocol ContactsListBusinessLogic {
    func loadContent()
    
    func saveFolder(name: String) async throws
//    func saveFolder(folderName: String)
    func saveFile(file: ItemForSave, name: String)
    
    func selectConactForEdit(request: ContactsList.SelectContactForEdit.Request)
    func selectFolderForRename(request: ContactsList.SelectFolderForRename.Request)
    
    func selectFolderForRoute(request: ContactsList.SelectFolderForRoute.Request)
    
    func getTitleName()
    func getNotificationIdentifier() -> String
    
    func printPath()
    
    func remove(item: ItemForPresent)
    func copy(url: URL, type: Type)
    func pasteCopied()
    func pasteIsAviable()
}

protocol ContactsListDataStore {
    var path: URL { get set }
    var folderName: String { get set }
    var countVC: Int { get set }
    var root: RootFolders { get }
    var notificationIdentifier: String { get set }

    var selectedContactForEdit: ItemForPresent? { get set }
    var selectedFolderForRename: ItemForPresent? { get set }
    
    var folderURLForRoute: URL { get set }
    var folderNameForRoute: String { get set }
}

class ContactsListInteractor: ContactsListBusinessLogic, ContactsListDataStore {
    var presenter: ContactsListPresentationLogic?
    var worker: ContactsListWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var folderName = ""
    var countVC: Int = 0
    var root: RootFolders = .contacts
    var notificationIdentifier: String = UUID().uuidString
    
    var selectedContactForEdit: ItemForPresent?
    var selectedFolderForRename: ItemForPresent?
    
    var folderURLForRoute: URL = URL(fileURLWithPath: "")
    var folderNameForRoute: String = ""
    
    private var response: [ItemForPresent] = []
    private var fileManager: FileManagerProtocol
    
    init(fileManager: FileManagerProtocol = FileManagerNEW()) {
        self.fileManager = fileManager
    }
    
    func printPath() {
        print("ContactListInteractor path")
        print(path)
    }
    
    func pasteIsAviable() {
        var isAviable: Bool
        if let _ = ClipboardManager.shared.copiedURL,
           let _ = ClipboardManager.shared.copiedType,
           let rootFolder = ClipboardManager.shared.copiedRootFolder,
           rootFolder == root {
            isAviable = true
        } else {
            isAviable = false
        }
        presenter?.presentUpdateMenu(response: ContactsList.Menu.Response(pasteIsAviable: isAviable))
    }
    
    func getNotificationIdentifier() -> String {
        return notificationIdentifier
    }
    
    func getTitleName() {
        self.presenter?.presentFolderName(response: ContactsList.Folder.Response(folderName: folderName, counterVC: countVC))
    }
    
    func loadContent() {
        fileManager.fetchItemsForPresent(at: path) { [weak self] items in
            self?.response = items
            self?.presenter?.presentContent(response: ContactsList.LoadContent.Response(items: self?.response ?? [] ))
        }
    }
    
    // Call before route to Rename
    func selectConactForEdit(request: ContactsList.SelectContactForEdit.Request) {
        if let selected = response.first(where: { $0.item?.uuid == request.item.item?.uuid }) {
            selectedContactForEdit = selected
        } else {
            return
        }
    }
    
    func selectFolderForRename(request: ContactsList.SelectFolderForRename.Request) {
        print(request.item.name)
        selectedFolderForRename = request.item
    }
    
    // Call before route to SubFolder
    func selectFolderForRoute(request: ContactsList.SelectFolderForRoute.Request) {
        let name = request.folderNameForRoute
        
        fileManager.getFolderPath(folderName: name, url: path) { result in
            switch result {
            case .success(let folderPath):
                self.folderURLForRoute = folderPath
                self.folderNameForRoute = name
            case .failure(let error):
                print("Error getURLFromFolderName: \(error.localizedDescription)")
                //TODO: дирректория не найдена
            }
        }
    }
    
    func saveFolder(name: String) async throws {
        let isAvailableName = fileManager.isAvailableName(name: name, url: path)
        
        if isAvailableName {
            do {
                try await fileManager.createNewDirectory(folderName: name, at: path)
                // Выполнение завершено успешно
            } catch {
                print("Ошибка при создании директории")
//                presenter?.presentErrorNotSaved(response: error.localizedDescription)
                throw error
            }
        } else {
            print("Ошибка при переименовании:")
//            presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
            throw FileManagerError.fileAlreadyExists
        }
    }
    
//    func saveFolder(folderName: String) {
//        if fileManager.isAvailableName(name: folderName, url: path) {
//            fileManager.createNewDirectory(folderName: folderName, at: path) { result in
//                switch result {
//                case .success():
//                    print("success")
//                case .failure(_):
//                    print("failure")
//                }
//            }
//        } else {
//            print("имя уже есть")
//        }
//    }
    
    func saveFile(file: ItemForSave, name: String) {
        fileManager.saveItem(save: file, at: path, name: name) { result in
            switch result {
            case .success():
                print("success")
            case .failure(_):
                print("failure")
            }
        }
    }
    
    func remove(item: ItemForPresent) {
        // т.к. имя было модифицировано в презентере, нужно найти удаляемый объект по UUID
        guard let itemForRemove = response.first(where: { $0.item?.uuid == item.item?.uuid }) else { return }
        
        if item.type == .folder {
            removeFolder(name: itemForRemove.name)
        } else {
            removeFile(item: itemForRemove)
        }
    }
    
    func removeFile(item: ItemForPresent) {
        let fileName = "\(item.name).json"
        let fileURL = path.appendingPathComponent(fileName)
        
        fileManager.deleteFile(at: fileURL)  { result in
            switch result {
            case .success():
                print("success")
                ClipboardManager.shared.checkAfterDeleteFile(urlToFile: self.path, name: item.name)
            case .failure(_):
                print("failure")
            }
        }
    }
    
    func removeFolder(name: String) {
        let folderPath = path.appendingPathComponent(name)
        fileManager.deleteFolderRecursively(at: folderPath) { result in
            switch result {
            case .success():
                print("success")
                ClipboardManager.shared.checkAfterDeleteFolder(urlToFolder: self.path, name: name)
            case .failure(_):
                print("failure")
            }
        }
    }
    
    func copy(url: URL, type: Type) {
        ClipboardManager.shared.saveForFileList(url: url, type: type, root: root)
    }
    
    func pasteCopied() {
        guard let copiedPath = ClipboardManager.shared.copiedURL,
              let type = ClipboardManager.shared.copiedType,
              let rootFolder = ClipboardManager.shared.copiedRootFolder,
              rootFolder == root
        else {
            print("In ClipboardManager there are no any path for copy")
            return
        }
        if type == .folder {
            pasteCopiedFolder(urlForCopy: copiedPath, destination: path)
        } else {
            pasteCopiedFile(filePath: copiedPath)
        }
    }
    
    func pasteCopiedFile(filePath: URL) {
        let destinationFolderURL = path
        let name = (filePath.lastPathComponent as NSString).deletingPathExtension

        let checkedName = fileManager.makeNameWithNameAvialable(name: name, url: destinationFolderURL)
        
        let nameWithExtensionJSON = checkedName + ".json"
        let destinationFileURL = destinationFolderURL.appendingPathComponent(nameWithExtensionJSON)
        fileManager.saveCopiedFileAsDublicate(sourceURL: filePath, distinationURL: destinationFileURL) { result in
            switch result {
            case .success():
                self.loadContent()
            case .failure(_):
                print("failure")
            }
        }
    }
    
    func pasteCopiedFolder(urlForCopy: URL, destination: URL) {
        // Проверяем, является ли папка для копирования вложенной в целевую папку
        if destination.path.hasPrefix(urlForCopy.path) {
            print("Папка вложена внутрь искомой")
            return
        }
        
        let nameForCheck = urlForCopy.lastPathComponent
        let nameChecked = fileManager.makeNameWithNameAvialable(name: nameForCheck, url: destination)
        let destinationURL = destination.appendingPathComponent(nameChecked)

        fileManager.saveCopiedFolderAsDublicate(from: urlForCopy, to: destinationURL) { result in
            self.loadContent()
        }
    }
}
