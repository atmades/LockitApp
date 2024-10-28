import Foundation


class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    // Ключ для сохранения состояния выбранной кнопки меню
    private let selectedMenuKey = "selectedMenu"
    private let biometricAuthKey = "isBiometricAuthEnabled"
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // Сохранение состояния выбранной кнопки меню
    func saveSelectedMenu(title: String) {
        defaults.set(title, forKey: selectedMenuKey)
    }
    
    // Загрузка состояния выбранной кнопки меню
    func loadSelectedMenu() -> String? {
        return defaults.string(forKey: selectedMenuKey)
    }
    

    
    // Получение и установка состояния биометрической аутентификации
    var isBiometricAuthEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: biometricAuthKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: biometricAuthKey)
        }
    }
}


