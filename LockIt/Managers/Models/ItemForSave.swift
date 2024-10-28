import UIKit
import QuickLook

protocol ItemForSave: Codable {
    var uuid: String { get set }
    var creationDate: Date { get set }
    static var typeKey: String { get }
}

enum ItemForSaveMediaType: String {
    case image = "image"
    case pdf = "pdf"
    case note = "note"
    case contact = "contact"
}

struct ImageForSave: ItemForSave {
    var uuid: String
    var creationDate: Date
    static var typeKey: String { return ItemForSaveMediaType.image.rawValue }
    var imageData: Data
}

struct PdfForSave: ItemForSave {
    var uuid: String
    var creationDate: Date
    static var typeKey: String { return ItemForSaveMediaType.pdf.rawValue }
    var pdf: Data
}


struct NoteForSave: ItemForSave  {
    var uuid: String
    var creationDate: Date
    static var typeKey: String { return ItemForSaveMediaType.note.rawValue }
    var text: String?
}

struct ContactForSave: ItemForSave {
    var uuid: String
    var creationDate: Date
    static var typeKey: String { return ItemForSaveMediaType.contact.rawValue }
    var image: Data?
    var number: String
    var email: String?
}


//protocol ItemForSave: Codable {
//    var uuid: String { get set }
//    var creationDate: Date { get set }
//}
//
//
//struct ImageForSave: ItemForSave {
//    var uuid: String
//    var creationDate: Date
//    var image: Data
//}
//
//struct NoteForSave: ItemForSave {
//    var uuid: String
//    var creationDate: Date
//    var text: String?
//}
//
//struct ContactForSave: ItemForSave {
//    var uuid: String
//    var creationDate: Date
//    var image: Data?
//    var number: String
//    var email: String?
//}

