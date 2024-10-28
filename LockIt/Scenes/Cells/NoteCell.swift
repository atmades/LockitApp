import UIKit

class NoteCell: UITableViewCell {
    private enum Constants {
        static let allStackViewSpace: CGFloat = 24
        static let stackInsideMargin: CGFloat = 16
        static let stackSpace: CGFloat = 16
        static let textNumberOfLines: Int = 0
        static let imageSize: CGFloat = 56
        static let buttonSize: CGFloat = 24
        
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title16_white.title
        static let textSettings: ControlSettings = Styles.Typography.Texts.Text14.text
        static let infoSettings: ControlSettings = Styles.Typography.Texts.Text12.text
    }
    
    //    MARK: - UIViews
    private lazy var containerView = UIView()
    private lazy var mainStackView = UIStackView()
    
    private lazy var labelsView = UIView()
    private lazy var imageLabelsView = UIView()
    
    private lazy var titleLabel = UILabel()
    private lazy var noteTextLabel = UILabel()
    private lazy var infoLabel = UILabel()
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

//    MARK: - Public CellWihtContexthMenu

extension NoteCell {
    func showContextMenu(menu: UIMenu) {
        moreButton.showsMenuAsPrimaryAction = true
        moreButton.menu = menu
    }
    
    func setupCell(item: ItemForPresent) {
        titleLabel.text = item.name
        
        if let note = item.item as? NoteForSave {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
            noteTextLabel.text = note.text
            infoLabel.text = dateFormatter.string(from: note.creationDate)
        }
    }
}

//    MARK: - Setup Layout & Styles
private extension NoteCell {
    func setupStyles() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.backgroundColor = .clear
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        
        titleLabel.numberOfLines = 0
        titleLabel.apply(settings: Constants.titleSettings)
        
        noteTextLabel.numberOfLines = 3
        noteTextLabel.apply(settings: Constants.textSettings)

        infoLabel.numberOfLines = 1
        infoLabel.apply(settings: Constants.infoSettings)
        
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
            make.top.equalToSuperview().offset(22)
        }
        
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(22)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(labelsView)
        mainStackView.addArrangedSubview(moreButton)
        
        labelsView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        
        labelsView.addSubview(noteTextLabel)
        noteTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        labelsView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(noteTextLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonSize)
            make.width.equalTo(Constants.buttonSize)
        }
    }
}



