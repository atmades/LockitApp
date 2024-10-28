import UIKit

class RequiredTextField: UITextField {
    
    var isRequired: Bool = false {
        didSet {
            updatePlaceholder()
        }
    }
    
    func setup(isRequired: Bool = false, placeholder: String = "", text: String? = nil) {
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.text = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Здесь вы можете добавить другие общие настройки для текстового поля
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

    private func updatePlaceholder() {
        if isRequired {
            placeholder = (placeholder ?? "") + " *"
        } else {
            placeholder = placeholder?.replacingOccurrences(of: " *", with: "")
        }
    }
}
