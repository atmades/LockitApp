import UIKit

protocol SettingsListBusinessLogic {
    func getTitleName()
    func openMailClient(from viewController: UIViewController)
}
protocol SettingsListDataStore {
    var countVC: Int { get set }
    var folderName: String { get set }
    var id: String { get }
}

class SettingsListInteractor: SettingsListBusinessLogic, SettingsListDataStore {
    var presenter: SettingsListPresentationLogic?
    var worker: SettingsListWorker?
    
    var countVC: Int = 0
    var folderName = ""
    var id = ""
    
    var biometryAuthManager = BiometricAuthManager()
    
    func getTitleName() {
        self.presenter?.presentFolderName(response: SettingsList.Folder.Response(folderName: folderName, counterVC: countVC))
    }
    
    func openMailClient(from viewController: UIViewController) {
        MailManager.shared.sendEmail(from: viewController) { result in
            switch result {
            case .success:
                print("Почтовый клиент открыт")
            case .failure(let error):
                switch error {
                case .mailClientUnavailable:
                    print("Ошибка при переименовании: \(error.localizedDescription)")
                    self.presenter?.presentError(response: "Не удалось открыть почтовый клиент. Убедитесь, что он настроен на вашем устройстве.")
                }
            }
        }
    }
    
    
    func toggleBiometricAuth(_ sender: UIButton) {
        BiometricAuthManager.shared.toggleBiometricAuth()
        updateBiometricAuthButtonTitle()
    }
    
    func updateBiometricAuthButtonTitle() {
        let isEnabled = BiometricAuthManager.shared.isBiometricAuthEnabled
        let title = isEnabled ? "Отключить биометрию" : "Включить биометрию"
        //        biometricAuthButton.setTitle(title, for: .normal)
    }
    
    func attemptBiometricAuthentication() {
        BiometricAuthManager.shared.authenticateUser { success, error in
            if success {
                print("Пользователь аутентифицирован")
                // Выполните нужные действия при успешной аутентификации
            } else {
                print("Ошибка аутентификации: \(String(describing: error))")
                // Обработайте ошибку
            }
        }
    }
    
}
