import Foundation

final class ClipboardManager {
    static let shared = ClipboardManager()
    private init() {}
    
    var copiedURL: URL?
    var copiedType: Type?
    var copiedRootFolder: RootFolders?
    
    // MARK: - save
    func saveForFileList(url: URL, type: Type, root: RootFolders?) {
        copiedURL = url
        copiedType = type
        copiedRootFolder = root
    }
    
    // MARK: - update
    func updateFileListFolderURL(oldFolderName: String, newFolderName: String, root: RootFolders) {
        guard let savedPath = copiedURL,
              let type = copiedType,
              type == .folder,
              let rootFolder = copiedRootFolder,
              rootFolder == root
        else { return }
        
        // Разделяем сохраненный путь на компоненты
        var pathComponents = savedPath.path.components(separatedBy: "/")
        
        // Проверяем, существует ли папка с oldFolderName в пути
        // Если папка не найдена, то выходим
        guard let index = pathComponents.firstIndex(of: oldFolderName) else { return }
        
        // Обновляем имя папки с newFolderName
        pathComponents[index] = newFolderName
        
        // Собираем обновленный путь из компонентов
        let updatedPath = pathComponents.joined(separator: "/")
        let newURL = URL(string: updatedPath)
        copiedURL = newURL
    }
    
    func updateFolderURL(oldFolderName: String, newFolderName: String, root: RootFolders?) {
        guard let savedPath = copiedURL,
              let type = copiedType,
              type == .folder,
              let rootFolder = copiedRootFolder,
              let root = root,
              rootFolder == root
        else { return }
        
        // Разделяем сохраненный путь на компоненты
        var pathComponents = savedPath.path.components(separatedBy: "/")
        
        // Проверяем, существует ли папка с oldFolderName в пути
        // Если папка не найдена, то выходим
        guard let index = pathComponents.firstIndex(of: oldFolderName) else { return }
        
        // Обновляем имя папки с newFolderName
        pathComponents[index] = newFolderName
        
        // Собираем обновленный путь из компонентов
        let updatedPath = pathComponents.joined(separator: "/")
        let newURL = URL(string: updatedPath)
        copiedURL = newURL
    }
    
    func updateFileListFileURL(urlToFile: URL, newName: String, root: RootFolders?) {
        guard let savedURL = copiedURL,
              let type = copiedType,
              type == .file,
              let rootFolder = copiedRootFolder,
              let root = root,
              rootFolder == root
        else { return }
        let urlToSavedFile = savedURL.deletingLastPathComponent()
        if urlToSavedFile == urlToFile {
            let newURL = urlToSavedFile.appending(component: newName + ".json")
            copiedURL = newURL
        }
    }
    
    // MARK: - make nil
    func checkAfterDeleteFile(urlToFile: URL, name: String) {
        guard let savedURLtoFile = copiedURL,
              let type = copiedType,
              type == .file
        else { return }
        if savedURLtoFile == urlToFile.appending(component: name + ".json") {
            copiedURL = nil
            copiedType = nil
            copiedRootFolder = nil
        }
    }
    
    func checkAfterDeleteFolder(urlToFolder: URL, name: String) {
        guard let savedURLtoFolder = copiedURL,
              let type = copiedType,
              type == .folder
        else { return }
        
        var urlFull = urlToFolder.appendingPathComponent(name + "/")
        urlFull.appendPathComponent("")
        
        if savedURLtoFolder == urlFull {
            copiedURL = nil
            copiedType = nil
            copiedRootFolder = nil
        }
    }
}
