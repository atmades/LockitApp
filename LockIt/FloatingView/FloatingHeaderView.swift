import UIKit

class FloatingHeaderView: UIView {
    private enum Constants {
        static let padTop: CGFloat = 56
        static let padLeft: CGFloat = 16
        static let padRight: CGFloat = -16
        static let padBottom:  CGFloat = -8
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title27.title
    }
    
    weak var delegate: AnyObject?
    
    private func sortDelegate(sort: SortType) {
        if let sortDelegate = delegate as? FloatingHeaderViewSortDelegate {
            sortDelegate.didTapChangeSort1(sort: sort)
        }
    }
    
    lazy var actions: [UIAction] = [
        UIAction(title: SortType.type.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .type)
        },
        UIAction(title: SortType.nameA.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .nameA)
        },
        UIAction(title: SortType.nameZ.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .nameZ)
        },
        
        UIAction(title: SortType.sizeBig.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .sizeBig)
        },
        
        UIAction(title: SortType.sizeSmal.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .sizeSmal)
        },
        
        UIAction(title: SortType.dateNew.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .dateNew)
        },
        UIAction(title: SortType.dateOld.rawValue) { [weak self] action in
            guard let self = self else { return }
            self.sortDelegate(sort: .dateOld)
        }
    ]
    
    @objc func didTapGoBack() {
        if let backDelegate = delegate as? FloatingHeaderViewBackDelegate {
            backDelegate.didTabBack1()
        }
    }
    
    // MARK: - UI
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let sortButton = UIButton(primaryAction: nil)
    private let newButton = UIButton()
    private let search = UIView()
    
    private var blurEffectView: UIVisualEffectView!
    private var menuView = UIMenu()
    
    var menu: UIMenu {
        get {
            return menuView
        }
    }
    
    //    MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupStyle()
        setupLayout()
        setupMenu()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Public
    func configure(title: String?, counterVC: Int) {
        titleLabel.text = title
        counterVC == 1 ? (backButton.isHidden = true) : (backButton.isHidden = false)
    }
    
    func showNewItemMenu(menu: UIMenu) {
        newButton.showsMenuAsPrimaryAction = true
        newButton.menu = menu
    }
}

extension FloatingHeaderView {
    
    func setupSortMenu(actions: [UIAction]) {
        let menu = UIMenu(title: "", children: actions)
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
        
        sortButton.menu = menu
    }
    
    func setupSortMenu(actions: inout [UIAction], sortType: SortType) {
        for action in actions {
            action.state = action.title == sortType.rawValue ? .on : .off
        }
        
        // Создаем меню с обновленными экшнами
        let menu = UIMenu(title: "", children: actions)
        
        // Настройка кнопки
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.menu = menu
    }
    
    
    func setupMenu() {
        //        let nameAction = UIAction(title: SortType.nameA.rawValue, image: UIImage(systemName: "pencil")) { [weak self] action in
        //            guard let self = self else { return }
        //            print("byName")
        //            self.delegate?.sortNameA()
        //        }
        //
        //        let sizeAction = UIAction(title: SortType.sizeBig.rawValue, image: UIImage(systemName: "pencil")) { [weak self] action in
        //            guard let self = self else { return }
        //            print("bySize")
        //            self.delegate?.sortSize()
        //        }
        //
        //        let dateAction = UIAction(title: SortType.dateNew.rawValue, image: UIImage(systemName: "pencil")) { [weak self] action in
        //            guard let self = self else { return }
        //            print("byDate")
        //            self.delegate?.sortDate()
        //        }
        //
        //        let actions: [UIAction] = [nameAction, sizeAction, dateAction]
        
        // Создаем меню с обновленными экшнами
        let menu = UIMenu(title: "", children: actions)
        
        // Настройка кнопки
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.menu = menu
        
    }
    
    func updateMenu(sortType: SortType) {
        for action in actions {
            action.state = action.title == sortType.rawValue ? .on : .off
        }
        
        // Создаем меню с обновленными экшнами
        let menu = UIMenu(title: "", children: actions)
        
        // Настройка кнопки
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.menu = menu
    }
    
    
    private func setupStyle() {
        backgroundColor = .black
        
        backButton.setImage(UIImage(named: R.image.ico_arrow_back.name), for: .normal)
        backButton.addTarget(self, action: #selector(didTapGoBack), for: .touchUpInside)
        
        titleLabel.apply(settings: Constants.titleSettings)
        
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = UIColor(named: R.color.color_gray80.name)
        config.cornerStyle = .capsule
        sortButton.configuration = config
        
        sortButton.apply(settings: Styles.Button.Second.Small.normal)
        
        newButton.setImage(UIImage(named: R.image.ic_plus.name), for: .normal)
        
        search.backgroundColor = .white.withAlphaComponent(0.1)
        search.layer.cornerRadius = 24
        search.clipsToBounds = true
    }
    
    private func setupLayout() {
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.top.equalToSuperview().offset(Constants.padTop)
        }
        
        addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(4)
            make.top.equalToSuperview().offset(54)
            make.width.greaterThanOrEqualTo(98)
            make.height.equalTo(36)
        }
        
        addSubview(newButton)
        newButton.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(sortButton.snp.right).offset(8)
            make.right.equalToSuperview().offset(Constants.padRight)
            make.centerY.equalTo(sortButton.snp.centerY)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        
        addSubview(search)
        search.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.right.equalToSuperview().offset(Constants.padRight)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(Constants.padBottom)
            make.height.equalTo(48)
        }
    }
}
