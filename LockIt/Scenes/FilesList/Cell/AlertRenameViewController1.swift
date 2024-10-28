import UIKit

class AlertRenameViewController1: UIViewController {
    weak var viewController: UIViewController?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    private var roundViewBg = UIView()
    
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    private let titleStackView = UIStackView()
    
    private var firstTextField = RequiredTextField()
    private let textFieldsStackView = UIStackView()
    
    
    private var saveButton = UIButton()
    private var cancelButton = UIButton()
    
    var placeholder = "" {
        didSet {
            firstTextField.placeholder = placeholder
        }
    }
    
    var nameDefault = "" {
        didSet {
            firstTextField.text = nameDefault
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayout()
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    
    @objc func didTapCancel() {
        print(#function)
        self.dismiss(animated: true)
        
    }
    
    @objc func didTapSave() {

        print(#function)

    }
}

private extension AlertRenameViewController1 {
    
    @objc func backButtonDidTap() {
        print(#function)
    }
    
    func setupStyles() {
        
        view.backgroundColor = .clear
        
        roundViewBg.layer.cornerRadius = 50
        roundViewBg.layer.masksToBounds = true
        roundViewBg.addBlur()
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .clear
        saveButton.contentHorizontalAlignment = .right
        saveButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        titleLabel.text = "Rename"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        textFieldsStackView.axis = .vertical
        firstTextField.setup(isRequired: true, placeholder: "Enter name")
    }
    
    func setupLayout() {
        
        view.addSubview(roundViewBg)
        roundViewBg.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        roundViewBg.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        titleStackView.addArrangedSubview(cancelButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(saveButton)
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(72)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(72)
        }
        
        roundViewBg.addSubview(textFieldsStackView)
        textFieldsStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalTo(titleStackView.snp.bottom).offset(54)
            make.right.equalToSuperview().offset(-32)
        }
        
        textFieldsStackView.addArrangedSubview(firstTextField)
        firstTextField.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
    }
}
