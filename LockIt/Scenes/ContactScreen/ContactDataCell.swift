import UIKit

enum ContactData {
    case phone
    case email
}

protocol ContactDataProtocol: AnyObject {
    func didtapleftButton(type: ContactData)
    func didTapRightButton(type: ContactData)
    func didTapRightRightButton(type: ContactData)
}

class ContactDataCell: UITableViewCell {
    private enum Constants {
        static let buttonSize: CGFloat = 40
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title22_Light.title
    }
    
    // MARK: - UIViews
    private lazy var contactDataLabel = UILabel()
    private lazy var buttonsStackView = UIStackView()
    private lazy var leftButton = UIButton()
    private lazy var rightButton = UIButton()
    
    weak var delegate: ContactDataProtocol?
    private var typeContactData: ContactData = .phone
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Cell
    func setupCell(contact: String?, dataType: ContactData ) {
        
        if let contact = contact {
            contactDataLabel.isHidden = false
            buttonsStackView.isHidden = false
            
            contactDataLabel.text = contact
            setupKeyboard(type: dataType)
        } else {
            contactDataLabel.isHidden = true
            buttonsStackView.isHidden = true
        }
    }
    
    private func setupKeyboard(type: ContactData) {
        typeContactData = type
        
        switch type {
        case .phone:
            rightButton.setImage(UIImage(named: R.image.ic_call.name), for: .normal)
        case .email:
            rightButton.setImage(UIImage(named: R.image.ic_email.name), for: .normal)
        }
    }
}

// MARK: - Styles & Layout
private extension ContactDataCell {
    
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 24
        buttonsStackView.backgroundColor = .clear
        
        contactDataLabel.text = "+2(342)4321 23"
        contactDataLabel.apply(settings: Constants.titleSettings)
        contactDataLabel.textAlignment = .center
        contactDataLabel.numberOfLines = 0
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightRightButtonTapped(_:)), for: .touchUpInside)
        
        leftButton.setImage(UIImage(named: R.image.ic_copy.name), for: .normal)
        leftButton.backgroundColor = .clear
        
        rightButton.setImage(UIImage(named: R.image.ic_call.name), for: .normal)
        rightButton.backgroundColor = .clear
    }
    
    @objc func leftButtonTapped(_ sender: UIButton) {
        delegate?.didtapleftButton(type: typeContactData)
    }
    
    @objc func rightButtonTapped(_ sender: UIButton) {
        delegate?.didTapRightButton(type: typeContactData)
    }
    
    @objc func rightRightButtonTapped(_ sender: UIButton) {
        delegate?.didTapRightRightButton(type: typeContactData)
    }
    
    func setupLayout() {
        contentView.addSubview(contactDataLabel)
        contactDataLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(contactDataLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
        
        buttonsStackView.addArrangedSubview(leftButton)
        buttonsStackView.addArrangedSubview(rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
            make.width.equalTo(Constants.buttonSize)
        }
        rightButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
            make.width.equalTo(Constants.buttonSize)
        }
    }
}
