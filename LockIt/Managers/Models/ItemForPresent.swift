import Foundation

struct ItemForPresent {
    var name: String
    var type: Type
    var path: URL
    var item: ItemForSave?
    var size: String?
    var dateModoficated: Date?
    var countFiles: Int?
}

enum Type: Codable {
case file, folder
}
