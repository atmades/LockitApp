import UIKit
import JGProgressHUD

protocol ContactScreenDisplayLogic: AnyObject {
    func displayContactData(viewModel: ContactScreen.ContactData.ViewModel)
    func displaySharing(viewModel: ContactScreen.ShareData.ViewModel)
    func displayAlertSavedContact(viewModel: ContactScreen.Saved.ViewModel)
}

class ContactScreenViewController: UIViewController {
    var interactor: ContactScreenBusinessLogic?
    var router: (NSObjectProtocol & ContactScreenRoutingLogic & ContactScreenDataPassing)?
    
    var avatar: Data?
    var fullName = ""
    var firstName = ""
    var lastName = ""
    var phone = ""
    var email: String?
    
    // MARK: - UI
    private lazy var hud = JGProgressHUD.light()
    private lazy var tableView = UITableView()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        ContactScreenConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print(#function)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayout()
        setupNavigationBar()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        loadContent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name(rawValue: interactor?.getNotificationIdentifier() ?? ""), object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        // Обработка уведомления
        if let object = notification.object as? String {
            interactor?.updateName(name: object)
          } else {
              print("No object received")
          }

    }
    
    private func loadContent() {
        hud.show(in: self)
        interactor?.loadContent()
    }
    
    let contactsManager = ContactsManager()
}

// MARK: - Styles & Layout
private extension ContactScreenViewController {
    func setupStyles() {
        view.backgroundColor = .black
        view.addGlow()
        
        tableView.register(cell: ContactAvatarCell.self)
        tableView.register(cell: ContactDataCell.self)
        tableView.setAutoDimension()
        tableView.setup(target: self)
        tableView.backgroundColor = .clear
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        let backButton = UIButton()
        backButton.setImage(R.image.ico_arrow_back(), for: .init())
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let editButton = UIButton()
        editButton.setImage(R.image.ico_edit(), for: .init())
        editButton.addTarget(self, action: #selector(editHandler), for: .touchUpInside)
        
        let shareButton = UIButton()
        shareButton.setImage(R.image.ico_share(), for: .init())
        shareButton.addTarget(self, action: #selector(shareHandler), for: .touchUpInside)
        
        let saveButton = UIButton()
        saveButton.setImage(R.image.ico_saveToBook(), for: .init())
        saveButton.addTarget(self, action: #selector(saveToPhoneBookHandler), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: editButton),
                                              UIBarButtonItem(customView: shareButton),
                                              UIBarButtonItem(customView: saveButton) ]
    }
    
    @objc func backButtonDidTap() {
        router?.routeToBack()
    }
    
    @objc func editHandler() {
        router?.routeToEditScreen()
    }
    
    @objc func shareHandler() {
        interactor?.shareContact()
    }
    
    @objc func saveToPhoneBookHandler() {
        let contact = ContactPhoneBook(name: fullName, number: phone,email: email, image: avatar)
        Alerts.confirmation(
            controller: self,
            title: "Подтверждение",
            message: "Вы уверены, что хотите выполнить это действие?",
            confirmAction: {
                self.saveContactToPhoneBook(contact: contact)
            }
        )
    }
    
    func saveContactToPhoneBook(contact: ContactPhoneBook) {
        contactsManager.saveContactToPhoneBook(contact: contact) { success, error in
            if success {
                Alerts.simpleAlert(
                     controller: self,
                     title: "Уведомление",
                     message: "Действие выполнено успешно"
                 )
            } else if let error = error {
                print("Ошибка сохранения контакта: \(error.localizedDescription)")
            }
        }
    }
}

//  MARK: - UITableViewDataSource
extension ContactScreenViewController: ContactScreenDisplayLogic {
    func displayContactData(viewModel: ContactScreen.ContactData.ViewModel) {
        avatar = viewModel.avatar
        fullName = viewModel.name
        phone = viewModel.phone
        email = viewModel.mail
        tableView.reloadData()
        hud.dismiss(animated: true)
    }
    
    func displaySharing(viewModel: ContactScreen.ShareData.ViewModel) {
        let activityViewController = UIActivityViewController(activityItems: [viewModel.vCard], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func displayAlertSavedContact(viewModel: ContactScreen.Saved.ViewModel) {
        Alerts.simpleAlert(
             controller: self,
             title: viewModel.title,
             message: viewModel.message
         )
    }
}

//  MARK: - UITableViewDataSource
extension ContactScreenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = RowType(rawValue: section) else { return .zero }
        switch section {
        case .avatar:
            return 1
        case .phone:
            return 1
        case .email:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = RowType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .avatar:
            let cell = ContactAvatarCell.get(from: tableView, at: indexPath)
            cell.setupCell(imageData: avatar, name: fullName)
            return cell
        case .phone:
            let cell = ContactDataCell.get(from: tableView, at: indexPath)
            cell.setupCell(contact: phone, dataType: .phone)
            cell.delegate = self
            return cell
        case .email:
            let cell = ContactDataCell.get(from: tableView, at: indexPath)
            cell.setupCell(contact: email, dataType: .email)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ContactScreenViewController: UITableViewDelegate { }

// MARK: - ContactDataProtocol
extension ContactScreenViewController: ContactDataProtocol {
    func didTapRightRightButton(type: ContactData) {
        switch type {
        case .phone:
            interactor?.call()
        case .email:
            interactor?.sendEmail()
        }
    }
    
    func didTapRightButton(type: ContactData) {
        switch type {
        case .phone:
            interactor?.call()
        case .email:
            interactor?.sendEmail()
        }
    }
    
    func didtapleftButton(type: ContactData) {
        switch type {
        case .phone:
            interactor?.copyContactDataToClipboard(contactInfo: phone)
        case .email:
            interactor?.copyContactDataToClipboard(contactInfo: email)
        }
    }
}

// MARK: - enum RowType
extension ContactScreenViewController {
    enum RowType: Int, CaseIterable {
        case avatar
        case phone
        case email
    }
}
