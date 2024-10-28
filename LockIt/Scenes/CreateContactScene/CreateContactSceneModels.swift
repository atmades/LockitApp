import UIKit

enum CreateContactScene {
    enum Error {
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
    enum ContactData {
        struct Response {
            let image: Data?
        }
        struct ViewModel {
            let image: Data?
        }
    }
}
