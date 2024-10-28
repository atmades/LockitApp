import UIKit
import JGProgressHUD

protocol NotesListDisplayLogic: AnyObject {
    func displayTitle(viewModel: NotesList.Folder.ViewModel)
    func displayItems(viewModel: NotesList.LoadContent.ViewModel)
    func updateMenu(viewModel: NotesList.Menu.ViewModel)
}

class NotesListViewController: UIViewController {
    var interactor: NotesListBusinessLogic?
    var router: (NSObjectProtocol & NotesListRoutingLogic & NotesListDataPassing)?
    
    // MARK: - UI
    private lazy var hud = JGProgressHUD.light()
    private lazy var tableView = UITableView()
    
    private var lastContentOffset: CGFloat = 0
    private var statusBarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    }
    lazy var floatingHeaderViewHeight: CGFloat = 168
    lazy var floatingHeaderView: FloatingHeaderView = FloatingHeaderView(title: "Notes")
    lazy var imagePicker = ImagePickerCust()
    private let notificationIdentifier: String = UUID().uuidString
    
    var content: [ItemForPresent] = []

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        NotesListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupStyles()
        setupLayout()
        setTitle()
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
    
    deinit {
        print(#function)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadContent() {
        hud.show(in: self)
        interactor?.loadContent()
    }
    
    private func setTitle() {
        interactor?.getTitleName()
    }
    
    private func updateMenu(pasteIsAviable: Bool) {
        hud.show(in: self)
        let menu = setupCreateItemMenu(pasteIsAviable: pasteIsAviable)
        floatingHeaderView.showNewItemMenu(menu: menu)
    }
    
    private func setupCreateItemMenu(pasteIsAviable: Bool) -> UIMenu {
        // addFolderAction
        let addNoteAction = UIAction(title: "Note", handler: { [weak self] _ in
            self?.router?.routeToCreateNoteScreen()
        })
        
        // addFolderAction
        let addFolderAction = UIAction(title: "Folder", handler: { [weak self] _ in
            self?.router?.routeToCreateFolderScreen()
        })
        
        // pasteAction
        let pasteAction = UIAction(title: "Paste", handler: { [weak self] _ in
            self?.interactor?.pasteCopied()
        })
        
        if !pasteIsAviable {
            pasteAction.attributes = [.disabled]
        }
        
        // addFolderAction
        let deleteAllAction = UIAction(title: "Delete All", handler: { _ in
            print("Delete All")
            FileManagerNEW().removeAll()
        })
        
        let menu = UIMenu(title: "", children: [
            addNoteAction,
            addFolderAction,
            pasteAction,
            deleteAllAction,
        ])
        return menu
    }
}

// MARK: - Setup Layout & Styles
private extension NotesListViewController {
    func setupStyles() {
        view.backgroundColor = .black
        view.addGlow()
        
        tableView.register(cell: NoteCell.self)
        tableView.register(cell: FolderCell.self)
        tableView.setAutoDimension()
        tableView.setup(target: self)
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 170, left: 0, bottom: 130, right: 0)
        
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

// MARK: - NotesListDisplayLogic
extension NotesListViewController: NotesListDisplayLogic {
    func updateMenu(viewModel: NotesList.Menu.ViewModel) {
        updateMenu(pasteIsAviable: viewModel.pasteIsAviable)
        hud.dismiss(animated: true)
    }
    
    func displayTitle(viewModel: NotesList.Folder.ViewModel) {
        floatingHeaderView.configure(title: viewModel.folderName, counterVC: viewModel.counterVC)
    }
    
    func displayItems(viewModel: NotesList.LoadContent.ViewModel) {
        content = viewModel.items
        tableView.reloadData()
        hud.dismiss(animated: true)
    }
}

//  MARK: - FloatingHeaderViewBackDelegate
extension NotesListViewController: FloatingHeaderViewBackDelegate {
    func didTabBack1() {
        print(#function)
        router?.routeToBack()
    }
}

//  MARK: - FloatingHeaderViewSortDelegate
extension NotesListViewController: FloatingHeaderViewSortDelegate {
    func didTapChangeSort1(sort: SortType) {
        self.interactor?.changeSort(selectSort: NotesList.SelectSort.Request(selectSort: sort))
    }
}

//  MARK: - extension UITableViewDataSource
extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("notes.count: \(content.count)")
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = content[indexPath.row]
        
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { [weak self] action in
                guard let self = self else { return }
                self.interactor?.selectItemForEdit(request: NotesList.SelectItem.Request(item: item))
                self.router?.routeToRenameScreen()
            },
            UIAction(title: "Copy", image: UIImage(systemName: "pencil")) { [weak self] action in
                guard let self = self else { return }
                self.interactor?.copy(url: item.path, type: item.type)
                self.interactor?.pasteIsAviable()
            },
            UIAction(title: "Delete", image: UIImage(systemName: "folder")) { [weak self] action in
            }
        ])
        
        switch item.type {
        case .file:
            let cell = NoteCell.get(from: tableView, at: indexPath)
            cell.setupCell(item: item)
            cell.showContextMenu(menu: menu)
            return cell
        case .folder:
            let cell = FolderCell.get(from: tableView, at: indexPath)
            cell.setupCell(item: item, root: .notes)
            cell.showContextMenu(menu: menu)
            return cell
        }
  
    }
}


//  MARK: - UITableViewDelegate
extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return // Игнорируем тапы на ячейки в режиме редактирования
        }
        let item = content[indexPath.row]
        
        switch item.type {
        case .file:
            print("сча будет открыт файл")
            self.interactor?.selectItemForEdit(request: NotesList.SelectItem.Request(item: item))
            self.router?.routeToEditNoteScreen()
            
        case .folder:
            self.interactor?.selectFolderForRoute(request: NotesList.SelectFolderForRoute.Request(folderNameForRoute: item.name))
            print("сча будет переход в папку:")
            self.router?.routeToSubList()
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
    
    //  MARK: - Animation
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
