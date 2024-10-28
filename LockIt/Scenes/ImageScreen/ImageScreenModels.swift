import UIKit

enum ImageScreen {
    enum Error {
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
    enum LoadContent {
        struct Response {
            let itemImages: [ItemForPresent]
            let index: Int
        }
        struct ViewModel {
            let itemImages: [ItemForPresent]
            let index: Int
        }
    }
    enum Share {
        struct Response {
            let temporaryURL: URL
        }
        struct ViewModel {
            let temporaryURL: URL
        }
    }
}
