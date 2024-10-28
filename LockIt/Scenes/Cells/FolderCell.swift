import UIKit

class FolderCell: UITableViewCell {
    private enum Constants {
        static let allStackViewSpace: CGFloat = 24
        static let stackInsideMargin: CGFloat = 16
        static let stackSpace: CGFloat = 16
        static let textNumberOfLines: Int = 0
        static let imageSize: CGFloat = 56
        static let buttonSize: CGFloat = 24
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title16.title
        static let textSettings: ControlSettings = Styles.Typography.Texts.Text14.text
    }
    
    //    MARK: - UIViews
    private lazy var containerView = UIView()
    private lazy var mainStackView = UIStackView()
    
    private lazy var labelsView = UIView()
    private lazy var imageLabelsView = UIView()
    
    lazy var titleLabel = UILabel()
    private lazy var infoLabel = UILabel()
    private lazy var iconImageView = UIImageView()
    private lazy var moreButton = UIButton()
    private lazy var lineView = UIView()
    private lazy var menuCell = UIMenu()
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//    MARK: - public
extension FolderCell {
    func showContextMenu(menu: UIMenu) {
        moreButton.showsMenuAsPrimaryAction = true
        moreButton.menu = menu
    }
    
    func setupMenu(actions: [UIAction]) {
        let menu = UIMenu(title: "", children: actions)
        moreButton.showsMenuAsPrimaryAction = true
        moreButton.menu = menu
    }
    
    func setupCell(item: ItemForPresent, root: RootFolders) {
        titleLabel.text = item.name
        infoLabel.text = item.size
        iconImageView.image = UIImage(named: R.image.ic_folder.name)
        switch root {
        case .files:
            infoLabel.text = item.size
        case .contacts:
            infoLabel.text = "\(item.countFiles ?? 0) items"
        case .notes:
            infoLabel.text = "\(item.countFiles ?? 0) items"
        case .settings:
            break
        }
    }
}

//    MARK: - styles & layout  
private extension FolderCell {
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.backgroundColor = .clear
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        
        iconImageView.layer.masksToBounds = true
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        
        iconImageView.image = UIImage(named: R.image.ic_folder.name)
        
        titleLabel.numberOfLines = 0
        titleLabel.apply(settings: Constants.titleSettings)
        infoLabel.apply(settings: Constants.textSettings)
        infoLabel.numberOfLines = 1
        
        
        moreButton.backgroundColor = .clear
        moreButton.setImage(UIImage(named: R.image.ic_more.name), for: .normal)
        lineView.backgroundColor = .white.withAlphaComponent(0.1)
    }
    
    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
        }
        
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(imageLabelsView)
        mainStackView.addArrangedSubview(moreButton)
        
        labelsView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        labelsView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        imageLabelsView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(24)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: Constants.imageSize, height: Constants.imageSize))
        }
        
        imageLabelsView.addSubview(labelsView)
        labelsView.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(20)
            make.top.greaterThanOrEqualToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
            make.width.equalTo(Constants.buttonSize)
        }
    }
}
