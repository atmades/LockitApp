import UIKit

protocol AvatarChoosingDelegate: AnyObject {
    func didTapAddPhoto()
}

class AvatarChoosingCell: UITableViewCell {
    
    private enum Constants {
        static let imageSize: CGFloat = 124
        static let buttonSize: CGFloat = 24
    }
    
    weak var delegate: AvatarChoosingDelegate?
    
    // MARK: - UIViews
    private lazy var avaterImageView = UIImageView()
    private lazy var addPhotoButton = UIButton()
    
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
    func setupCell(imageData: Data?) {
        if let data = imageData, let image = UIImage(data: data) {
            avaterImageView.image = image
        } else {
            avaterImageView.image = UIImage(named: R.image.ic_contact.name)
        }
    }
}

// MARK: - Styles & Layout
private extension AvatarChoosingCell {
    
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        
        avaterImageView.contentMode = .scaleAspectFill
        avaterImageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        avaterImageView.layer.masksToBounds = true
        avaterImageView.clipsToBounds = true
        avaterImageView.layer.cornerRadius = Constants.imageSize / 2
        
        addPhotoButton.backgroundColor = .clear
        addPhotoButton.apply(settings: Styles.Button.Second.Small.normal)
        addPhotoButton.setTitle("Add photo", for: .normal)
        addPhotoButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.didTapAddPhoto()
    }
    
    func setupLayout() {
        contentView.addSubview(avaterImageView)
        avaterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(Constants.imageSize)
            make.width.equalTo(Constants.imageSize)
        }
        contentView.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avaterImageView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(0)
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
    }
}

