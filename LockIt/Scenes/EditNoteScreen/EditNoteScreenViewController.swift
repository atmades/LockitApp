import UIKit

protocol EditNoteScreenDisplayLogic: AnyObject {
    func displayError(viewModel: EditNoteScreen.Error.ViewModel)
    func displayCurrentData(viewModel: EditNoteScreen.CurrentData.ViewModel)
}

class EditNoteScreenViewController: UIViewController {
    var interactor: EditNoteScreenBusinessLogic?
    var router: (NSObjectProtocol & EditNoteScreenRoutingLogic & EditNoteScreenDataPassing)?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    var name: String = ""
    var textNote: String?
    private var selectedIndexPath: IndexPath?
    
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
        EditNoteScreenConfigurator.sharedInstance.configure(viewController: self)
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
        interactor?.getCurrentData()
        setupStyles()
        setupLayout()
        
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
        print(#function)
        if isDataValid() {
            print("isDataValid = true")
            interactor?.save(name: name, textNote: textNote) {
                self.router?.goBackAndReloadList()
            }
        } else {
            print("isDataValid = false")
        }
    }
    
    func isDataValid() -> Bool {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: RowType.name.rawValue)) as? TextFieldCell else { return false }
        
        if cell.isRequired && name.isEmpty {
            cell.error(message: FileManagerError.nameIsEmpty.localizedDescription)
            tableView.beginUpdates()
            tableView.endUpdates()
            return false
        }
        return true
    }
}

// MARK: - Styles & Layout
extension EditNoteScreenViewController {
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
        
        titleLabel.text = ""
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.register(cell: TextFieldCell.self)
        tableView.register(cell: TextViewCell.self)
        
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
//            make.width.equalTo(72)
            make.height.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
//            make.width.equalTo(72)
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

// MARK: - EditNoteScreenDisplayLogic
extension EditNoteScreenViewController: EditNoteScreenDisplayLogic {
    func displayCurrentData(viewModel: EditNoteScreen.CurrentData.ViewModel) {
        if let name = viewModel.name {
            self.name = name
        }
        textNote = viewModel.textNote
    }
    
    func displayError(viewModel: EditNoteScreen.Error.ViewModel) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: RowType.name.rawValue)) as? TextFieldCell else { return }
        DispatchQueue.main.async {
            cell.error(message: viewModel.message)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

extension EditNoteScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = RowType(rawValue: section) else { return 0 }
        switch section {
        case .name:
            return 0
        case .text:
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
        case .text:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = RowType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .name:
            let cell = TextFieldCell.get(from: tableView, at: indexPath)
            cell.placeholder = section.placeholder()
            cell.setupKeyboard(type: .text)
            print(name)
            cell.currentText = name
            cell.isRequired = true
//            cell.isFocused()
            cell.delegate = self
            
            return cell
        case .text:
            let cell = TextViewCell.get(from: tableView, at: indexPath)
            cell.placeholder = section.placeholder()
            cell.currentText = textNote
//            cell.setupCell(type: .text)
//            cell.isRequired = true
//            cell.isFocused()
            cell.delegate = self
            
            return cell
        }
    }
}

extension EditNoteScreenViewController: UITableViewDelegate { }

extension EditNoteScreenViewController: TextFieldCellDelegate {
    func textFieldText(text: String, type: TypeTextFieldData) {
        switch type {
        case .text:
            name = text
        default:
            break
        }
    }
}

// MARK: - TextViewCellDelegate
extension EditNoteScreenViewController: TextViewCellDelegate {
    func updateCellHeight(_ cell: TextViewCell) {
        if let _ = tableView.indexPath(for: cell) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func textViewDidBeginEditing(_ cell: TextViewCell) {
        selectedIndexPath = tableView.indexPath(for: cell)
    }
    
    func textViewDidEndEditing(_ cell: TextViewCell) {
        selectedIndexPath = nil
    }
    
    func textDidSet(_ text: String) {
        textNote = text
        print(textNote)
    }
}

// MARK: - Show/Hide Keyboard
private extension EditNoteScreenViewController {
    
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
extension EditNoteScreenViewController {
    enum RowType: Int, CaseIterable {
        case name
        case text
        
        func placeholder() -> String {
            switch self {
            case .name:
                return "Enter title"
            case .text:
                return "Enter text"
            }
        }
    }
}
