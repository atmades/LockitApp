import UIKit
import JGProgressHUD

protocol ContactsListDisplayLogic: AnyObject {
    func displayTitle(viewModel: ContactsList.Folder.ViewModel)
    func displayItems(viewModel: ContactsList.LoadContent.ViewModel)
    func updateMenu(viewModel: ContactsList.Menu.ViewModel)
}

class ContactsListViewController: UIViewController {
    var interactor: ContactsListBusinessLogic?
    var router: (NSObjectProtocol & ContactsListRoutingLogic & ContactsListDataPassing)?
    
    // MARK: - UI
    private lazy var hud = JGProgressHUD.light()
    private lazy var tableView = UITableView()
    
    private var lastContentOffset: CGFloat = 0
    private var statusBarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    }
    lazy var floatingHeaderViewHeight: CGFloat = 168
    lazy var floatingHeaderView: FloatingHeaderView = FloatingHeaderView(title: "Contacts")
    lazy var imagePicker = ImagePickerCust()
    
    var content: [ItemForPresent] = []
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        ContactsListConfigurator.sharedInstance.configure(viewController: self)
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
        setupNavigationBar()
        setupStyles()
        setupLayout()
        getTitle()
        loadContent()
        interactor?.printPath()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: interactor?.getNotificationIdentifier() ?? ""), object: nil) 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.pasteIsAviable()
//        loadContent()
    }
    
    // MARK: - Update UI
    
    @objc func handleNotification() {
        // Обработка уведомления
        print("Уведомление получено в контроллере")
        print("сча будет перезагруз NotesListVC")
        self.loadContent()
    }
    
    private func loadContent() {
        hud.show(in: self)
        interactor?.loadContent()
    }
    private func getTitle() {
        interactor?.getTitleName()
    }
    
    private func updateMenu(pasteIsAviable: Bool) {
        hud.show(in: self)
        let menu = setupCreateItemMenu(pasteIsAviable: pasteIsAviable)
        floatingHeaderView.showNewItemMenu(menu: menu)
    }
    
    // MARK: - Menu
    private func setupCreateItemMenu(pasteIsAviable: Bool) -> UIMenu {
        // addImageAction
        let addImageAction = UIAction(title: "Image", handler: { [weak self] _ in
            self?.imagePicker.showImagePickerVC(in: self ?? UIViewController(), sourceType: .photoLibrary) { image, name, date in
                print(name)
                if let data = image.jpegData(compressionQuality: 1.0) {
                    let uuid = UUID().uuidString
                    let itemForSave = ImageForSave(uuid: uuid, creationDate: Date(), imageData: data)
                    self?.interactor?.saveFile(file: itemForSave, name: name)
                    self?.interactor?.loadContent()
                }
            }
        })
        
        // addFolderAction
        let addFolderAction = UIAction(title: "Folder", handler: { [weak self] _ in
            self?.router?.routeToCreateFolderScreen()
        })
        
        // addFolderAction
        let addContactAction = UIAction(title: "Contact", handler: { [weak self] _ in
            self?.router?.routeToCreateContactScreen()
        })
        
        // addFolderAction
        let pasteAction = UIAction(title: "Paste", handler: { [weak self] _ in
            print("Paste")
            self?.interactor?.pasteCopied()
        })
        
        if !pasteIsAviable {
            pasteAction.attributes = [.disabled]
        }
        
        // addFolderAction
        let deleteAllAction = UIAction(title: "Delete All", handler: {  _ in
            print("Delete All")
            FileManagerNEW().removeAll()
        })
        
        let menu = UIMenu(title: "", children: [
            addFolderAction,
            addContactAction,
            pasteAction,
            deleteAllAction,
        ])
        return menu
    }
}

//  MARK: - ext ContactsListDisplayLogic
extension ContactsListViewController: ContactsListDisplayLogic {
    func updateMenu(viewModel: ContactsList.Menu.ViewModel) {
        updateMenu(pasteIsAviable: viewModel.pasteIsAviable)
        hud.dismiss(animated: true)
    }
    
    func displayTitle(viewModel: ContactsList.Folder.ViewModel) {
        floatingHeaderView.configure(title: viewModel.folderName, counterVC: viewModel.counterVC)
    }
    
    func displayItems(viewModel: ContactsList.LoadContent.ViewModel) {
        content = viewModel.items
        //        content.sort{ $0.creationDate > $1.creationDate }
        tableView.reloadData()
        hud.dismiss(animated: true)
    }
}

//  MARK: - style & layout
private extension ContactsListViewController {
    func setupStyles() {
        view.backgroundColor = .black
        view.addGlow()
        
        tableView.register(cell: ContactCell.self)
        tableView.register(cell: FolderCell.self)
        tableView.setAutoDimension()
        tableView.setup(target: self)
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 160, left: 0, bottom: 130, right: 0)
        
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

//  MARK: - FloatingHeaderViewBackDelegate
extension ContactsListViewController: FloatingHeaderViewBackDelegate {
    func didTabBack1() {
        print(#function)
        router?.routeToBack()
    }
}

//  MARK: - FloatingHeaderViewSortDelegate
extension ContactsListViewController: FloatingHeaderViewSortDelegate {
    func didTapChangeSort1(sort: SortType) {
        
    }
}


//  MARK: - UITableViewDataSource
extension ContactsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("contact.count: \(content.count)")
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = content[indexPath.row]
        
        let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self else { return }
            self.interactor?.copy(url: item.path, type: item.type)
            self.interactor?.pasteIsAviable()
        }
        
        let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self else { return }
            self.interactor?.selectFolderForRename(request: ContactsList.SelectFolderForRename.Request(item: item))
            self.router?.routeToRenameScreen()
        }
        
        let editContactAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self else { return }
            self.interactor?.selectConactForEdit(request: ContactsList.SelectContactForEdit.Request(item: item))
            self.router?.routeToEditScreen()
        }
        
        switch item.type {
        case .file:
            let cell = ContactCell.get(from: tableView, at: indexPath)
//            cell.iconImageView.image = nil
            cell.setupCell(item: item)
            
            cell.setupMenu(actions: [editContactAction, copyAction])
            print(item.name)
            return cell
        case .folder:
            let cell = FolderCell.get(from: tableView, at: indexPath)
            cell.setupCell(item: item, root: .contacts)
            cell.setupMenu(actions: [renameAction, copyAction])
            return cell
        }
    }
}

//  MARK: - UITableViewDelegate
extension ContactsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            return // Игнорируем тапы на ячейки в режиме редактирования
        }
        
        let item = content[indexPath.row]
        if item.type == .folder {
            self.interactor?.selectFolderForRoute(request: ContactsList.SelectFolderForRoute.Request(folderNameForRoute: item.name))
            print("сча будет переход в папку:")
            self.router?.routeToSubList()
        } else if item.type == .file {
            self.interactor?.selectConactForEdit(request: ContactsList.SelectContactForEdit.Request(item: item))
            self.router?.routeToContactScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let item = self.content[indexPath.row]
            self.interactor?.remove(item: item)
            self.interactor?.pasteIsAviable()
            self.content.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .red
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    enum ScrollDirection {
        case up
        case down
        case none
        case start
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDirection: ScrollDirection

        if lastContentOffset <= 0  {
            scrollDirection = .start
        } else if lastContentOffset > (scrollView.contentOffset.y + 1) {
            scrollDirection = .up
        }
        else if lastContentOffset < (scrollView.contentOffset.y - 1) {
            scrollDirection = .down
        } else {
            scrollDirection = .none
        }
        updateHeaderViewPosition(scrollDirection)
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

        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.7,
            options: .curveEaseInOut,
            animations: {
                self.floatingHeaderView.frame.origin.y = newHeaderViewY ?? 0
            },
            completion: nil
        )
    }
}



