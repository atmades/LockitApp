import UIKit

@objc protocol MainRoutingLogic {
    func getFilesVC() -> UIViewController
    func getContactsVC() -> UIViewController
    func getNotesVC() -> UIViewController
    func getSettingsVC() -> UIViewController 
    
    func routeToPDFScreen(pdfData: Data, pdfName: String)
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    func getFilesVC() -> UIViewController {
        let vc = FilesListViewController()
        var destinationDS = vc.router?.dataStore
        passFilesList(destination: &destinationDS)
        return vc
    }
    
    func getContactsVC() -> UIViewController {
        let vc = ContactsListViewController()
        var destinationDS = vc.router?.dataStore
        passContactsList(destination: &destinationDS)
        return vc
    }
    
    func getNotesVC() -> UIViewController {
        let vc = NotesListViewController()
        var destinationDS = vc.router?.dataStore
        passNotesList(destination: &destinationDS)
        return vc
    }
    
    func getSettingsVC() -> UIViewController {
        let vc = SettingsListViewController()
        var destinationDS = vc.router?.dataStore
        passSettingsList(destination: &destinationDS)
        return vc
    }
    
    // Новый метод для перехода на экран просмотра PDF
    func routeToPDFScreen(pdfData: Data, pdfName: String) {
        let pdfViewController = DownloadFileScreenViewController()
        pdfViewController.pdfData = pdfData
        pdfViewController.pdfName = pdfName
        viewController?.present(pdfViewController, animated: true, completion: nil)
    }
}

extension MainRouter {
    func passFilesList(destination: inout FilesListDataStore?) {
        destination?.path = dataStore?.filesRootPath ?? URL(fileURLWithPath: "")
        destination?.folderName = dataStore?.filesRootName ?? ""
        
        guard let counter = destination?.countVC else { return }
        destination?.countVC = counter + 1
    }
    
    func passContactsList(destination: inout ContactsListDataStore?) {
        destination?.path = dataStore?.contactsRootPath ?? URL(fileURLWithPath: "")
        destination?.folderName = dataStore?.contactsRootName ?? ""
        
        guard let counter = destination?.countVC else { return }
        destination?.countVC = counter + 1
    }
    
    func passNotesList(destination: inout NotesListDataStore?) {
        destination?.path = dataStore?.notesRootPath ?? URL(fileURLWithPath: "")
        destination?.folderName = dataStore?.notesRootName ?? ""
        
        guard let counter = destination?.countVC else { return }
        destination?.countVC = counter + 1
    }
    
    func passSettingsList(destination: inout SettingsListDataStore?) {
        destination?.folderName = dataStore?.settingsRootName ?? ""
        guard let counter = destination?.countVC else { return }
        destination?.countVC = counter + 1
    }
}
