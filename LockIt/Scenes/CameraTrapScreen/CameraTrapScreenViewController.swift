import UIKit

protocol CameraTrapScreenDisplayLogic: AnyObject {
}

class CameraTrapScreenViewController: UIViewController {
    var interactor: CameraTrapScreenBusinessLogic?
    var router: (NSObjectProtocol & CameraTrapScreenRoutingLogic & CameraTrapScreenDataPassing)?
    
    // MARK: - UIViews
    private var titleLabel = UILabel()
    private var saveButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)
    private let titleStackView = UIStackView()
    private lazy var tableView = UITableView()
    private var roundViewBg = UIView()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        CameraTrapScreenConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayout()
    }
}

extension CameraTrapScreenViewController {
    // MARK: - Styles & Layout
    private func setupStyles() {
        
        view.backgroundColor = .clear
        
        roundViewBg.layer.cornerRadius = 50
        roundViewBg.layer.masksToBounds = true
        roundViewBg.addBlur()
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.contentHorizontalAlignment = .right
        saveButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        titleLabel.text = "Camera Trap"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.register(cell: SwitcherCell.self)
        tableView.setAutoDimension()
        tableView.setup(target: self)
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
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
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
        
        roundViewBg.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(32)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(500)
        }
    }
}

// MARK: - DisplayLogic
extension CameraTrapScreenViewController: CameraTrapScreenDisplayLogic { }

// MARK: - UITableViewDataSource
extension CameraTrapScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwitcherCell.get(from: tableView, at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CameraTrapScreenViewController: UITableViewDelegate { }
