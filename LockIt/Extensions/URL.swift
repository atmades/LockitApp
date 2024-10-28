import UIKit

extension URL {
    static func openAppstore(id: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(id)?action=write-review") {
            url.open()
        }
    }
    func open() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(self)
        } else {
            UIApplication.shared.open(self, options: [:], completionHandler: nil)
        }
    }
    
    var isValidURL: Bool {
        return self.scheme == "http" || self.scheme == "https"
    }
}
