import UIKit

class ContactAvatarCell: UITableViewCell {
    
    private enum Constants {
        static let imageSize: CGFloat = 180
        static let buttonSize: CGFloat = 24
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title27.title
    }
    
    // MARK: - UIViews
    private lazy var avaterImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    
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
    func setupCell(imageData: Data?, name: String?) {
        nameLabel.text = name
        if let data = imageData, let image = UIImage(data: data) {
            avaterImageView.image = image
        } else {
            avaterImageView.image = UIImage(named: R.image.ic_contact.name)
        }
    }
}

// MARK: - Styles & Layout
private extension ContactAvatarCell {
    
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        
        avaterImageView.contentMode = .scaleAspectFill
        avaterImageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        avaterImageView.layer.masksToBounds = true
        avaterImageView.clipsToBounds = true
        avaterImageView.layer.cornerRadius = Constants.imageSize / 2
        
        nameLabel.text = "Lololol Lololol Lololol Lololol Lololol"
        nameLabel.apply(settings: Constants.titleSettings)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
    }
    
    func setupLayout() {
        contentView.addSubview(avaterImageView)
        avaterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(Constants.imageSize)
            make.width.equalTo(Constants.imageSize)
        }
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(avaterImageView.snp.bottom).offset(24)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
}
