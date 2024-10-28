import UIKit

protocol HeaderViewDelegate: AnyObject {
    func didTapGalleryButton()
    func didTapCameraButton()
    func textFieldText(text: String)
}

class HeaderView: UICollectionReusableView {
    
    private enum Constants {
        static let buttonSize: CGFloat = 54
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title22_Light.title
        
        static let spacing: CGFloat = 4
        static let heightField: CGFloat = 64
        static let errorSettings: ControlSettings = Styles.Error.Text13.text
    }
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - UI Views
    private let stackview = UIStackView()
    private let dataField = UITextField()
    private let errorLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private let galleryButton = UIButton(type: .system)
    private let cameraButton = UIButton(type: .system)
    
    // MARK: - State
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayout()
        dataField.addTarget(self, action: #selector(didValueChange), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc func
    @objc private func didTapGalleryButton() {
        delegate?.didTapGalleryButton()
    }
    
    @objc private func didTapPhotoButton() {
        delegate?.didTapCameraButton()
    }
    
    @objc func didValueChange() {
        dataField.layer.borderColor = UIColor.clear.cgColor
        dataField.layer.borderWidth = 0
        errorLabel.text = ""
        
        guard var dataString = dataField.text else { return }
        dataString = dataString.cleanName()
        dataField.text = dataString
        delegate?.textFieldText(text: dataString)
    }
    
    // MARK: - Public
    func setupCell(placeholder: String?, currentText: String?, isRequired: Bool = false ) {
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

// MARK: - Styles & Layout
extension HeaderView {
    private func setupStyles() {
        backgroundColor = .clear
        
        stackview.axis = .vertical
        stackview.spacing = Constants.spacing
        
        dataField.setupStyles()
        dataField.keyboardType = .namePhonePad
        dataField.returnKeyType = .default
        dataField.autocapitalizationType = .words
        dataField.autocapitalizationType = .sentences
        
        errorLabel.numberOfLines = 0
        errorLabel.apply(settings: Constants.errorSettings)
        
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 20
        buttonsStackView.backgroundColor = .clear
        buttonsStackView.distribution = .fillEqually
        
        galleryButton.setTitle("Add from gallery", for: .normal)
        galleryButton.tintColor = .white
        galleryButton.backgroundColor = .white.withAlphaComponent(0.1)
        galleryButton.layer.cornerRadius = 12
        
        cameraButton.setTitle("Take photo", for: .normal)
        cameraButton.tintColor = .white
        cameraButton.backgroundColor = .white.withAlphaComponent(0.1)
        cameraButton.layer.cornerRadius = 12
        
        galleryButton.addTarget(self, action: #selector(didTapGalleryButton), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(stackview)
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
        
        addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(stackview.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
        }
        buttonsStackView.addArrangedSubview(galleryButton)
        buttonsStackView.addArrangedSubview(cameraButton)
        
        galleryButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
        }
        cameraButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
        }
    }
}
