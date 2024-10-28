import UIKit

enum Alerts {
    private static func build(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
    }
    static func error(controller: UIViewController, title: String? = nil, message: String?) {
        guard !(message ?? "").isEmpty else {
            return
        }
        let alertController = Alerts.build(
            title: title == nil ? R.string.localizedString.error() : title,
            message: message
        )
        alertController.addAction(
            UIAlertAction(title: R.string.localizedString.close(), style: .default, handler: nil)
        )
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func confirmation(controller: UIViewController, alertModel: AlertModel, confirmAction: @escaping () -> Void) {
        let alertController = Alerts.build(
            title: alertModel.title ?? R.string.localizedString.confirmation(), // Если нет заголовка, используем локализованную строку
            message: alertModel.message
        )
        
        // Кнопка "Подтвердить"
        let confirm = UIAlertAction(title: R.string.localizedString.confirm(), style: .default) { _ in
            confirmAction() // Выполняется переданная функция при нажатии "Подтвердить"
        }
        
        // Кнопка "Отменить"
        let cancel = UIAlertAction(title: R.string.localizedString.cancel(), style: .cancel, handler: nil)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func confirmation(controller: UIViewController, title: String?, message: String?, confirmAction: @escaping () -> Void) {
        let alertController = Alerts.build(
            title: title ?? R.string.localizedString.confirmation(), // Если нет заголовка, используем локализованную строку
            message: message
        )
        
        // Кнопка "Подтвердить"
        let confirm = UIAlertAction(title: R.string.localizedString.confirm(), style: .default) { _ in
            confirmAction() // Выполняется переданная функция при нажатии "Подтвердить"
        }
        
        // Кнопка "Отменить"
        let cancel = UIAlertAction(title: R.string.localizedString.cancel(), style: .cancel, handler: nil)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    // Новый метод для простого алерта с кнопкой "Закрыть"
    static func simpleAlert(controller: UIViewController, title: String?, message: String?) {
        let alertController = Alerts.build(
            title: title ?? R.string.localizedString.notice(), // Заголовок "Уведомление" по умолчанию
            message: message
        )

        // Добавление кнопки "Закрыть"
        let closeAction = UIAlertAction(title: R.string.localizedString.close(), style: .default, handler: nil)

        alertController.addAction(closeAction)

        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func confirmationWithInput(controller: UIViewController, title: String?, message: String?, defaultInput: String?, confirmAction: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: title ?? R.string.localizedString.confirmation(),
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = R.string.localizedString.inputPlaceholder()
            textField.text = defaultInput
        }

        let confirm = UIAlertAction(title: R.string.localizedString.confirm(), style: .default) { _ in
            let inputText = alertController.textFields?.first?.text
            confirmAction(inputText) // Передаем введенное значение
        }

        let cancel = UIAlertAction(title: R.string.localizedString.cancel(), style: .cancel, handler: nil)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    
    
    static func confirmationWithMultilineInput(controller: UIViewController, title: String?, message: String?, defaultInput: String?, confirmAction: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: title ?? R.string.localizedString.confirmation(),
            message: message,
            preferredStyle: .alert
        )
        
        // Увеличим высоту контроллера для текста
        let margin: CGFloat = 16.0
        let textView = UITextView(frame: CGRect(x: margin, y: margin, width: 234, height: 100))
        textView.text = defaultInput
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        
        alertController.view.addSubview(textView)
        
        // Настроим констрейнты для размещения textView внутри UIAlertController
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!,
                                                            attribute: .height,
                                                            relatedBy: .greaterThanOrEqual,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1,
                                                            constant: 180)
        alertController.view.addConstraint(height)
        
        // Кнопка подтверждения
        let confirm = UIAlertAction(title: R.string.localizedString.confirm(), style: .default) { _ in
            confirmAction(textView.text)
        }

        // Кнопка отмены
        let cancel = UIAlertAction(title: R.string.localizedString.cancel(), style: .cancel, handler: nil)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)

        controller.present(alertController, animated: true, completion: nil)
    }
}
