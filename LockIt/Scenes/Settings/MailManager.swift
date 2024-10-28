import UIKit
import MessageUI

struct SupportEmailConfig {
    static let email = "support@example.com"
    static let subject = "Поддержка"
    static let body = "Ваш текст"
}

class MailManager: NSObject, MFMailComposeViewControllerDelegate {
    
    static let shared = MailManager()
    
    enum MailError: Error {
        case mailClientUnavailable
    }
    
    override init() {
        super.init()
    }
    
    func sendEmail(from viewController: UIViewController, completion: (Result<Void, MailError>) -> Void) {
            guard MFMailComposeViewController.canSendMail() else {
                completion(.failure(.mailClientUnavailable))
                return
            }
            
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([SupportEmailConfig.email])
            mailComposeVC.setSubject(SupportEmailConfig.subject)
            mailComposeVC.setMessageBody(SupportEmailConfig.body, isHTML: false)
            
            viewController.present(mailComposeVC, animated: true, completion: nil)
            completion(.success(()))
        }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
