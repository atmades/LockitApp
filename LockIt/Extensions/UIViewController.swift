import UIKit

extension UIViewController {
    
    
    func addTitleNavigationBar(title: String) {
        let label = UILabel()
        label.text = title
//        label.apply(settings: Styles.Typografic.Titles.Title17.title)
        navigationItem.titleView = label
    }
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        view.sendSubviewToBack(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    func addKeyboardObserver(willShow: Selector, willHide: Selector) {
        NotificationCenter.default.addObserver(
            self,
            selector: willShow,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: willHide,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    internal func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        view.addGestureRecognizer(tapGesture)
        self.navigationController?.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewDidTap() {
        view.endEditing(true)
        if let navController = self.navigationController {
            navController.view.endEditing(true)
        }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}
