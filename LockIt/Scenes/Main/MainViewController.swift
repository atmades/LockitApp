import UIKit
import PDFKit

protocol MainDisplayLogic: AnyObject { }

class MainViewController: UIViewController {
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    
    private lazy var filesVC: UIViewController = {
        return router?.getFilesVC() ?? UIViewController()
    }()
    private lazy var contactsVC: UIViewController = {
        return router?.getContactsVC() ?? UIViewController()
    }()
    private lazy var notesVC: UIViewController = {
        return router?.getNotesVC() ?? UIViewController()
    }()
    private lazy var settingsVC: UIViewController = {
        return router?.getSettingsVC() ?? UIViewController()
    }()
    
    private var viewControllers: [UIViewController] = []
    private var selectedTab: Int? = nil {
        didSet {
            guard selectedTab != oldValue, let selectedTab = selectedTab else { return }
            if let oldValue = oldValue {
                self.remove(self.viewControllers[oldValue])
            }
            self.add(viewControllers[selectedTab])
        }
    }

    // MARK: - UIView
    private let tabView = TabbarView()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        MainConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayout()
        setupUI()
    }
    
    // MARK: - Setup ViwControlers
    private func setupUI() {
        generateTabBar()
        selectedTab = 0
        tabView.startApp(tag: 0)
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateNavigationController(rootViewController: filesVC),
            generateNavigationController(rootViewController: contactsVC),
            generateNavigationController(rootViewController: notesVC),
            generateNavigationController(rootViewController: settingsVC)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        return navigationVC
    }
    
    func showPDFScreen(with url: URL) {
        let pdfData = try? Data(contentsOf: url)
        let pdfName = url.lastPathComponent
        
        let downloadFileScreenVC = DownloadFileScreenViewController()
        downloadFileScreenVC.pdfData = pdfData ?? Data()
        downloadFileScreenVC.pdfName = pdfName
        present(downloadFileScreenVC, animated: true, completion: nil)
    }
    
    // MARK: - PDF Viewing
    func showPDFScreen(with pdfData: Data, pdfName: String) {
        router?.routeToPDFScreen(pdfData: pdfData, pdfName: pdfName)
    }
}

//    MARK: - Setup Layout & Styles
extension MainViewController {
    func setupStyles() {
        view.backgroundColor = .black
        tabView.delegate = self
    }
    func setupLayout() {
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainViewController: MainDisplayLogic {}

//    MARK: - TabbarViewDelegate
extension MainViewController: TabbarViewDelegate {
    func didTapButton(tag: Int) {
        selectedTab = tag
    }
}
