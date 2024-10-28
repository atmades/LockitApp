import UIKit

class WebClipboardManager {
    func getURLFromClipboard() -> String? {
        if let clipboardString = UIPasteboard.general.string {
            if let url = URL(string: clipboardString), url.isValidURL {
                return clipboardString
            } else {
                print("Некорректная ссылка")
                return nil
            }
        } else {
            print("Буфер обмена пуст")
            return nil
        }
    }
}
