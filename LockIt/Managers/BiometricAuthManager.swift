import Foundation
import LocalAuthentication

class BiometricAuthManager {

    static let shared = BiometricAuthManager()
    
    // Проверка состояния включения биометрической аутентификации
    var isBiometricAuthEnabled: Bool {
        get {
            return UserDefaultsManager.shared.isBiometricAuthEnabled
        }
        set {
            UserDefaultsManager.shared.isBiometricAuthEnabled = newValue
        }
    }
    
    // Метод для переключения состояния биометрической аутентификации
    func toggleBiometricAuth() {
        isBiometricAuthEnabled.toggle()
    }
    
    // Аутентификация пользователя с использованием Face ID или Touch ID
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        guard isBiometricAuthEnabled else {
            completion(false, nil)
            print("Биометрическая аутентификация отключена")
            return
        }
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Пожалуйста, аутентифицируйтесь для входа"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success, authenticationError)
                }
            }
        } else {
            completion(false, error)
            print("Биометрия недоступна на этом устройстве")
        }
    }
}
