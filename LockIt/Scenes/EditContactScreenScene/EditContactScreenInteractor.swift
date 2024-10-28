import UIKit

protocol EditContactScreenBusinessLogic {
    func getCurrentData()
    func updateAvatar(imageData: Data?)
    func updateСontact(name: String, lastName: String?, phone: String, imageData: Data?, email: String?, completion: @escaping() -> Void)
}
protocol EditContactScreenDataStore {
    var path: URL { get set }
    var currentSystemName: String { get set }
    var updatedSystemNameForCallBack: String? { get set }
    var notificationIdentifier: String { get set }
}

class EditContactScreenInteractor: EditContactScreenBusinessLogic, EditContactScreenDataStore {
    var presenter: EditContactScreenPresentationLogic?
    var worker: EditContactScreenWorker?
    
    var path: URL = URL(fileURLWithPath: "")
    var currentSystemName = ""
    var updatedSystemNameForCallBack: String? = ""
    var notificationIdentifier: String = UUID().uuidString
    
    private let fileManager = FileManagerNEW()
    private let converterName = ContactNameConverter()
    
    var response: ContactForSave?
    
    func getCurrentData() {
        switch fileManager.getFile(name: currentSystemName, url: path) {
        case .success(let item):
            if let contactItem = item.item as? ContactForSave {
                response = contactItem
                
                let fullName = converterName.convertSystemToInput(inputName: currentSystemName)
                let name = fullName.name
                let lastName = fullName.lastName
                let phone = contactItem.number
                let email = contactItem.email
                let image = contactItem.image
                
                presenter?.presentCurrentData(response:EditContactScreen.CurrentData.Response(
                    name: name,
                    lastName: lastName,
                    phone: phone,
                    email: email,
                    avatarImage: image))
            }
        case .failure(let error):
            print("Ошибка при получении данных: \(error.localizedDescription)")
            self.presenter?.presentErrorNotSaved(response: FileManagerError.anyError.localizedDescription)
        }
    }
    
    
    func updateAvatar(imageData: Data?) {
        presenter?.updateAvatar(response: EditContactScreen.NewAvatar.Response(image: imageData))
    }
    
    func updateСontact(name: String, lastName: String?, phone: String, imageData: Data?, email: String?, completion: @escaping() -> Void) {
        
        guard var contactForSave = response else { return }
        
        contactForSave.number = phone
        contactForSave.email = email
        contactForSave.image = imageData
        
        let newSystemFullName = converterName.convertInputToSave(name: name, lastName: lastName)
        updatedSystemNameForCallBack = newSystemFullName
        
        print("newSystemFullName \(newSystemFullName)")
        print("currentSystemFullName \(currentSystemName)")
        
        // если имя было изменено, проверка на доступность
        if self.currentSystemName != newSystemFullName {
            let isAvailable = self.fileManager.isAvailableName(name: newSystemFullName, url: self.path)
            
            if isAvailable == false {
                self.presenter?.presentErrorNotSaved(response: FileManagerError.fileAlreadyExists.localizedDescription)
                return
            }
        }
            // после проверки в любом случае переименование и сохранение
        self.fileManager.renameFile(url: self.path, currentName: self.currentSystemName, newName: newSystemFullName) { result in
            switch result {
            case .success():
                self.fileManager.saveItem(save: contactForSave, at: self.path, name: newSystemFullName) { result in
                    switch result {
                    case .success():
                        completion()
                    case .failure(let error):
                        print("Error \(error.localizedDescription)")
                        self.presenter?.presentErrorNotSaved(response: error.localizedDescription)
                    }
                }
                completion()
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                self.presenter?.presentErrorNotSaved(response: error.localizedDescription)
            }
        }
    }
}
