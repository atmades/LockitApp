import UIKit

@objc protocol FilesListRoutingLogic {
    func routeToCreateFolderScreen()
    func routeToDownloadFileScreen()
    func routeToRenameScreen()
    func routeToImageScreen()
    func routeToDocumentScreen()
    func routeToSubList()
    func routeToCreatePdfFromPhotoScreen()
    func routeToBack()
}

protocol FilesListDataPassing {
    var dataStore: FilesListDataStore? { get }
}

class FilesListRouter: NSObject, FilesListRoutingLogic, FilesListDataPassing {
    weak var viewController: FilesListViewController?
    var dataStore: FilesListDataStore?
    
    func routeToImageScreen() {
        let vc = ImageScreenViewController()
        var destinationDS = vc.router?.dataStore
        passImageScreenVC(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToDocumentScreen() {
        let vc = DocumentScreenViewController()
        var destinationDS = vc.router?.dataStore
        passDocumentScreenVC(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToCreateFolderScreen() {
        let vc = CreateFolderViewController()
        var destinationDS = vc.router?.dataStore
        passCreateFolderScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToRenameScreen() {
        let vc = RenameViewController()
        var destinationDS = vc.router?.dataStore
        passRenameScreen(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToDownloadFileScreen() {
        let vc = DownloadFileScreenViewController()
        var destinationDS = vc.router?.dataStore
        passDownloadedScreenVC(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToSubList() {
        guard let viewControllerWeakSelf = viewController else { return }
        let vc = FilesListViewController()
        var destinationDS = vc.router?.dataStore
        passFilesList(destination: &destinationDS)
        passCounterVC(destination: &destinationDS)
        viewControllerWeakSelf.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToCreatePdfFromPhotoScreen() {
        let vc = CreatePdfFromPhotoSceneViewController()
        var destinationDS = vc.router?.dataStore
        passCreatePdfFromPhotoSceneVC(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

private extension FilesListRouter {
    func passCreateFolderScreen(destination: inout CreateFolderDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passRenameScreen(destination: inout RenameDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.itemPresent = dataStore?.selectedItem
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
        destination?.root = dataStore?.root 
    }
    
    func passFilesList(destination: inout FilesListDataStore?) {
        destination?.path = dataStore?.folderURLForRoute ?? URL(fileURLWithPath: "")
        destination?.folderName = dataStore?.folderNameForRoute ?? ""
    }
    
    func passCounterVC(destination: inout FilesListDataStore?) {
        guard let counter = dataStore?.countVC else { return }
        destination?.countVC = counter + 1
    }
    
    func passImageScreenVC(destination: inout ImageScreenDataStore?) {
        destination?.items = dataStore?.imageItems ?? []
        destination?.index = dataStore?.indexSelectedImage ?? 0
    }
    
    func passDocumentScreenVC(destination: inout DocumentScreenDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.currentSystemName = dataStore?.selectedItem?.name ?? ""
    }
    
    func passDownloadedScreenVC(destination: inout DownloadFileScreenDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.pdfName = dataStore?.downloadedName ?? ""
        destination?.pdfData = dataStore?.downloadedData ?? Data()
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
    
    func passCreatePdfFromPhotoSceneVC(destination: inout CreatePdfFromPhotoSceneDataStore?) {
        destination?.path = dataStore?.path ?? URL(fileURLWithPath: "")
        destination?.notificationIdentifier = dataStore?.notificationIdentifier ?? ""
    }
}
