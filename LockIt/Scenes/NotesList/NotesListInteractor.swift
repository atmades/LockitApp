import UIKit

protocol NotesListBusinessLogic {
    func loadContent()
    
    func saveFolder(name: String) async throws
//    func saveFolder(folderName: String)
    func saveFile(file: ItemForSave, name: String)
    
    func selectItemForEdit(request: NotesList.SelectItem.Request)
    func selectFolderForRoute(request: NotesList.SelectFolderForRoute.Request)
    
    func getTitleName()
    func getNotificationIdentifier() -> String
    
    func printPath()
    
    func remove(item: ItemForPresent)
    func copy(url: URL, type: Type)
    func pasteCopied()
    func pasteIsAviable()
    func changeSort(selectSort: NotesList.SelectSort.Request)
}

protocol NotesListDataStore {
    var path: URL { get set }
    var folderName: String { get set }
    var countVC: Int { get set }
    var root: RootFolders { get }
    var notificationIdentifier: String { get set }
    var selectedItem: ItemForPresent? { get set }
    
    var folderURLForRoute: URL { get set }
    var folderNameForRoute: String { get set }
   
}

class NotesListInteractor: NotesListBusinessLogic, NotesListDataStore {
    var presenter: NotesListPresentationLogic?
    var worker: NotesListWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var folderName = ""
    var countVC: Int = 0
    var root: RootFolders = .notes
    var notificationIdentifier: String = UUID().uuidString
    var selectedItem: ItemForPresent?
    
    var folderURLForRoute: URL = URL(fileURLWithPath: "")
    var folderNameForRoute: String = ""
    
    private var response: [ItemForPresent] = []
    private var fileManager: FileManagerProtocol
    
    init(fileManager: FileManagerProtocol = FileManagerNEW()) {
        self.fileManager = fileManager
    }

    // Sort
    var currentSort: SortType = SortType.type
    
    func changeSort(selectSort: NotesList.SelectSort.Request) {
        currentSort = selectSort.selectSort
        presenter?.presentContent(response: NotesList.LoadContent.Response(sort: currentSort, items: response))
    }
    
    func printPath() {
        print("ContactListInteractor path")
        print(path)
    }
    
    func getNotificationIdentifier() -> String {
        return notificationIdentifier
    }
    
    func getTitleName() {
        self.presenter?.presentFolderName(response: NotesList.Folder.Response(folderName: folderName, counterVC: countVC))
    }
    
    func loadContent() {
        fileManager.fetchItemsForPresent(at: path) { [weak self] items in
            guard let self = self else { return }
            self.response = items
            self.presenter?.presentContent(response: NotesList.LoadContent.Response(sort: self.currentSort, items: self.response))
        }
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
        presenter?.presentUpdateMenu(response: NotesList.Menu.Response(pasteIsAviable: isAviable))
    }
    

    
    // Call before route to Rename
    func selectItemForEdit(request: NotesList.SelectItem.Request) {
        selectedItem = request.item
    }
    
    // Call before route to SubFolder
    func selectFolderForRoute(request: NotesList.SelectFolderForRoute.Request) {
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
        if item.type == .folder {
            removeFolder(name: item.name)
        } else {
            removeFile(item: item)
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
