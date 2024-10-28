import UIKit

protocol MainBusinessLogic {

}

protocol MainDataStore {
    var filesRootPath: URL { get set }
    var contactsRootPath: URL { get set }
    var notesRootPath: URL { get set }
    
    var filesRootName: String { get set }
    var contactsRootName: String { get set }
    var notesRootName: String { get set }
    var settingsRootName: String { get set }
    
    var counterVC: Int { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    var presenter: MainPresentationLogic?
    var worker: MainWorker?
    
    var filesRootPath: URL = URL(fileURLWithPath: "")
    var contactsRootPath: URL = URL(fileURLWithPath: "")
    var notesRootPath: URL = URL(fileURLWithPath: "")
    
    var filesRootName = RootFolders.files.rawValue
    var contactsRootName = RootFolders.contacts.rawValue
    var notesRootName = RootFolders.notes.rawValue
    var settingsRootName = RootFolders.settings.rawValue
    
    var counterVC = 0
    
    private let fileManager = FileManagerNEW()
    
    init() {
        createRootsFolder()
        setupFilesRootPath()
        setupContactsRootPath()
        setupNotesRootPath()
    }
    
    func createRootsFolder() {
        fileManager.createRootFolder(rootFolder: .files) { _ in }
        fileManager.createRootFolder(rootFolder: .contacts) { _ in }
        fileManager.createRootFolder(rootFolder: .notes) { _ in }
    }
    
    func setupFilesRootPath() {
        fileManager.getPathRootFolder(rootFolder: .files) { path in
            filesRootPath = path
        }
    }
    
    func setupContactsRootPath() {
        fileManager.getPathRootFolder(rootFolder: .contacts) { path in
            contactsRootPath = path
        }
    }
    
    func setupNotesRootPath() {
        fileManager.getPathRootFolder(rootFolder: .notes) { path in
            notesRootPath = path
        }
    }
}


