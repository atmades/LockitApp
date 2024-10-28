import UIKit

protocol NotesListPresentationLogic {
    func presentContent(response: NotesList.LoadContent.Response)
    func presentFolderName(response: NotesList.Folder.Response)
    func presentUpdateMenu(response: NotesList.Menu.Response)
}

class NotesListPresenter: NotesListPresentationLogic {
    weak var viewController: NotesListDisplayLogic?
    private var sortManager: SortManagerProtocol
    
    init(sortManager: SortManagerProtocol = SortManager()) {
        self.sortManager = sortManager
    }
    
    func presentContent(response: NotesList.LoadContent.Response) {
        let sorted = sortManager.sortItems(items: response.items, sortBy: response.sort)
        viewController?.displayItems(viewModel: NotesList.LoadContent.ViewModel(items: sorted))
    }
    
    func presentFolderName(response: NotesList.Folder.Response) {
        viewController?.displayTitle(viewModel: NotesList.Folder.ViewModel(folderName: response.folderName, counterVC: response.counterVC))
    }
    
    func presentUpdateMenu(response: NotesList.Menu.Response) {
        viewController?.updateMenu(viewModel: NotesList.Menu.ViewModel(pasteIsAviable: response.pasteIsAviable))
    }
}
