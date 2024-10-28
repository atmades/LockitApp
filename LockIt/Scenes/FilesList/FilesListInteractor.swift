import UIKit

enum TypeFile {
    case image, pdf
}

protocol FilesListBusinessLogic {
    func loadContent()
    
    func saveFolder(name: String) async throws
    //    func saveFolder(folderName: String)
    func saveFile(file: ItemForSave, name: String)
    func saveFile(file: ItemForSave, name: String, type: TypeFile)
    
    func selectItemForEdit(request: FilesList.SelectItem.Request)
    func selectFolderForRoute(request: FilesList.SelectFolderForRoute.Request)
    
    func getTitleName()
    func getNotificationIdentifier() -> String
    
    func printPath()
    
    func remove(item: ItemForPresent)
    func copy(url: URL, type: Type)
    func pasteCopied()
    func pasteIsAviable()
    func changeSort(selectSort: FilesList.SelectSort.Request)
    func prepareImageGallery(request: FilesList.Images.Request, completion: @escaping () -> Void)
    
    func checkClipboard()
    func downloadPdf(urlString: String)
    func makeFotoForPDF()
}

protocol FilesListDataStore {
    var path: URL { get set }
    var folderName: String { get set }
    var countVC: Int { get set }
    var root: RootFolders { get }
    var notificationIdentifier: String { get set }
    var selectedItem: ItemForPresent? { get set }
    
    var folderURLForRoute: URL { get set }
    var folderNameForRoute: String { get set }
    
    var downloadedData: Data { get set }
    var downloadedName: String { get set }
    
    var imageItems: [ItemForPresent] { get set }
    var indexSelectedImage: Int { get set }
}

class FilesListInteractor: FilesListBusinessLogic, FilesListDataStore {
    var presenter: FilesListPresentationLogic?
    var worker: FilesListWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var folderName = ""
    var countVC: Int = 0
    var root: RootFolders = .files
    
    var notificationIdentifier: String = UUID().uuidString
    var selectedItem: ItemForPresent?
    
    var folderURLForRoute: URL = URL(fileURLWithPath: "")
    var folderNameForRoute: String = ""
    
    var downloadedData = Data()
    var downloadedName = ""
    
    private var response: [ItemForPresent] = []
    private var fileManager: FileManagerProtocol
    private let downloadManager = DownloadManager()
    private let webClipboardManager = WebClipboardManager()
    private let documentManager = DocumentManager()
    
    
    init(fileManager: FileManagerProtocol = FileManagerNEW()) {
        self.fileManager = fileManager
    }
    
    var images: [ItemForPresent] = []
    
    // Sort
    var currentSort: SortType = SortType.type
    func changeSort(selectSort: FilesList.SelectSort.Request) {
        currentSort = selectSort.selectSort
        presenter?.presentContent(response: FilesList.LoadContent.Response(sort: currentSort, items: response))
    }
    
    func selectImage() {
        for item in response {
            if let _ = item.item as? ImageForSave {
                images.append(item)
            }
        }
    }
    
    // Other
    func printPath() {
        print("FileListInteractor path")
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
        presenter?.presentUpdateMenu(response: FilesList.Menu.Response(pasteIsAviable: isAviable))
    }
    
    func getNotificationIdentifier() -> String {
        return notificationIdentifier
    }
    
    func getTitleName() {
        self.presenter?.presentFolderName(response: FilesList.Folder.Response(folderName: folderName, counterVC: countVC))
    }
    
    // load
    func loadContent() {
        fileManager.fetchItemsForPresent(at: path) { [weak self] items in
            guard let self = self else { return }
            self.response = items
            if !self.response.isEmpty {
                self.presenter?.presentContent(response: FilesList.LoadContent.Response(sort: self.currentSort, items: self.response))
                print("responce is \(response.count)")
            } else {
                print("responce is empty")
                return
            }
            //            self.presenter?.presentContent(response: FilesList.LoadContent.Response(sort: self.currentSort, items: self.response))
        }
    }
    
    // Call before route to Rename
    func selectItemForEdit(request: FilesList.SelectItem.Request) {
        selectedItem = request.item
    }
    
    var imageItems = [ItemForPresent]()
    var indexSelectedImage = 0
    
    func prepareImageGallery(request: FilesList.Images.Request, completion: @escaping () -> Void) {
        imageItems = []
        for item in request.items {
            if let _ = item.item as? ImageForSave {
                imageItems.append(item)
            }
        }
        if let index = imageItems.firstIndex(where: { $0.name == request.name }) {
            indexSelectedImage = index
            print("Структура с именем \(request.name) найдена в массиве с индексом \(index)")
            completion()
        } else {
            print("Структура с именем \(request.name) не найдена в массиве")
        }
        
    }
    
    // Call before route to SubFolder
    func selectFolderForRoute(request: FilesList.SelectFolderForRoute.Request) {
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
    func saveFile(file: ItemForSave, name: String, type: TypeFile) {}
    
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
    
    func saveImage(image: UIImage, name: String) {
        if let data = image.jpegData(compressionQuality: 0.6) {
            let uuid = UUID().uuidString
            let itemForSave = ImageForSave(uuid: uuid, creationDate: Date(), imageData: data)
            
        }
        
        //        fileManager.saveItem(save: file, at: path, name: name) { result in
        //            switch result {
        //            case .success():
        //                print("success")
        //            case .failure(_):
        //                print("failure")
        //            }
        //        }
    }
    
    func remove(item: ItemForPresent) {
        if item.type == .folder {
            removeFolder(name: item.name)
        } else {
            removeFile(item: item)
        }
        
        if let index = response.firstIndex(where: { $0.name == item.name }) {
            response.remove(at: index)
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
        // Получаем абсолютные пути к папкам для копирования и назначения
        let absoluteURLForCopy = urlForCopy.standardizedFileURL
        let absoluteDestinationURL = destination.standardizedFileURL
        
        // Проверяем, содержится ли путь к папке для копирования в пути к целевой папке
        if absoluteDestinationURL.absoluteString.contains(absoluteURLForCopy.absoluteString) {
            print("Папка вложена внутрь искомой")
            self.presenter?.presentError(response: FilesList.Error.Response(message: "Папка вложена внутрь искомой"))
            return
        }
        
        let nameForCheck = urlForCopy.lastPathComponent
        let nameChecked = fileManager.makeNameWithNameAvialable(name: nameForCheck, url: destination)
        let destinationURL = destination.appendingPathComponent(nameChecked)
        
        fileManager.saveCopiedFolderAsDublicate(from: urlForCopy, to: destinationURL) { result in
            self.loadContent()
        }
    }
    
    
    func checkClipboard() {
        let urlString = webClipboardManager.getURLFromClipboard()
        presenter?.presentAlertClipboard(response: FilesList.ClipBoardForPDF.Response(urlString: urlString))
        
    }
    
    func downloadPdf(urlString: String) {
        
        downloadManager.downloadTest(urlString: urlString) { result in
            switch result {
            case .success(let downloadResult):
                print("Сообщение: \(downloadResult.message)")
                print("Размер до: \(downloadResult.originalSize / 1024) KB")
                if let compressedSize = downloadResult.compressedSize {
                    print("Размер после сжатия: \(compressedSize / 1024) KB")
                }
                
                let data = downloadResult.data
                let fileName = downloadResult.fileName
                
                self.downloadedData = data
                self.downloadedName = fileName
                self.presenter?.presentDownloaded(response: FilesList.Downloaded.Response(pdfData: data, pdfFileName: fileName))

            case .failure(let error):
                switch error {
                case .invalidURL:
                    print("Ошибка: Неправильный URL")
                case .invalidFileType:
                    print("Ошибка: Файл не является PDF")
                case .compressionFailed:
                    print("Ошибка: Файл слишком большой, и мы не смогли его сжать")
                case .invalidPDF:
                    print("Ошибка: Файл не является допустимым PDF")
                }
            }
        }
        
        
        
        //        downloadManager.downloadTest(urlString: urlString) { data, location, fileName, error in
        //            if let error = error {
        //                print("Ошибка загрузки файла: \(error)")
        //                self.presenter?.presentError(response: FilesList.Error.Response(message: error.localizedDescription))
        //                return
        //            }
        //
        //            guard let data = data, let fileName = fileName else { return }
        //
        //            self.downloadedData = data
        //            self.downloadedName = fileName
        //            self.presenter?.presentDownloaded(response: FilesList.Downloaded.Response(pdfData: data, pdfFileName: fileName))
        //        }
    }
    
    func makeFotoForPDF() {
        
    }
    
    
    
}
