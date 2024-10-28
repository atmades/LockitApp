import UIKit
import SnapKit
import PhoneNumberKit

protocol CustomTextFieldViewDelegate: AnyObject {
    func textFieldText(text: String, type: TypeTextFieldData)
}

class CustomTextFieldView: UIView {
    private let stackView = UIStackView()
    private let textField = UITextField()
    private let errorLabel = UILabel()
    private let phoneNumberKit = PhoneNumberKit()
    var typeContactData: TypeTextFieldData = .name
    
    weak var delegate: CustomTextFieldViewDelegate?
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var currentText: String? {
        didSet {
            textField.text = currentText
        }
    }
    
    var isRequired = false {
        didSet {
            if isRequired {
                textField.placeholder = (placeholder ?? "") + " *"
            } else {
                textField.placeholder = placeholder
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupStyles()
        textField.addTarget(self, action: #selector(didValueChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - didValueChange
    @objc func didValueChange() {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
        errorLabel.text = ""
        
        guard var dataString = textField.text else { return }
        
        switch typeContactData {
        case .text:
            delegate?.textFieldText(text: dataString, type: typeContactData)
        case .phone:
            checkNumber(phoneNumber: dataString)
        case .email:
            delegate?.textFieldText(text: dataString, type: typeContactData)
        case .name, .lastName:
            dataString = sanitizeNameData(dataString)
            textField.text = dataString
            delegate?.textFieldText(text: dataString, type: typeContactData)
        }
    }
    
    // MARK: - Public Setup
    func setupKeyboard(type: TypeTextFieldData) {
        typeContactData = type
        switch type {
        case .text, .name, .lastName:
            textField.keyboardType = .namePhonePad
        case .phone:
            textField.keyboardType = .numberPad
        case .email:
            textField.keyboardType = .emailAddress
        }
    }
    
    func setupField(type: TypeTextFieldData, placeholder: String?, text: String?, isRequired: Bool = false) {
        setupKeyboard(type: type)
        self.placeholder = placeholder
        self.currentText = text
        self.isRequired = isRequired
    }
    
    func showError(message: String) {
        errorLabel.text = message
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
    }
    
    // MARK: - Helpers
    private func sanitizeNameData(_ data: String) -> String {
        return data.replacingOccurrences(of: "[~_]", with: "", options: .regularExpression)
    }
    
    private func checkNumber(phoneNumber: String) {
        do {
            let formattedNumber = try formatPhoneNumber(phoneNumber)
            let cleanedPhoneNumber = formattedNumber.onlyDigits()
            delegate?.textFieldText(text: cleanedPhoneNumber, type: typeContactData)
        } catch {
            delegate?.textFieldText(text: "", type: typeContactData)
        }
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) throws -> String {
        var formattedNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        if !formattedNumber.hasPrefix("+7") {
            formattedNumber = "+7" + formattedNumber
        }
        let parsedPhoneNumber = try phoneNumberKit.parse(formattedNumber)
        return phoneNumberKit.format(parsedPhoneNumber, toType: .international)
    }
    
    // MARK: - Layout & Styles
    private func setupStyles() {
        stackView.axis = .vertical
        stackView.spacing = 4
        textField.setupStyles()
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(textField)
        textField.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        stackView.addArrangedSubview(errorLabel)
    }
}
