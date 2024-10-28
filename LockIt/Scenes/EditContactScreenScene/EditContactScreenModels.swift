import UIKit

enum EditContactScreen {
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
            let name: String
            let lastName: String?
            let phone: String
            let email: String?
            let avatarImage: Data?
        }
        struct ViewModel {
            let name: String
            let lastName: String?
            let phone: String
            let email: String?
            let avatarImage: Data?
        }
    }
    
    enum NewAvatar {
        struct Response {
            let image: Data?
        }
        struct ViewModel {
            let image: Data?
        }
    }
}
