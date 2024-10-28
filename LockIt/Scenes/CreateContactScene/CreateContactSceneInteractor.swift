import UIKit

protocol CreateContactSceneBusinessLogic {
    func showAvatar(imageData: Data?)
    func saveСontact(name: String, lastName: String?, phone: String, imageData: Data?, email: String?, completion: @escaping() -> Void)
}

protocol CreateContactSceneDataStore {
    var path: URL { get set }
    var notificationIdentifier: String { get set }
}

class CreateContactSceneInteractor: CreateContactSceneBusinessLogic, CreateContactSceneDataStore {
    var presenter: CreateContactScenePresentationLogic?
    var worker: CreateContactSceneWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var notificationIdentifier: String = ""
    private let fileManager = FileManagerNEW()
    private let converterName = ContactNameConverter()
    
    func showAvatar(imageData: Data?) {
        presenter?.presentAvatar(response: CreateContactScene.ContactData.Response(image: imageData))
    }
    
    func saveСontact(name: String, lastName: String?, phone: String, imageData: Data?, email: String?, completion: @escaping() -> Void) {
       
        let fullName = converterName.convertInputToSave(name: name, lastName: lastName)
        let uuid = UUID().uuidString
        let contactForSave = ContactForSave(uuid: uuid, creationDate: Date(), image: imageData, number: phone, email: email)
        
        
        let isAvailableName = fileManager.isAvailableName(name: fullName, url: path)
        print("isAvailableName is")
        print(isAvailableName)
        
        print(fullName)
        
        if isAvailableName {
            fileManager.saveItem(save: contactForSave, at: path, name: fullName) { result in
                switch result {
                case .success():
                    print("Saved Contact")
                    completion()
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        } else {
            print("Ошибка имя недоступно :")
            self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
        }
    }
    
}
