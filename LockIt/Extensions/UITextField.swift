import UIKit


extension UITextField {
    
    func setupStyles() {
        backgroundColor = UIColor(named: R.color.color_gray85.name)
        layer.cornerRadius = 12
        borderStyle = .none
        autocapitalizationType = .sentences
        layer.masksToBounds = true
        returnKeyType = .next
        autocapitalizationType = .words
        font = .makeAvenir(size: 16)
        textColor = UIColor.white.withAlphaComponent(0.8)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.3)
        ]
        let attributedPlaceholder = NSAttributedString(string: " ", attributes: attributes)
        self.attributedPlaceholder = attributedPlaceholder

        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 10))
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 10))

        paddingViewLeft.backgroundColor = .clear
        leftView = paddingViewLeft
        leftViewMode = .always

        paddingViewRight.backgroundColor = .clear
        rightView = paddingViewRight
        rightViewMode = .always
    }
}
