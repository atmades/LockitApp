import UIKit
import CoreTelephony

protocol ContactScreenBusinessLogic {
    func getNotificationIdentifier() -> String
    func loadContent()
    func copyContactDataToClipboard(contactInfo: String?)
    func call()
    func sendEmail()
    func shareContact()
    
    func updateName(name: String?)
}

protocol ContactScreenDataStore {
    var path: URL { get set }
    var currentSystemName: String { get set }
    var notificationIdentifier: String { get set }
}

class ContactScreenInteractor: ContactScreenBusinessLogic, ContactScreenDataStore {

    var presenter: ContactScreenPresentationLogic?
    var worker: ContactScreenWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var currentSystemName = ""
    var notificationIdentifier: String = UUID().uuidString
    
    var fullName = ""
    var phone = ""
    var email: String?
    var imageData: Data?
    
    private let converterName = ContactNameConverter()
    private let fileManager = FileManagerNEW()
    private let contactsManager = ContactsManager()
    
    func getNotificationIdentifier() -> String {
        return notificationIdentifier
    }
    
    func updateName(name: String?) {
        guard let systemName = name else { return }
        fullName = converterName.convertSystemToPresent(inputName: systemName)
        switch fileManager.getFile(name: systemName, url: path) {
        case .success(let item):

            if let contactItem = item.item as? ContactForSave {
                phone = contactItem.number
                email = contactItem.email
                imageData = contactItem.image
                presenter?.presentContactData(response: ContactScreen.ContactData.Response(avatar: imageData, name: fullName, phone: phone, mail: email))
            }
        case .failure(_):
            print("dsdsd")
        }
    }
    
    func loadContent() {
        fullName = converterName.convertSystemToPresent(inputName: currentSystemName)
        switch fileManager.getFile(name: currentSystemName, url: path) {
        case .success(let item):

            if let contactItem = item.item as? ContactForSave {
                phone = contactItem.number
                email = contactItem.email
                imageData = contactItem.image
                presenter?.presentContactData(response: ContactScreen.ContactData.Response(avatar: imageData, name: fullName, phone: phone, mail: email))
            }
        case .failure(_):
            print("dsdsd")
        }
    }
    
    func copyContactDataToClipboard(contactInfo: String?) {
        guard let contactInfo = contactInfo else { return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = contactInfo
        print(contactInfo)
        self.presenter?.presentResultOfSavingToPhoneBook(response: ContactScreen.Saved.Response(title: "Успешно", message: "Скопировано в буфер обмена"))
    }
    
    func shareContact() {
        do {
            let contact = ContactPhoneBook(name: fullName, number: phone,email: email, image: imageData)
            let vCardData = try contactsManager.prepareContactForSharing(contact: contact)
            presenter?.presentSharing(response: ContactScreen.ShareData.Response(vCard: vCardData))
        } catch {
            print("Ошибка подготовки контакта для отправки: \(error.localizedDescription)")
        }
    }
    
    func saveToPhoneBook() {
        let contact = ContactPhoneBook(name: fullName, number: phone,email: email, image: imageData)
        contactsManager.saveContactToPhoneBook(contact: contact) { success, error in
            if success {
                if let model = AlertsViewModel.successfulSaveContact.model {
                    self.presenter?.presentResultOfSavingToPhoneBook(response: ContactScreen.Saved.Response(title: model.title, message: model.message))
                }

            } else if let error = error {
                print("Ошибка сохранения контакта: \(error.localizedDescription)")
                self.presenter?.presentResultOfSavingToPhoneBook(response: ContactScreen.Saved.Response(title: "Ошибка сохранения контакта", message: error.localizedDescription))
            }
        }
    }

    func call() {
        if let phoneCallURL = URL(string: "tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                print("Не доступно на данном устройстве.")
            }
        } else {
            print("URL не создался")
        }
    }

    func sendEmail() {
        guard let email = email else { return }
        if let emailURL = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            } else {
                print("Почтовый клиент не доступен на данном устройстве.")
            }
        } else {
            print("URL не создался")
        }
    }
}



