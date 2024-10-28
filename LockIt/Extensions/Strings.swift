import Foundation

extension String {
    func onlyDigits() -> String {
        let digit = "0123456789"
        return filter { digit.contains($0) }
    }
    
    func cleanName() -> String {
        var cleanedString = self
        if cleanedString.contains("~") {
            cleanedString = cleanedString.replacingOccurrences(of: "~", with: "")
        }
        if cleanedString.contains("_") {
            cleanedString = cleanedString.replacingOccurrences(of: "_", with: "")
        }
        return cleanedString
    }
}
