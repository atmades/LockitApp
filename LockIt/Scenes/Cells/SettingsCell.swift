import UIKit

class SettingsCell: UITableViewCell {
    private enum Constants {
        static let allStackViewSpace: CGFloat = 24
        static let stackInsideMargin: CGFloat = 16
        static let stackSpace: CGFloat = 16
        static let textNumberOfLines: Int = 0
        static let imageSize: CGFloat = 32
        static let buttonSize: CGFloat = 24
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title16_white.title
    }
    

    
    //    MARK: - UIViews
    private lazy var containerView = UIView()
    private lazy var mainStackView = UIStackView()
    
    private lazy var labelsView = UIView()
    private lazy var imageLabelsView = UIView()
    
    private lazy var titleLabel = UILabel()
    private lazy var iconImageView = UIImageView()
    private lazy var moreButton = UIButton()
    
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
    }
}

//    MARK: - Public
extension SettingsCell {
    func setupCell(title: String, imageName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(named: imageName)
    }
}

//    MARK: - Setup Layout & Styles
private extension SettingsCell {
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.backgroundColor = .white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        mainStackView.backgroundColor = .clear
        
        iconImageView.layer.masksToBounds = true
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.backgroundColor = .clear

        titleLabel.numberOfLines = 0
        titleLabel.apply(settings: Constants.titleSettings)
        
        moreButton.backgroundColor = .clear
        moreButton.setImage(UIImage(named: R.image.ico_arrow_right.name), for: .normal)
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
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mainStackView.addArrangedSubview(imageLabelsView)
        mainStackView.addArrangedSubview(moreButton)
        
        imageLabelsView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: Constants.imageSize, height: Constants.imageSize))
        }
        
        imageLabelsView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
            make.width.equalTo(Constants.buttonSize)
        }
    }
}

