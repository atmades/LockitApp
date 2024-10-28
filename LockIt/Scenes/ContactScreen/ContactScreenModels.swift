import UIKit

enum ContactScreen {
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
            let avatar: Data?
            let name: String
            let phone: String
            let mail: String?
        }
        struct ViewModel {
            let avatar: Data?
            let name: String
            let phone: String
            let mail: String?
        }
    }
    enum ShareData {
        struct Response {
            let vCard: Data
        }
        struct ViewModel {
            let vCard: Data
        }
    }
    enum Saved {
        struct Response {
            let title: String?
            let message: String?
        }
        struct ViewModel {
            let title: String?
            let message: String?
        }
    }
}
