import UIKit

protocol SettingsListDisplayLogic: AnyObject {
    func displayError(viewModel: SettingsList.Error.ViewModel)
    func displayTitle(viewModel: SettingsList.Folder.ViewModel)
}

class SettingsListViewController: UIViewController {
    var interactor: SettingsListBusinessLogic?
    var router: (NSObjectProtocol & SettingsListRoutingLogic & SettingsListDataPassing)?
    
    private lazy var tableView = UITableView()
    
    private var lastContentOffset: CGFloat = 0
    private var statusBarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return 0 }
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    }
    lazy var floatingHeaderViewHeight: CGFloat = 115
    lazy var floatingHeaderView: FloatingSettingsHeaderView = FloatingSettingsHeaderView(title: " ")
    
    var isAnimating = false
    var didStartScrolling = false
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        SettingsListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        updateHeaderViewPosition(.start)
        getTitle()
        setupNavigationBar()
        setupStyles()
        setupLayout()
    }
    
    private func getTitle() {
        interactor?.getTitleName()
    }
}

//  MARK: - style & layout
private extension SettingsListViewController {
    func setupStyles() {
        view.backgroundColor = .black
        view.addGlow()
        
        tableView.register(cell: SettingsCell.self)
        tableView.setAutoDimension()
        tableView.setup(target: self)
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 115, left: 0, bottom: 130, right: 0)
        floatingHeaderView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        view.addSubview(floatingHeaderView)
        floatingHeaderView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(statusBarHeight)
            make.right.equalToSuperview()
            make.height.equalTo(floatingHeaderViewHeight)
        }
    }
    
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

//  MARK: - DisplayLogic
extension SettingsListViewController: SettingsListDisplayLogic {
    func displayError(viewModel: SettingsList.Error.ViewModel) {
        Alerts.error(controller: self, message: viewModel.message)
    }
    
    func displayTitle(viewModel: SettingsList.Folder.ViewModel) {
        floatingHeaderView.configure(title: viewModel.folderName, counterVC: viewModel.counterVC)
    }
}

//  MARK: - FloatingHeaderViewBackDelegate
extension SettingsListViewController: FloatingHeaderViewBackDelegate {
    func didTabBack1() {

    }
}

//  MARK: - UITableViewDataSource
extension SettingsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = SettingsRow(rawValue: indexPath.row) else { return UITableViewCell() }
        switch row {
        default:
            let cell = SettingsCell.get(from: tableView, at: indexPath)
            cell.setupCell(title: row.title, imageName: row.imageName)
            return cell
        }
    }
}

//  MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = SettingsRow(rawValue: indexPath.row) else { return }
        
        switch row {
        case .masking:
            router?.routeToMaskingScreen()
        case .cameraTrap:
            router?.routeToCameraTrapScreen()
        case .fakePasscode:
            router?.routeToMaskingScreen()
        case .biometry:
            router?.routeToBiometryScreen()
        case .originalPasscode:
            router?.routeToChangePasscodeScreen()
        case .shareApp:
            router?.routeToMaskingScreen()
        case .rateUs:
            router?.routeToAppleStore()
        case .support:
            interactor?.openMailClient(from: self)
        }
    }
    
    enum ScrollDirection {
        case up
        case down
        case none
        case start
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll called with contentOffset.y: \(scrollView.contentOffset.y)")
          
        if scrollView.contentOffset.y == -tableView.contentInset.top { return }
        
        if !didStartScrolling && scrollView.contentOffset.y > 0 {
            didStartScrolling = true
        }

        guard didStartScrolling else { return }

        let scrollDirection: ScrollDirection
        if lastContentOffset > scrollView.contentOffset.y + 10 {
            scrollDirection = .up
        } else if lastContentOffset < scrollView.contentOffset.y - 10 {
            scrollDirection = .down
        } else {
            scrollDirection = .none
        }

        if scrollDirection != .none {
            updateHeaderViewPosition(scrollDirection)
        }
        lastContentOffset = scrollView.contentOffset.y
    }

    func updateHeaderViewPosition(_ scrollDirection: ScrollDirection) {
        var newHeaderViewY: CGFloat?
        let yStart = statusBarHeight
        let yWhenScrolling = statusBarHeight
        
        switch scrollDirection {
        case .up:
            newHeaderViewY = yWhenScrolling
        case .down:
            newHeaderViewY = max(-floatingHeaderViewHeight, floatingHeaderView.frame.origin.y - abs(floatingHeaderViewHeight))
        case .none:
            newHeaderViewY = floatingHeaderView.frame.origin.y
        case .start:
            newHeaderViewY = yStart
        }
        if let newY = newHeaderViewY, newY != floatingHeaderView.frame.origin.y  {
            isAnimating = true
           
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.7,
                options: .curveEaseInOut,
                animations: {
                    self.floatingHeaderView.frame.origin.y = newY
                },
                completion: { _ in
                    self.isAnimating = false
                    print("Animation completed")
                }
            )
        } else {
            print("No animation triggered. Either Y did not change or animation is already running.")
        }
    }
}

// MARK: - enum SettingsRow
extension SettingsListViewController {
    enum SettingsRow: Int, CaseIterable {
        case masking
        case cameraTrap
        case fakePasscode
        case biometry
        case originalPasscode
        case shareApp
        case rateUs
        case support
        
        var title: String {
            switch self {
            case .masking:
                return R.string.localizedString.masking()
            case .cameraTrap:
                return R.string.localizedString.cameraTrap()
            case .fakePasscode:
                return R.string.localizedString.fakePasscode()
            case .biometry:
                return R.string.localizedString.biometry()
            case .originalPasscode:
                return R.string.localizedString.originalPasscode()
            case .shareApp:
                return R.string.localizedString.shareApp()
            case .rateUs:
                return R.string.localizedString.rateUs()
            case .support:
                return R.string.localizedString.support()
            }
        }
        
        var imageName: String {
            switch self {
            case .masking:
                return R.image.ic_masking.name
            case .cameraTrap:
                return R.image.ic_cameraTrap.name
            case .fakePasscode:
                return R.image.ic_face_passcode.name
            case .biometry:
                return R.image.ic_biometry.name
            case .originalPasscode:
                return R.image.ic_change_passcode.name
            case .shareApp:
                return R.image.ic_shareApp.name
            case .rateUs:
                return R.image.ic_rateUs.name
            case .support:
                return R.image.ic_support.name
            }
        }
    }
}
