import Foundation

enum CreatePdfFromPhotoScene {
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
        }
        struct ViewModel {
            let name: String
        }
    }
    enum CreatedPDF {
        struct Response {
            let pdfData: Data?
        }
        struct ViewModel {
            let pdfData: Data?
        }
    }
}
