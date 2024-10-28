import UIKit

protocol FilesListPresentationLogic {
    func presentError(response: FilesList.Error.Response)
    func presentContent(response: FilesList.LoadContent.Response)
    func presentFolderName(response: FilesList.Folder.Response)
    func presentUpdateMenu(response: FilesList.Menu.Response)
    func presentAlertClipboard(response: FilesList.ClipBoardForPDF.Response)
    func presentDownloaded(response: FilesList.Downloaded.Response)
}

class FilesListPresenter: FilesListPresentationLogic {
    weak var viewController: FilesListDisplayLogic?
    
    private var sortManager: SortManagerProtocol
    
    init(sortManager: SortManagerProtocol = SortManager()) {
        self.sortManager = sortManager
    }
    
    func presentError(response: FilesList.Error.Response) {
        viewController?.displayError(viewModel: FilesList.Error.ViewModel(message: response.message))
    }
    
    func presentContent(response: FilesList.LoadContent.Response) {
        let sorted = sortManager.sortItems(items: response.items, sortBy: response.sort)
        viewController?.displayItems(viewModel: FilesList.LoadContent.ViewModel(items: sorted))
    }
    
    func presentFolderName(response: FilesList.Folder.Response) {
        viewController?.displayTitle(viewModel: FilesList.Folder.ViewModel(folderName: response.folderName, counterVC: response.counterVC))
    }
    
    func presentUpdateMenu(response: FilesList.Menu.Response) {
        viewController?.updateMenu(viewModel: FilesList.Menu.ViewModel(pasteIsAviable: response.pasteIsAviable))
    }
    
    func presentAlertClipboard(response: FilesList.ClipBoardForPDF.Response) {
        viewController?.displayAlertForDownload(viewModel: FilesList.ClipBoardForPDF.ViewModel(urlString: response.urlString))
    }
    
    func presentDownloaded(response: FilesList.Downloaded.Response) {
        viewController?.displayDownloaded(viewModel: FilesList.Downloaded.ViewModel(pdfData: response.pdfData, pdfFileName: response.pdfFileName))
    }
}
