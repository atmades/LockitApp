import UIKit

enum NotesList {
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
            let sort: SortType
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
    enum SelectItem {
        struct Request {
            let item: ItemForPresent
        }
    }
    enum SelectFolderForRoute {
        struct Request {
            let folderNameForRoute: String
        }
    }
    enum SelectSort {
        struct Request {
            var selectSort: SortType
        }
    }
}
