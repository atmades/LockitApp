import Contacts
import UIKit

protocol ContactSharingInteractorProtocol {
    func prepareContactForSharing(contact: ContactPhoneBook) throws -> Data
}

class ContactsManager {
    
    private let contactStore = CNContactStore()
    
    // Экспорт контакта в формате vCard и отображение UIActivityViewController
    func shareContact(contact: ContactPhoneBook, from viewController: UIViewController) {
        // Создание CNContact из ContactForSave
        let cnContact = CNMutableContact()
        cnContact.givenName = contact.name // Используйте разбиение, если нужно имя и фамилию
        cnContact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberMain,
            value: CNPhoneNumber(stringValue: contact.number)
        )]
        if let email = contact.email {
            cnContact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email as NSString)]
        }
        if let imageData = contact.image {
            cnContact.imageData = imageData // Используем imageData вместо thumbnailImageData
        }
        
        // Экспорт в vCard
        do {
            let vCardData = try CNContactVCardSerialization.data(with: [cnContact])
            let activityViewController = UIActivityViewController(activityItems: [vCardData], applicationActivities: nil)
            viewController.present(activityViewController, animated: true, completion: nil)
        } catch {
            print("Ошибка экспорта контакта: \(error.localizedDescription)")
        }
    }
    
    func prepareContactForSharing(contact: ContactPhoneBook) throws -> Data {
        let cnContact = CNMutableContact()
        cnContact.givenName = contact.name
        cnContact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberMain,
            value: CNPhoneNumber(stringValue: contact.number)
        )]
        
        if let email = contact.email {
            cnContact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email as NSString)]
        }
        
        if let imageData = contact.image {
            cnContact.imageData = imageData
        }
        
        // Экспортируем контакт в vCard
        let vCardData = try CNContactVCardSerialization.data(with: [cnContact])
        return vCardData
    }
    
    // Сохранение контакта в телефонную книжку
    func saveContactToPhoneBook(contact: ContactPhoneBook, completion: @escaping (Bool, Error?) -> Void) {
        let cnContact = CNMutableContact()
        cnContact.givenName = contact.name
        cnContact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberMain,
            value: CNPhoneNumber(stringValue: contact.number)
        )]
        if let email = contact.email {
            cnContact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email as NSString)]
        }
        if let imageData = contact.image {
            cnContact.imageData = imageData // Используем imageData вместо thumbnailImageData
        }
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(cnContact, toContainerWithIdentifier: nil)
        
        do {
            try CNContactStore().execute(saveRequest)
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
}
