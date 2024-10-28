import UIKit

class SwitcherCell: UITableViewCell {
    private enum Constants {
        static let allStackViewSpace: CGFloat = 24
        static let stackInsideMargin: CGFloat = 16
        static let stackSpace: CGFloat = 16
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title16_white.title
        static let textSettings: ControlSettings = Styles.Typography.Texts.Text14.text
    }
    
    //    MARK: - UIViews
    private lazy var containerView = UIView()
    private lazy var mainStackView = UIStackView()
    private lazy var labelsView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var textabel = UILabel()
    private lazy var switcher = UISwitch()
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyles()
        
        titleLabel.text = "Camera Trap is triggered when the passcode is entered incorrently"
        textabel.text = "Not available when using Masking"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        titleLabel.text = nil
//        textabel.text = nil
    }
}

//    MARK: - Public
extension SwitcherCell {
    func setupCell(title: String, text: String, isOn: Bool) {
        titleLabel.text = title
        textabel.text = text
        switcher.isOn = isOn
    }
    func setupCell(title: String, imageName: String) {
        titleLabel.text = title
    }
}

//    MARK: - Setup Layout & Styles
private extension SwitcherCell {
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.backgroundColor = .white.withAlphaComponent(0.04)
        containerView.layer.cornerRadius = 12
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        mainStackView.backgroundColor = .clear

        titleLabel.numberOfLines = 0
        titleLabel.apply(settings: Constants.titleSettings)
        
        textabel.numberOfLines = 0
        textabel.apply(settings: Constants.textSettings)
    }
    
    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mainStackView.addArrangedSubview(labelsView)
        mainStackView.addArrangedSubview(switcher)

        labelsView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        labelsView.addSubview(textabel)
        textabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}



