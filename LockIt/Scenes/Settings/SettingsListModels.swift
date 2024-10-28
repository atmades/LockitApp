
enum SettingsList {
    enum Error {
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
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
