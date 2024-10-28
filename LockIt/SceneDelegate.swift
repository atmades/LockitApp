import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        print("SceneDelegate: willConnectTo called")
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController()
//        window.rootViewController = SettingsListViewController()
        
        self.window = window
        self.window?.overrideUserInterfaceStyle = .dark // dark mode for context menu
        window.makeKeyAndVisible()
        
        // Проверяем, есть ли входящие URL при запуске
        if let urlContext = connectionOptions.urlContexts.first {
            handleIncomingURL(urlContext.url)
        }
    }
    
    func scene(_ scene: UIScene, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("URL открыто: \(url)")
        if url.scheme == "lockit" {
            // Обработка URL
            print("URL-схема соответствуют требованиям: \(url)")
            if let mainVC = window?.rootViewController as? MainViewController {
                mainVC.showPDFScreen(with: url)
                return true
            }
        }
        
        if let mainVC = window?.rootViewController as? MainViewController {
            mainVC.showPDFScreen(with: url)
        }
        return false
    }
    
    
    // Обработка URL при активной сцене (например, когда приложение открыто)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let urlContext = URLContexts.first else { return }
        handleIncomingURL(urlContext.url)
    }
    
    func handleIncomingURL(_ url: URL) {
        // Check if the URL scheme is the one you expect
        if url.scheme == "lockit", let pdfData = getPDFData(from: url) {
            // Assuming you have a reference to MainViewController
            if let mainViewController = window?.rootViewController as? MainViewController {
                mainViewController.showPDFScreen(with: pdfData, pdfName: url.lastPathComponent)
            }
        }
    }
    
    func getPDFData(from url: URL) -> Data? {
        // Load PDF data from the URL
        return try? Data(contentsOf: url)
    }
}

