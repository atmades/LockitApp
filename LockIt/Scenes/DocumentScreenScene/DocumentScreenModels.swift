import UIKit

enum DocumentScreen {
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
            let pdfData: Data?
            let pdfName: String
        }
        struct ViewModel {
            let pdfData: Data?
            let pdfName: String
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
