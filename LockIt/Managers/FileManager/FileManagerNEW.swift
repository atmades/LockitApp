import Foundation

protocol FileManagerProtocol {
    func isAvailableName(name: String, url: URL) -> Bool
    func makeNameWithNameAvialable(name: String, url: URL) -> String
    
    func saveItem<T>(save item: T, at url: URL, name: String, completion: @escaping (Result<Void, Error>) -> Void) where T : ItemForSave, T : Decodable, T : Encodable
    func getFolderPath(folderName: String, url: URL, completion: ((Result<URL, Error>) -> Void)?)
    
//    func createNewDirectory(folderName: String, at url: URL, completion: ((Result<Void, Error>) -> Void)?)
    func createNewDirectory(folderName: String, at url: URL) async throws
    
    func deleteFolderRecursively(at url: URL, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFile(at url: URL, completion: @escaping (Result<Void, Error>) -> Void)
    func removeAll()
    
    func renameFolderRecursively(at sourceURL: URL, to destinationName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func renameFile(url: URL, currentName: String, newName: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getFile(name: String, url: URL) ->  Result<ItemForPresent, Error>
    func fetchItemsForPresent(at url: URL, completion: @escaping ([ItemForPresent]) -> Void)
    
    func saveCopiedFileAsDublicate(sourceURL: URL, distinationURL: URL, completion: @escaping (Result<Void, Error>) -> Void)
    func saveCopiedFolderAsDublicate(from sourceURL: URL, to destinationURL: URL, completion: @escaping (Result<Void, Error>) -> Void)
    
    func createRootFolder(rootFolder: RootFolders, completion: ((Error?) -> Void)?)
    func getPathRootFolder(rootFolder: RootFolders, completion: ((URL) -> Void))
}

final class FileManagerNEW: FileManagerProtocol {
    
    private let coder = CoderItem()
    
    // MARK: - Helpers
    func isAvailableName(name: String, url: URL) -> Bool {
        
        let fileURL = url.appendingPathComponent(name + ".json")
        let folderURL = url.appendingPathComponent(name)

        guard FileManager.default.fileExists(atPath: fileURL.path) == false else {
            return false
        }
        guard FileManager.default.fileExists(atPath: folderURL.path) == false else {
            return false
        }
        return true
    }
    
    func makeNameWithNameAvialable(name: String, url: URL) -> String {
        var nameChecked = name
        var countInFolder = 1
        var isAvailable = isAvailableName(name: nameChecked, url: url)
        
        while !isAvailable {
            nameChecked = "\(countInFolder) \(name)"
            countInFolder += 1
            isAvailable = isAvailableName(name: nameChecked, url: url)
        }
        return nameChecked
    }
    
    func getFolderPath(folderName: String, url: URL, completion: ((Result<URL, Error>) -> Void)?)  {
        let folderURL = url.appendingPathComponent(folderName)
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory)
        if isDirectory.boolValue {
            completion?(.success(folderURL))
        } else {
            completion?(.failure(NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Директория не существует"])))
            completion?(.failure(FileManagerError.directoryNotFound))
        }
    }
    
    // MARK: - Create
    
    func saveItem<T>(save item: T, at url: URL, name: String, completion: @escaping (Result<Void, Error>) -> Void) where T : ItemForSave, T : Decodable, T : Encodable {
        do {
            let fileName = "\(name).json"
            let fileURL = url.appendingPathComponent(fileName)
            let itemData = try JSONEncoder().encode(item)
            
            let itemW = ItemWrapper(type: T.typeKey, data: itemData)
            let itemDataW = try JSONEncoder().encode(itemW)
            try itemDataW.write(to: fileURL)
            completion(.success(()))
        } catch {
            completion(.failure(FileManagerError.errorSaveFile))
        }
    }
    
    // Переписываем функцию для поддержки async/await.
    func createNewDirectory(folderName: String, at url: URL) async throws {
        let directoryURL = url.appendingPathComponent(folderName)
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw FileManagerError.errorCreatefolder
        }
    }
    
//    func createNewDirectory(folderName: String, at url: URL, completion: ((Result<Void, Error>) -> Void)?) {
//        let directoryURL = url.appendingPathComponent(folderName)
//        do {
//            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
//            completion?(.success(()))
//        } catch {
//            completion?(.failure(FileManagerError.errorCreatefolder))
//        }
//    }
    
    // MARK: - DELETE
    
    func deleteFolderRecursively(at url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            
            // Рекурсивно удаляем каждый элемент
            for itemURL in contents {
                var isDirectory: ObjCBool = false
                fileManager.fileExists(atPath: itemURL.path, isDirectory: &isDirectory)
                
                if isDirectory.boolValue {
                    deleteFolderRecursively(at: itemURL) { result in
                        if case .failure(let error) = result {
                            print(error.localizedDescription)
                            completion(.failure(FileManagerError.anyError))
                            return
                        }
                    }
                } else {
                    // Если это файл, удаляем его
                    try fileManager.removeItem(at: itemURL)
                }
            }
            try fileManager.removeItem(at: url)
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(FileManagerError.anyError))
        }
    }
    
    func deleteFile(at url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let fileManager = FileManager.default
        
        do {
            guard fileManager.fileExists(atPath: url.path) else {
                completion(.failure(FileManagerError.fileNotFound))
                return
            }
            try fileManager.removeItem(at: url)
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(FileManagerError.anyError))
        }
    }
    
    func removeAll() {
        if let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Файл удален: \(fileURL)")
                }
            } catch {
                print("Ошибка при удалении файлов: \(error.localizedDescription)")
            }
        }
    }
}

extension FileManagerNEW {
    
    // MARK: - RENAME
    func renameFolderRecursively(at sourceURL: URL, to destinationName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let fileManager = FileManager.default
        var count = 1
        func processCompletion() {
            count -= 1
            if count == 0 {
                completion(.success(()))
            }
        }
        do {
            // Получаем родительскую папку
            let parentURL = sourceURL.deletingLastPathComponent()
            
            // Проверяем существует ли родительская папка
            guard fileManager.fileExists(atPath: parentURL.path) else {
                completion(.failure(FileManagerError.anyError))
                return
            }
            
            // Создаем новый путь для папки
            let destinationURL = parentURL.appendingPathComponent(destinationName)
            
            // Переименовываем саму папку
            try fileManager.moveItem(at: sourceURL, to: destinationURL)
            
            // Получаем содержимое папки
            let contents = try fileManager.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil, options: [])
            
            // Обходим каждый элемент в папке
            for itemURL in contents {
                // Проверяем, является ли элемент папкой
                var isDirectory: ObjCBool = false
                fileManager.fileExists(atPath: itemURL.path, isDirectory: &isDirectory)
                
                if isDirectory.boolValue {
                    // Если элемент - папка, рекурсивно переименовываем ее
                    count += 1
                    renameFolderRecursively(at: itemURL, to: itemURL.lastPathComponent, completion: { result in
                        if case .failure(let error) = result {
                            completion(.failure(error))
                        }
                        processCompletion()
                    })
                } else {
                    let newFileName = itemURL.lastPathComponent.replacingOccurrences(of: sourceURL.lastPathComponent, with: destinationName)
                    let newFileURL = destinationURL.appendingPathComponent(newFileName)
                    try fileManager.moveItem(at: itemURL, to: newFileURL)
                }
            }
            processCompletion()
        } catch {
            completion(.failure(error))
        }
    }
    
    // ItemForSave Рабочая версия
    func renameFile(url: URL, currentName: String, newName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let sourcePath = url.appendingPathComponent(currentName + ".json")
        let destinationPath = url.appendingPathComponent(newName + ".json")
        print(sourcePath)
        do {
            guard FileManager.default.fileExists(atPath: sourcePath.path) else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не существует"])
                completion(.failure(error))
                return
            }
            try FileManager.default.moveItem(at: sourcePath, to: destinationPath)
            
            if FileManager.default.fileExists(atPath: destinationPath.path) {
                completion(.success(()))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не найден по новому пути"])
                completion(.failure(error))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - FETCH
    
    func getFile(name: String, url: URL) ->  Result<ItemForPresent, Error> {
       
        let sourcePath = url.appendingPathComponent(name + ".json")
        guard FileManager.default.fileExists(atPath: sourcePath.path)
        else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не существует"])
            return .failure(error)
        }
        do {
            let data = try Data(contentsOf: sourcePath)
            guard let item = coder.decodeItem(from: data)
            else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не декодирован"])
                return .failure(error)
            }
            let itemSize = getFileSize(url: url)
            let date = getDateModificated(url: url)
            let name = sourcePath.deletingPathExtension().lastPathComponent
            
            let itemPresent = ItemForPresent(name: name, type: .file, path: sourcePath, item: item, size: itemSize, dateModoficated: date)
            return .success(itemPresent)
        } catch {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не декодирован"])
            return .failure(error)
        }
    }
    
    func fetchItemsForPresent(at url: URL, completion: @escaping ([ItemForPresent]) -> Void) {
        DispatchQueue.global().async {
            var itemsForPresent: [ItemForPresent] = []
            let group = DispatchGroup()
            
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey, .contentModificationDateKey], options: [])
                
                for url in contents {
                    group.enter()
                    DispatchQueue.global().async {
                        var isDirectory: ObjCBool = false
                        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
                        let date = self.getDateModificated(url: url)
                        
                        if isDirectory.boolValue {
                            let folderName = url.lastPathComponent
                            let size = self.getDirectorySize(at: url)
                            let formattedSize = self.formatFileSize(size ?? 0)
                            let countFiles = self.countFilesInside(at: url)
                            
                            let itemFolder = ItemForPresent(name: folderName, type: .folder, path: url, size: formattedSize, dateModoficated: date, countFiles: countFiles)
                            itemsForPresent.append(itemFolder)
                        } else {
                            do {
                                let data = try Data(contentsOf: url)
                                guard let item = self.coder.decodeItem(from: data) else {
                                    // Handle unable to decode item
                                    group.leave()
                                    return
                                }
                                let name = url.deletingPathExtension().lastPathComponent
                                let itemSize = self.getFileSize(url: url)
                                
                                let itemPresent = ItemForPresent(name: name, type: .file, path: url, item: item, size: itemSize, dateModoficated: date)
                                itemsForPresent.append(itemPresent)
                            } catch {
                                print("Error reading data from file: \(error)")
                            }
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(itemsForPresent)
                }
            } catch {
                print("Error fetching directory contents: \(error)")
                DispatchQueue.main.async {
                    completion(itemsForPresent) // Return empty if error occurs
                }
            }
        }
    }
    
//    func fetchItemsForPresent(at url: URL, completion: @escaping ([ItemForPresent]) -> Void) {
//        DispatchQueue.global().async {
//            var itemsForPresent: [ItemForPresent] = []
//            
//            do {
//                let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey, .contentModificationDateKey], options: [])
//                
//                for url in contents {
//                    var isDirectory: ObjCBool = false
//                    FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
//                    let date = self.getDateModificated(url: url)
//                    
//                    if isDirectory.boolValue {
//                        let folderName = url.lastPathComponent
//                        let size = self.getDirectorySize(at: url)
//                        let formattedSize = self.formatFileSize(size ?? 0)
//                        let countFiles = self.countFilesInside(at: url)
//                        
//                        let itemFolder = ItemForPresent(name: folderName, type: .folder, path: url, size: formattedSize, dateModoficated: date, countFiles: countFiles)
//                        itemsForPresent.append(itemFolder)
//                    } else {
//                        do {
//                            let data = try Data(contentsOf: url)
//                            guard let item = self.coder.decodeItem(from: data) else {
//                                // Handle unable to decode item
//                                continue
//                            }
//                            let name = url.deletingPathExtension().lastPathComponent
//                            var itemSize = self.getFileSize(url: url)
//                            
//                            let itemPresent = ItemForPresent(name: name, type: .file, path: url, item: item, size: itemSize, dateModoficated: date)
//                            itemsForPresent.append(itemPresent)
//                        } catch {
//                            print("Error reading data from file: \(error)")
//                        }
//                    }
//                }
//            } catch {
//                print("Error fetching directory contents: \(error)")
//            }
//            
//            DispatchQueue.main.async {
//                completion(itemsForPresent)
//            }
//        }
//    }
    
    
//    func fetchItemsForPresent(at url: URL, completion: @escaping ([ItemForPresent]) -> Void) {
//        var itemsForPresent: [ItemForPresent] = []
//
//        do {
//            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey, .contentModificationDateKey], options: [])
//
//            for url in contents {
//                var isDirectory: ObjCBool = false
//                FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
//                let date = getDateModificated(url: url)
//
//                if isDirectory.boolValue {
//                    let folderName = url.lastPathComponent
//                    let size = getDirectorySize(at: url)
//                    let formattedSize = formatFileSize(size ?? 0)
//                    let countFiles = countFilesInside(at: url)
//
//                    let itemFolder = ItemForPresent(name: folderName, type: .folder, path: url, size: formattedSize, dateModoficated: date, countFiles: countFiles)
//                    itemsForPresent.append(itemFolder)
//                } else {
//                    do {
//                        let data = try Data(contentsOf: url)
//                        guard let item = coder.decodeItem(from: data) else {
//                            // Handle unable to decode item
//                            continue
//                        }
//                        let name = url.deletingPathExtension().lastPathComponent
//                        var itemSize = getFileSize(url: url)
//
//                        let itemPresent = ItemForPresent(name: name, type: .file, path: url, item: item, size: itemSize, dateModoficated: date)
//                        itemsForPresent.append(itemPresent)
//                    } catch {
//                        print("Error reading data from file: \(error)")
//                    }
//                }
//            }
//        } catch {
//            print("Error fetching directory contents: \(error)")
//            completion([])
//        }
//        completion(itemsForPresent)
//    }
    
    // MARK: - Save Copied As Dublicate
    
    func saveCopiedFileAsDublicate(sourceURL: URL, distinationURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard FileManager.default.fileExists(atPath: sourceURL.path) else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не существует"])
                completion(.failure(error))
                return
            }
            let data = try Data(contentsOf: sourceURL)
            guard let item = coder.decodeItem(from: data) else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать элемент"])
                completion(.failure(error))
                return
            }
            
            var newItemForSave = item
            newItemForSave.uuid = UUID().uuidString
            newItemForSave.creationDate = Date()
            
            let name = distinationURL.deletingPathExtension().lastPathComponent
            let url = distinationURL.deletingPathExtension().deletingLastPathComponent()

            saveItem(save: newItemForSave, at: url, name: name) { result in
                switch result {
                case .success():
                    completion(.success(()))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }

        } catch {
            print(error)
            completion(.failure(error)) // Обработка других ошибок
        }
    }
    
    
//    func saveCopiedFileAsDublicate(sourceURL: URL, distinationURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
//        do {
//            guard FileManager.default.fileExists(atPath: sourceURL.path) else {
//                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Файл не существует"])
//                completion(.failure(error))
//                return
//            }
//            let data = try Data(contentsOf: sourceURL)
//            if let item = coder.decodeItem(from: data) {
//
//                var newItemForSave = item
//                newItemForSave.uuid = UUID().uuidString
//                newItemForSave.creationDate = Date()
//                let newItemData = try JSONEncoder().encode(newItemForSave)
//
//                try newItemData.write(to: distinationURL)
//                completion(.success(())) // Успешное завершение операции
//            } else {
//                // Обработка случая, когда не удалось декодировать элемент из данных
//                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать элемент"])
//                completion(.failure(error))
//            }
//        } catch {
//            print(error)
//            completion(.failure(error)) // Обработка других ошибок
//        }
//    }
    
    func saveCopiedFolderAsDublicate(from sourceURL: URL, to destinationURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let fileManager = FileManager.default
        
        do {
            // Получаем список файлов и папок в исходной папке
            let contents = try fileManager.contentsOfDirectory(at: sourceURL, includingPropertiesForKeys: nil)
            
            // Создаем целевую папку, если она не существует
            try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            
            // Копируем каждый файл и папку из исходной папки в целевую папку
            for itemURL in contents {
                let destinationItemURL = destinationURL.appendingPathComponent(itemURL.lastPathComponent)
                
                // Рекурсивно копируем папки
                if itemURL.hasDirectoryPath {
                    saveCopiedFolderAsDublicate(from: itemURL, to: destinationItemURL) { result in
                        switch result {
                        case .success:
                            break // Продолжаем копирование
                        case .failure(let error):
                            completion(.failure(error))
                            return
                        }
                    }
                } else {
                    // Копируем файлы, используя функцию сохранения дубликата
                    saveCopiedFileAsDublicate(sourceURL: itemURL, distinationURL: destinationItemURL) { result in
                        switch result {
                        case .success:
                            break // Продолжаем копирование
                        case .failure(let error):
                            completion(.failure(error))
                            return
                        }
                    }
                }
            }
            // Завершаем успешно после копирования всех файлов и папок
            completion(.success(()))
        } catch {
            // Если произошла ошибка, передаем ее в completion
            completion(.failure(error))
        }
    }
}

// MARK:  - Root folders
extension FileManagerNEW {
    func createRootFolder(rootFolder: RootFolders, completion: ((Error?) -> Void)? = nil) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsURL.appendingPathComponent(rootFolder.rawValue)
        
        // Проверяем, существует ли директория
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                print("// Успешное завершение createRootFolder: \(rootFolder)")
                print(folderURL)
                completion?(nil) // Успешное завершение операции
            } catch {
                print("// Ошибка при создании createRootFolder: \(rootFolder)")
                completion?(error) // Обработка ошибки
            }
        } else {
            print("Директория уже существует: \(folderURL)")
            completion?(nil) // Успешное завершение операции, директория уже существует
        }
    }
    
    func getPathRootFolder(rootFolder: RootFolders, completion: ((URL) -> Void)) {
        if let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let rootFolder = rootFolder.rawValue
            let path = documentsDirectory.appendingPathComponent(rootFolder)
            
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: path.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    completion(path)
                } else {
                    print("По указанному URL существует файл, а не папка")
                }
            } else {
                print("Папка по указанному URL не существует")
            }
        }
    }
}

// MARK: - Get size, date
extension FileManagerNEW {
    
    func getDateModificated(url: URL) -> Date? {
        guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let modificationDate = fileAttributes[.modificationDate] as? Date
        else {
            print("Error getting modification date")
            return nil
        }
        return modificationDate
    }
    
    func getFileSize(url: URL) -> String? {
        guard let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64
        else { return nil }
        return ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
    }
    
    func getDirectorySize(at url: URL) -> UInt64? {
        var totalSize: UInt64 = 0
        
        guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []) else {
            return nil // Возвращаем nil, если не удалось получить содержимое директории
        }
        
        for itemURL in contents {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: itemURL.path)
                let fileType = attributes[.type] as? FileAttributeType
                
                if fileType == .typeRegular {
                    if let fileSize = attributes[.size] as? UInt64 {
                        totalSize += fileSize
                    }
                } else if fileType == .typeDirectory {
                    // Если это папка, рекурсивно вызываем функцию для подсчета размера ее содержимого
                    if let directorySize = getDirectorySize(at: itemURL) {
                        totalSize += directorySize
                    }
                }
            } catch {
                print("Error getting attributes for item at path: \(itemURL.path), error: \(error)")
            }
        }
        return totalSize
    }
    
    func formatFileSize(_ fileSize: UInt64) -> String {
        // Конвертируем размер в мегабайты
        let megabytes = Double(fileSize) / (1024 * 1024)
        
        // Форматируем размер с одним знаком после запятой
        let formattedSize = String(format: "%.1f MB", megabytes)
        
        // Если размер меньше 1 МБ, заменяем его на "Less than 1 MB"
        if megabytes < 0.1 {
            return "Less than 0.1 MB"
        }
        
        return formattedSize
    }
    
    func countFilesInside(at url: URL) -> Int {
        guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []) else {
            return  0 // Возвращаемся, если не удалось получить содержимое директории
        }
        return contents.count
    }
}
