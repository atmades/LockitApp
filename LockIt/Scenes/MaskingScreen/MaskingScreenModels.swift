import Foundation

enum MaskingScreen {
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
}
