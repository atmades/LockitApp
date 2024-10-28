import UIKit
import SnapKit

protocol TabbarViewDelegate: AnyObject {
    func didTapButton(tag: Int)
}

class TabbarView: UIView {
    
    private enum Constans {
        static let leftPadd: CGFloat = 8
        static let rightPadd: CGFloat = -8
        static let heightTabb: CGFloat = 64
        static let cornerRadius: CGFloat = 32
        
        static let stackLeftPadd: CGFloat = 32
        static let stackRightPadd: CGFloat = -32
        
        static let sizeButton: CGFloat = 28
    }
    
    var delegate: TabbarViewDelegate?
    
    //    MARK: - UIView
    private let tabView = UIView()
    private let stackView = UIStackView()
    private let filesButton = UIButton()
    private let contactsButton = UIButton()
    private let notesButton = UIButton()
    private let profileButton = UIButton()
    
    //    MARK: - Init
    init() {
        super.init(frame: .zero)
        setupStyles()
        setupLayout()
        
        filesButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        contactsButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        notesButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleTapDismiss(_ sender: UIButton) {
        updateTabbarIcons(tag: sender.tag)
        delegate?.didTapButton(tag: sender.tag)
    }
    
    func startApp(tag: Int) {
        updateTabbarIcons(tag: tag)
    }
}

//    MARK: - Setup Layout & Styles
private extension TabbarView {
    func setupStyles() {
        backgroundColor = .clear
        tabView.backgroundColor = .clear
        tabView.clipsToBounds = true
        
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        tabView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        
        tabView.layer.cornerRadius = Constans.cornerRadius
//        tabView.setShadow()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        filesButton.tag = 0
        contactsButton.tag = 1
        notesButton.tag = 2
        profileButton.tag = 3
    }
    
    func setupLayout() {
        
        addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constans.leftPadd)
            make.right.equalToSuperview().offset(Constans.rightPadd)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Constans.heightTabb)
        }
        tabView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constans.stackLeftPadd)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(Constans.stackRightPadd)
            make.bottom.equalToSuperview()
        }
        stackView.addArrangedSubview(filesButton)
        filesButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constans.sizeButton)
        }
        stackView.addArrangedSubview(contactsButton)
        contactsButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constans.sizeButton)
        }
        stackView.addArrangedSubview(notesButton)
        notesButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constans.sizeButton)
        }
        stackView.addArrangedSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constans.sizeButton)
        }
    }
}

extension TabbarView {
        private func updateTabbarIcons(tag: Int) {
            switch tag {
            case 0:
                setFilesSelected()
            case 1:
                setContactsSelected()
            case 2:
                setNotesSelected()
            case 3:
                setProfileSelected()
            default:
                break
            }
        }
    
    private func setFilesSelected() {
        filesButton.setImage(UIImage(named: R.image.filesOn.name), for: .normal)
        contactsButton.setImage(UIImage(named: R.image.contacts.name), for: .normal)
        notesButton.setImage(UIImage(named: R.image.notes.name), for: .normal)
        profileButton.setImage(UIImage(named: R.image.settings.name), for: .normal)
    }
    private func setContactsSelected() {
        filesButton.setImage(UIImage(named: R.image.files.name), for: .normal)
        contactsButton.setImage(UIImage(named: R.image.contactsOn.name), for: .normal)
        notesButton.setImage(UIImage(named: R.image.notes.name), for: .normal)
        profileButton.setImage(UIImage(named: R.image.settings.name), for: .normal)
    }
    private func setNotesSelected() {
        filesButton.setImage(UIImage(named: R.image.files.name), for: .normal)
        contactsButton.setImage(UIImage(named: R.image.contacts.name), for: .normal)
        notesButton.setImage(UIImage(named: R.image.notesOn.name), for: .normal)
        profileButton.setImage(UIImage(named: R.image.settings.name), for: .normal)
    }
    private func setProfileSelected() {
        filesButton.setImage(UIImage(named: R.image.files.name), for: .normal)
        contactsButton.setImage(UIImage(named: R.image.contacts.name), for: .normal)
        notesButton.setImage(UIImage(named: R.image.notes.name), for: .normal)
        profileButton.setImage(UIImage(named: R.image.settingsOn.name), for: .normal)
    }
}
