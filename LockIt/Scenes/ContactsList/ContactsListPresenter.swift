import UIKit

protocol ContactsListPresentationLogic {
    func presentContent(response: ContactsList.LoadContent.Response)
    func presentFolderName(response: ContactsList.Folder.Response)
    func presentUpdateMenu(response: ContactsList.Menu.Response)
}

class ContactsListPresenter: ContactsListPresentationLogic {
    weak var viewController: ContactsListDisplayLogic?
    
    private var nameCache: [String: String] = [:]
    
    func presentContent(response: ContactsList.LoadContent.Response) {
        var preparedContacts = [ItemForPresent]()
        for item in response.items {
            var preparedItem = item
            if item.type == .file {
                let checkedName = checkName(inputName: item.name)
                preparedItem.name = checkedName
            }
            preparedContacts.append(preparedItem)
        }
        viewController?.displayItems(viewModel: ContactsList.LoadContent.ViewModel(items: preparedContacts))
    }
    
    private func checkName(inputName: String) -> String {
           // Проверяем, есть ли значение в кэше
           if let cachedName = nameCache[inputName] {
               return cachedName
           }
           
           var name: String = ""
           var lastName: String = ""
           
           if inputName.contains("_") {
               let separatedStrings = inputName.components(separatedBy: "_")
               name = separatedStrings[0]
               lastName = separatedStrings[1]
           } else {
               name = inputName
           }
           if name.contains("~") {
               name = name.replacingOccurrences(of: "~", with: " ")
           }
           if !lastName.isEmpty && lastName.contains("~") {
               lastName = lastName.replacingOccurrences(of: "~", with: " ")
           }
           let outputName = name + " " + lastName
           
           // Сохраняем результат в кэше
           nameCache[inputName] = outputName
           
           return outputName
       }
    
    
    func presentFolderName(response: ContactsList.Folder.Response) {
        viewController?.displayTitle(viewModel: ContactsList.Folder.ViewModel(folderName: response.folderName, counterVC: response.counterVC))
    }
    
    func presentUpdateMenu(response: ContactsList.Menu.Response) {
        viewController?.updateMenu(viewModel: ContactsList.Menu.ViewModel(pasteIsAviable: response.pasteIsAviable))
    }
}



