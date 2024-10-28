import UIKit

enum Rename {
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
        }
        struct ViewModel {
            let name: String?
        }
    }
}
