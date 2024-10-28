import UIKit
import PDFKit

class ImageCell: UITableViewCell {
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
    
    private let pdfPreviewCache = NSCache<NSString, UIImage>()
    
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
        infoLabel.text = nil
        iconImageView.image = nil
    }
}

//    MARK: - Public
extension ImageCell {
    func showContextMenu(menu: UIMenu) {
        moreButton.showsMenuAsPrimaryAction = true
        moreButton.menu = menu
    }
    
    func setupMenu(actions: [UIAction]) {
        let menu = UIMenu(title: "", children: actions)
        moreButton.showsMenuAsPrimaryAction = true
        moreButton.menu = menu
    }
}

//    MARK: - styles & layout
private extension ImageCell {
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

extension ImageCell {
    // Асинхронная генерация превью PDF
    func setupCell(item: ItemForPresent) {
        titleLabel.text = item.name
        infoLabel.text = item.size

        if let imageItem = item.item as? ImageForSave {
            if let image = UIImage(data: imageItem.imageData) {
                let scaledImage = image.resized(to: CGSize(width: 56, height: 56))
                self.iconImageView.image = scaledImage
                self.iconImageView.layer.cornerRadius = Constants.imageSize / 2
            } else {
                self.iconImageView.image = UIImage(named: R.image.ic_image.name)
                self.iconImageView.layer.cornerRadius = 0
            }
        } else if let pdfItem = item.item as? PdfForSave {
            let cacheKey = NSString(string: pdfItem.uuid) // Уникальный идентификатор для кэша
            if let cachedImage = pdfPreviewCache.object(forKey: cacheKey) {
                self.iconImageView.image = cachedImage
                self.iconImageView.layer.cornerRadius = Constants.imageSize / 2
            } else {
                generatePDFPreviewAsync(from: pdfItem.pdf) { [weak self] pdfPreviewImage in
                    guard let self = self else { return }
                    if let pdfPreviewImage = pdfPreviewImage {
                        let scaledImage = pdfPreviewImage.resized(to: CGSize(width: 56, height: 56))
                        self.iconImageView.image = scaledImage
                        self.iconImageView.layer.cornerRadius = Constants.imageSize / 2
                        pdfPreviewCache.setObject(scaledImage, forKey: cacheKey)
                    } else {
                        self.iconImageView.image = UIImage(named: R.image.ic_file.name)
                        self.iconImageView.layer.cornerRadius = 0
                    }
                }
            }
        } else {
            self.iconImageView.image = UIImage(named: R.image.ic_file.name)
            self.iconImageView.layer.cornerRadius = 0
        }
    }
    
    func generatePDFPreviewAsync(from pdfData: Data, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let pdfDocument = PDFDocument(data: pdfData),
                  let pdfPage = pdfDocument.page(at: 0) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let pdfPageBounds = pdfPage.bounds(for: .mediaBox)
            let rendererFormat = UIGraphicsImageRendererFormat()
            rendererFormat.scale = UIScreen.main.scale
            let renderer = UIGraphicsImageRenderer(size: pdfPageBounds.size, format: rendererFormat)
            
            let image = renderer.image { context in
                UIColor.white.set()
                context.fill(pdfPageBounds)
                context.cgContext.translateBy(x: 0, y: pdfPageBounds.size.height)
                context.cgContext.scaleBy(x: 1.0, y: -1.0)
                pdfPage.draw(with: .mediaBox, to: context.cgContext)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
