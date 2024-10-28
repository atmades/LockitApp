import UIKit

protocol MaskingScreenDisplayLogic: AnyObject {
    func displayTitle(viewModel: MaskingScreen.Folder.ViewModel)
}

class MaskingScreenViewController: UIViewController {
    var interactor: MaskingScreenBusinessLogic?
    var router: (NSObjectProtocol & MaskingScreenRoutingLogic & MaskingScreenDataPassing)?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    // MARK: - UI
    private var roundViewBg = UIView()
    private var titleLabel = UILabel()
    private var saveButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)
    private let titleStackView = UIStackView()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: MaskingScreenLayoutProvider.createLayout())
    
    // MARK: - UIViews
    var selectedIndexPathForFirstSection: IndexPath?
    var selectedIndexPathForSecondSection: IndexPath?
    
    private var firstSectionItems: [Item] = [Item(imageName: R.image.mask_no_normal.name),
                                             Item(imageName: R.image.mask_calculator_normal.name)]
    
    private var firstSectionItemsSelected: [Item] = [Item(imageName: R.image.mask_no_selected.name),
                                                     Item(imageName: R.image.mask_calculator_selcted.name)]
    
    private var secondSectionItems: [Item] = [Item(imageName: R.image.masking_appIcon_lock.name),
                                              Item(imageName: R.image.masking_appIcon_defend.name),
                                              Item(imageName: R.image.masking_appIcon_android.name),
                                              Item(imageName: R.image.masking_appIcon_key.name),
                                              Item(imageName: R.image.masking_appIcon_key.name)]
    
    private var secondSectionItemsSelected: [Item] =
    [Item(imageName: R.image.masking_appIcon_lock_selected.name),
     Item(imageName: R.image.masking_appIcon_defend_selected.name),
     Item(imageName: R.image.masking_appIcon_android_selected.name),
     Item(imageName: R.image.masking_appIcon_key_selected.name),
     Item(imageName: R.image.masking_appIcon_key_selected.name)]
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        MaskingScreenConfigurator.sharedInstance.configure(viewController: self)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addGlow()
        setupCollectionView()
        setupStyles()
        setupLayout()
    }
    
    @objc func backButtonDidTap() {
        router?.routeToBack()
    }
    
    @objc func editHandler() {
    }
}

// MARK: - Styles & Layout
extension MaskingScreenViewController {
    private func setupStyles() {
        view.backgroundColor = .clear
        
        roundViewBg.layer.cornerRadius = 50
        roundViewBg.layer.masksToBounds = true
        roundViewBg.addBlur()
        
        cancelButton.setImage(R.image.ico_close(), for: .init())
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        saveButton.setTitle("Confirm", for: .normal)
        saveButton.contentHorizontalAlignment = .right
        saveButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        titleLabel.text = "Masking"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
    }
    
    private func setupLayout() {
        view.addSubview(roundViewBg)
        roundViewBg.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        roundViewBg.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-16)
        }
        
        titleStackView.addArrangedSubview(cancelButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(saveButton)
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(44)
        }
        roundViewBg.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleStackView.snp.bottom).offset(24)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setup CollectionView
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: CustomCell.self)
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:  CustomHeaderView.identifier)
    }
}

// MARK: - DisplayLogic
extension MaskingScreenViewController: MaskingScreenDisplayLogic {
    func displayTitle(viewModel: MaskingScreen.Folder.ViewModel) {
    }
}

// MARK: - CollectionView DataSource
extension MaskingScreenViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? firstSectionItems.count : secondSectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
        
        let itemNormal = indexPath.section == 0 ? firstSectionItems[indexPath.item] : secondSectionItems[indexPath.item]
        
        let itemSelected = indexPath.section == 0 ? firstSectionItemsSelected[indexPath.item] : secondSectionItemsSelected[indexPath.item]
        
        cell.normalImage = UIImage(named: itemNormal.imageName)
        cell.selectedImage = UIImage(named: itemSelected.imageName)
        
        cell.updateImage(isSelected: indexPath == selectedIndexPathForFirstSection || indexPath == selectedIndexPathForSecondSection)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, indexPath.section == 1 else { return UICollectionReusableView() }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.identifier, for: indexPath) as? CustomHeaderView else {
            return UICollectionReusableView()
        }
        return headerView
    }
}

// MARK: - CollectionView Delegate
extension MaskingScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Обновляем состояние выбора для первой секции
            if let previousIndexPath = selectedIndexPathForFirstSection {
                collectionView.deselectItem(at: previousIndexPath, animated: true)
            }
            selectedIndexPathForFirstSection = indexPath
        } else {
            // Обновляем состояние выбора для второй секции
            if let previousIndexPath = selectedIndexPathForSecondSection {
                collectionView.deselectItem(at: previousIndexPath, animated: true)
            }
            selectedIndexPathForSecondSection = indexPath
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == selectedIndexPathForFirstSection {
            selectedIndexPathForFirstSection = nil
        } else if indexPath == selectedIndexPathForSecondSection {
            selectedIndexPathForSecondSection = nil
        }
        collectionView.reloadData()
    }
}


struct Item: Hashable {
    let id = UUID()
    let imageName: String
}
