import UIKit

enum DownloadFileScreen {
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
            let pdfData: Data
            let pdfName: String
        }
        struct ViewModel {
            let pdfData: Data
            let pdfName: String
        }
    }
}
