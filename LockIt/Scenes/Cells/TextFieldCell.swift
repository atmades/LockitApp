import UIKit
import SnapKit
import PhoneNumberKit


protocol TextFieldCellDelegate: AnyObject {
    func textFieldText(text: String, type: TypeTextFieldData)
}

class TextFieldCell: UITableViewCell {
    
    private enum Constants {
        static let spacing: CGFloat = 4
        static let heightField: CGFloat = 64
        static let errorSettings: ControlSettings = Styles.Error.Text13.text
    }
    
    private let stackview = UIStackView()
    private let dataField = UITextField()
    private let errorLabel = UILabel()
    private let phoneNumberKit = PhoneNumberKit()
    private var typeContactData: TypeTextFieldData = .phone
    
    weak var delegate: TextFieldCellDelegate?
    
    var placeholder: String? {
        didSet {
            dataField.placeholder = placeholder
        }
    }
    
    var currentText: String? {
        didSet {
            dataField.text = currentText
        }
    }
    
    var isRequired = false {
        didSet {
            if isRequired {
                dataField.placeholder = (placeholder ?? "") + " *"
            } else {
                dataField.placeholder = placeholder
            }
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyles()
        dataField.addTarget(self, action: #selector(didValueChange), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - didValueChange
    @objc func didValueChange() {
        dataField.layer.borderColor = UIColor.clear.cgColor
        dataField.layer.borderWidth = 0
        errorLabel.text = ""
        
        guard var dataString = dataField.text else { return }
        
        switch typeContactData {
        case .text:
            delegate?.textFieldText(text: dataString, type: typeContactData)
            
        case .phone:
            print(dataString)
            checkNumber(phoneNumber: dataString)
            
        case .email:
            delegate?.textFieldText(text: dataString, type: typeContactData)
            
        case .name:
            // запретные знаки
            if dataString.contains("~") {
                dataString = dataString.replacingOccurrences(of: "~", with: "")
            }
            if dataString.contains("_") {
                dataString = dataString.replacingOccurrences(of: "_", with: "")
            }
            dataField.text = dataString
            delegate?.textFieldText(text: dataString, type: typeContactData)
       
        case .lastName:
            if dataString.contains("~") {
                dataString = dataString.replacingOccurrences(of: "~", with: "")
            }
            if dataString.contains("_") {
                dataString = dataString.replacingOccurrences(of: "_", with: "")
            }
            dataField.text = dataString
            delegate?.textFieldText(text: dataString, type: typeContactData)
        }
        
    }
    
    // MARK: - public setup
    func setupKeyboard(type: TypeTextFieldData) {
        typeContactData = type
        
        switch type {
        case .text:
            dataField.keyboardType = .namePhonePad
        case .phone:
            dataField.keyboardType = .numberPad
        case .email:
            dataField.keyboardType = .emailAddress
        case .name:
            dataField.keyboardType = .namePhonePad
        case .lastName:
            dataField.keyboardType = .namePhonePad
        }
    }
    
    func isFocused() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dataField.becomeFirstResponder() // lag time
        }
    }
    
    func setupCell(dataType: TypeTextFieldData, placeholder: String?, currentText: String?, isRequired: Bool = false ) {
        setupKeyboard(type: dataType)
        dataField.text = currentText
        self.isRequired = isRequired
        self.placeholder = placeholder
    }
    
    func error(message: String) {
        errorLabel.textColor = UIColor.red
        errorLabel.text = message
   
        dataField.layer.borderColor = UIColor.red.cgColor
        dataField.layer.borderWidth = 1
    }
}

// MARK: - check format phone
extension TextFieldCell {
    private func checkNumber(phoneNumber: String) {
        do {
            let formattedNumber = try formatPhoneNumber(phoneNumber)
            let cleanedPhoneNumber = formattedNumber.onlyDigits()
            delegate?.textFieldText(text: cleanedPhoneNumber, type: typeContactData)
        } catch {
//            print("Ошибка при разборе номера: \(error.localizedDescription)")
            delegate?.textFieldText(text: "", type: typeContactData)
        }
    }

    private func formatPhoneNumber(_ phoneNumber: String) throws -> String {
        var formattedNumber = ""

        let newNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        if newNumber.hasPrefix("+7") {
            formattedNumber = newNumber
        } else if newNumber.hasPrefix("7") {
            formattedNumber = newNumber
        } else {
            formattedNumber = "+7\(newNumber)"
            print(formattedNumber)
        }
        let parsedPhoneNumber = try phoneNumberKit.parse(formattedNumber)
        return phoneNumberKit.format(parsedPhoneNumber, toType: .international)
    }
}

// MARK: - styles & layout
extension TextFieldCell {
    private func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
        
        stackview.axis = .vertical
        stackview.spacing = Constants.spacing
        
        dataField.setupStyles()
        dataField.returnKeyType = .default
        dataField.autocapitalizationType = .words
        dataField.autocapitalizationType = .sentences
        
        errorLabel.numberOfLines = 0
        errorLabel.apply(settings: Constants.errorSettings)
    }
    
    private func setupLayout() {
        contentView.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        stackview.addArrangedSubview(dataField)
        dataField.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightField)
        }
        stackview.addArrangedSubview(errorLabel)
    }
}

