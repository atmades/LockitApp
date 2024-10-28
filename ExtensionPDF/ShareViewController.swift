import UIKit
import UniformTypeIdentifiers
import MobileCoreServices

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Начинаем процесс обработки входящих данных
        processIncomingItems()
    }
    
    private func processIncomingItems() {
        // Получаем входящие контенты
        if let inputItems = extensionContext?.inputItems as? [NSExtensionItem] {
            for item in inputItems {
                guard let attachments = item.attachments else { continue }
                for itemProvider in attachments {
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { [weak self] (item, error) in
                            if let url = item as? URL {
                                print(url)
                                // Передача URL PDF вашему основному приложению
                                self?.handlePDF(url: url)
                            } else if let error = error {
                                print("Error loading item: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handlePDF(url: URL) {
        // Кодируем компонент пути для использования в URL
        let encodedFileName = url.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlSchemeString = "lockit://importPDF?file=\(encodedFileName)"
        guard let urlScheme = URL(string: urlSchemeString) else {
            print("Не удалось создать URL-схему: \(urlSchemeString)")
            return
        }
        
        print("URL-схема для открытия: \(urlScheme)")
        
        extensionContext?.open(urlScheme, completionHandler: { success in
            if success {
                print("URL-схема успешно открыта")
            } else {
                print("Не удалось открыть URL-схему")
            }
        })
    }

//    private func handlePDF(url: URL) {
//        // Кодируем URL для использования в URL-схеме
//        let encodedURLString = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let urlScheme = URL(string: "yourapp://importPDF?file=\(encodedURLString ?? "")")!
//        
//        // Открываем основное приложение
//        extensionContext?.open(urlScheme, completionHandler: { [weak self] success in
//            if success {
//                // Завершаем работу расширения
//                self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
//            } else {
//                print("Error opening app with URL scheme")
//            }
//        })
//    }
}
