import UIKit

protocol EditContactScreenDisplayLogic: AnyObject {
    func displayError(viewModel: EditContactScreen.Error.ViewModel)
    func displayCurrentData(viewModel: EditContactScreen.CurrentData.ViewModel)
    func displayUpdatedAvatar(viewModel: EditContactScreen.NewAvatar.ViewModel)
}

class EditContactScreenViewController: UIViewController {
    var interactor: EditContactScreenBusinessLogic?
    var router: (NSObjectProtocol & EditContactScreenRoutingLogic & EditContactScreenDataPassing)?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    private var selectedIndexPath: IndexPath?
    
    var name: String = ""
    var lastName: String?
    var phone: String = ""
    var email: String?
    var avatarImageData: Data?
    
    // MARK: - UIViews
    private var titleLabel = UILabel()
    private var saveButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)
    private let titleStackView = UIStackView()
    private var tableView = UITableView()
    private var roundViewBg = UIView()
    private lazy var imagePicker = ImagePickerCust()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        EditContactScreenConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayout()
        interactor?.getCurrentData()
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
        addKeyboardObserver(
            willShow: #selector(keyboardWillShow),
            willHide: #selector(keyboardWillHide)
        )
    }
    
    // MARK: - Func
    @objc func didTapCancel() {
        view.endEditing(true)
        router?.cancel()
    }
    
    @objc func didTapSave() {
        if isDataValid() {
            interactor?.updateСontact(name: name, lastName: lastName, phone: phone, imageData: avatarImageData, email: email) {
                self.router?.goBackAndReloadList()
            }
        }
    }
    
    func isDataValid() -> Bool {
        guard let cellName = tableView.cellForRow(at: IndexPath(row: 0, section: RowType.name.rawValue)) as? TextFieldCell else { return false }
        
        if cellName.isRequired && name.isEmpty {
            cellName.error(message: FileManagerError.nameIsEmpty.localizedDescription)
            tableView.beginUpdates()
            tableView.endUpdates()
            return false
        }

        guard let cellPhone = tableView.cellForRow(at: IndexPath(row: 0, section: RowType.phone.rawValue)) as? TextFieldCell else { return false }
        if cellPhone.isRequired && phone.isEmpty {
            cellPhone.error(message: FileManagerError.errorPhone.localizedDescription)
            tableView.beginUpdates()
            tableView.endUpdates()
            return false
        }
        return true
    }
}

// MARK: - Styles & Layout
extension EditContactScreenViewController {
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
        
        titleLabel.text = "Edit contact"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        
        tableView.register(cell: AvatarChoosingCell.self)
        tableView.register(cell: TextFieldCell.self)
        
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
            make.top.equalToSuperview().offset(24)
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
            make.top.equalTo(titleStackView.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(0)
        }
    }
}

// MARK: - EditContactScreenDisplayLogic
extension EditContactScreenViewController: EditContactScreenDisplayLogic {
    func displayUpdatedAvatar(viewModel: EditContactScreen.NewAvatar.ViewModel) {
        avatarImageData = viewModel.image
        let indexSet = IndexSet(integer: RowType.avatar.rawValue)
        tableView.reloadSections(indexSet, with: .automatic)
    }
    
    func displayError(viewModel: EditContactScreen.Error.ViewModel) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: RowType.name.rawValue)) as? TextFieldCell else { return }
        DispatchQueue.main.async {
            cell.error(message: viewModel.message)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func displayCurrentData(viewModel: EditContactScreen.CurrentData.ViewModel) {
        name = viewModel.name
        lastName = viewModel.lastName
        phone = viewModel.phone
        email = viewModel.email
        avatarImageData = viewModel.avatarImage
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension EditContactScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = RowType(rawValue: section) else { return 0 }
        switch section {
        case .name:
            return 0
        case .avatar:
            return 0
        case .lastname:
            return 0
        case .phone:
            return 0
        case .email:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = RowType(rawValue: section) else { return .zero }
        switch section {
        case .name:
            return 1
        case .avatar:
            return 1
        case .lastname:
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
            let cell = AvatarChoosingCell.get(from: tableView, at: indexPath)
            cell.setupCell(imageData: avatarImageData)
            cell.delegate = self
            return cell
        case .name:
            let cell = TextFieldCell.get(from: tableView, at: indexPath)
            cell.setupCell(dataType: .name, placeholder: section.placeholder(), currentText: name, isRequired: true)
            cell.delegate = self
            return cell
        case .lastname:
            let cell = TextFieldCell.get(from: tableView, at: indexPath)
            cell.setupCell(dataType: .lastName, placeholder: section.placeholder(), currentText: lastName)
            cell.delegate = self
            return cell
        case .phone:
            let cell = TextFieldCell.get(from: tableView, at: indexPath)
            cell.setupCell(dataType: .phone, placeholder: section.placeholder(), currentText: phone, isRequired: true)
            cell.delegate = self
            return cell
        case .email:
            let cell = TextFieldCell.get(from: tableView, at: indexPath)
            cell.setupCell(dataType: .email, placeholder: section.placeholder(), currentText: email)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension EditContactScreenViewController: UITableViewDelegate { }


extension EditContactScreenViewController: AvatarChoosingDelegate {
    func didTapAddPhoto() {
        self.imagePicker.showImagePickerVC(in: self, sourceType: .photoLibrary) { image, name, date in
            if let data = image.jpegData(compressionQuality: 1.0) {
                self.interactor?.updateAvatar(imageData: data)
            }
        }
    }
}

// MARK: - TextFieldCellDelegate
extension EditContactScreenViewController: TextFieldCellDelegate {
    func textFieldText(text: String, type: TypeTextFieldData) {
        switch type {
        case .name:
            name = text
        case .lastName:
            lastName = text
        case .phone:
            phone = text
        case .email:
            email = text
        default:
            break
        }
    }
    
}

// MARK: - Show/Hide Keyboard
private extension EditContactScreenViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
        if let selectedIndexPath = selectedIndexPath {
            tableView.scrollToRow(at: selectedIndexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.endEditing(true)
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
}

// MARK: - enum RowType
extension EditContactScreenViewController {
    enum RowType: Int, CaseIterable {
        case avatar
        case name
        case lastname
        case phone
        case email
        
        func placeholder() -> String {
            switch self {
            case .avatar:
                return "avatar"
            case .name:
                return "Name"
            case .lastname:
                return "Last name"
            case .phone:
                return "Phone"
            case .email:
                return "Email"
            }
        }
    }
}
