import UIKit

enum ContactsList {
    enum Error {
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
    enum LoadContent {
        struct Request {}
        struct Response {
            let items: [ItemForPresent]
        }
        struct ViewModel {
            let items: [ItemForPresent]
        }
    }
    
    enum Folder {
        struct Response {
            let folderName: String
            let counterVC: Int
        }
        struct ViewModel {
            var folderName: String
            let counterVC: Int
        }
    }
    enum Menu {
        struct Response {
            var pasteIsAviable: Bool
        }
        struct ViewModel {
            var pasteIsAviable: Bool
        }
    }
    enum SelectContactForEdit {
        struct Request {
            let item: ItemForPresent
        }
    }
    enum SelectFolderForRename {
        struct Request {
            let item: ItemForPresent
        }
    }
    enum SelectFolderForRoute {
        struct Request {
            let folderNameForRoute: String
        }
    }
}
