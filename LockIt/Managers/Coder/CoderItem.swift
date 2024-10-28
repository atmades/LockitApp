import Foundation

class CoderItem {
    static var shared = CoderItem()
}

// MARK: - DecoderItem

// Структура-обертка для декодирования элемента
struct ItemWrapper: Codable {
    let type: String
    let data: Data
}

extension CoderItem: DecoderItem {
    
    func decodeItem(from data: Data) -> ItemForSave? {
        do {
               let decoder = JSONDecoder()
               let itemWrapper = try decoder.decode(ItemWrapper.self, from: data)
               
               switch itemWrapper.type {
                   
               case ItemForSaveMediaType.image.rawValue:
                   return try decoder.decode(ImageForSave.self, from: itemWrapper.data)
               
               case ItemForSaveMediaType.pdf.rawValue:
                   return try decoder.decode(PdfForSave.self, from: itemWrapper.data)
               
               case ItemForSaveMediaType.note.rawValue:
                   return try decoder.decode(NoteForSave.self, from: itemWrapper.data)
              
               case ItemForSaveMediaType.contact.rawValue:
                   return try decoder.decode(ContactForSave.self, from: itemWrapper.data)
               
               default:
                   // Обработка неизвестного типа
                   return nil
               }
           } catch {
               print("Ошибка при декодировании данных: \(error)")
               return nil
           }
    }
    
//    func decodeItemOld(from data: Data) -> ItemForSave? {
//        if let note = try? JSONDecoder().decode(NoteForSave.self, from: data) {
//            return note
//        } else if let imageItem = try? JSONDecoder().decode(ImageForSave.self, from: data) {
//            return imageItem
//        } else if let contact = try? JSONDecoder().decode(ContactForSave.self, from: data) {
//            return contact
//        } 
//        return nil
//    }
    

}

// MARK: - EncoderItem
extension CoderItem: EncoderItem {
    func encodeStruct<T: Codable>(_ value: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Если нужно, чтобы данные были читаемыми
            let jsonData = try encoder.encode(value)
            return jsonData
        } catch {
            print("Ошибка при кодировании структуры: \(error.localizedDescription)")
            return nil
        }
    }
}

