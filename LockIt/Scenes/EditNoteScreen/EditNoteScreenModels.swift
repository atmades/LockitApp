import UIKit

enum EditNoteScreen {
    enum Error {
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
    enum CurrentData {
        struct Response {
            let name: String?
            let textNote: String?
        }
        struct ViewModel {
            let name: String?
            let textNote: String?
        }
    }
}
