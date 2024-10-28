import UIKit
import JGProgressHUD
import CoreTelephony

protocol FilesListDisplayLogic: AnyObject {
    func displayError(viewModel: FilesList.Error.ViewModel)
    func displayTitle(viewModel: FilesList.Folder.ViewModel)
    func displayItems(viewModel: FilesList.LoadContent.ViewModel)
    func updateMenu(viewModel: FilesList.Menu.ViewModel)
    func displayAlertForDownload(viewModel: FilesList.ClipBoardForPDF.ViewModel)
    func displayDownloaded(viewModel: FilesList.Downloaded.ViewModel)
}

class FilesListViewController: UIViewController {
    var interactor: FilesListBusinessLogic?
    var router: (NSObjectProtocol & FilesListRoutingLogic & FilesListDataPassing)?
    var pdfURL: URL!
    
    // MARK: - UI
    private lazy var hud = JGProgressHUD.light()
    private lazy var tableView = UITableView()
    
    private var lastContentOffset: CGFloat = 0
    private var statusBarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    }
    lazy var floatingHeaderViewHeight: CGFloat = 168
    lazy var floatingHeaderView: FloatingHeaderView = FloatingHeaderView(title: "File")
    lazy var imagePicker = ImagePickerCust()

    var content: [ItemForPresent] = []
    
    var isContentLoaded = false
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        print("init FilesListViewController")
        FilesListConfigurator.sharedInstance.configure(viewController: self)
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
        print("сча будет перезагруз FiledListVC")
        self.loadContent()
    }
    
    private func loadContent() {
        print(#function)
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
    
    // MARK: - setup Menu
    private func setupCreateItemMenu(pasteIsAviable: Bool) -> UIMenu {
        // addImageAction
        let addImageAction = UIAction(title: "Image from Gallery", handler: { [weak self] _ in
            self?.imagePicker.showImagePickerVC(in: self ?? UIViewController(), sourceType: .photoLibrary) { image, name, date in
                if let data = image.jpegData(compressionQuality: 0.6) {
                    let uuid = UUID().uuidString
                    let itemForSave = ImageForSave(uuid: uuid, creationDate: Date(), imageData: data)
                    self?.interactor?.saveFile(file: itemForSave, name: name)
                    self?.interactor?.loadContent()
                }
            }
        })
        
        let addImageFromCameraAction = UIAction(title: "Open Camera", handler: { [weak self] _ in
            self?.imagePicker.showImagePickerVC(in: self ?? UIViewController(), sourceType: .camera) { image, name, date in
                let fixedImage = image.fixOrientation() 
                if let data = fixedImage.jpegData(compressionQuality: 0.6) {
                    let uuid = UUID().uuidString
                    let itemForSave = ImageForSave(uuid: uuid, creationDate: Date(), imageData: data)
                    self?.interactor?.saveFile(file: itemForSave, name: name)
                    self?.interactor?.loadContent()
                }
            }
        })
        
        let downloadPDFAction = UIAction(title: "download PDF", handler: { [weak self] _ in
            guard let self = self  else { return }
            self.didTapDownloadFromLink()
        })
        
        let addCreatePdfFromPhotoAction = UIAction(title: "Create Pdf", handler: { [weak self] _ in
            self?.router?.routeToCreatePdfFromPhotoScreen()
        })
        
        let addFolderAction = UIAction(title: "Folder", handler: { [weak self] _ in
            self?.router?.routeToCreateFolderScreen()
        })
        
        let pasteAction = UIAction(title: "Paste", handler: { [weak self] _ in
            print("Paste")
            self?.interactor?.pasteCopied()
        })
        
        if !pasteIsAviable {
            pasteAction.attributes = [.disabled]
        }
        
        let deleteAllAction = UIAction(title: "Delete All", handler: { _ in
            print("Delete All")
            FileManagerNEW().removeAll()
        })
        
        let menu = UIMenu(title: "", children: [
            addCreatePdfFromPhotoAction,
            addImageAction,
            addImageFromCameraAction,
            downloadPDFAction,
//            addPDFPerLinkAction,
            addFolderAction,
            pasteAction,
            deleteAllAction,
        ])
        return menu
    }
    
    @objc func didTapDownloadFromLink() {
//        let urlString = "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let urlString = ""
        Alerts.confirmationWithMultilineInput(controller: self, title: "Введите данные", message: "Вставьте ссылку на документ", defaultInput: urlString) { input in
            guard let text = input, !text.isEmpty else {
                print("Поле ввода пустое")
                self.hud.dismiss()
                Alerts.error(controller: self, message: "Поле ввода пустое")
                return
            }
            self.interactor?.downloadPdf(urlString: text)
        }
    }
}

// MARK: - DisplayLogic
extension FilesListViewController: FilesListDisplayLogic {
    
    func displayError(viewModel: FilesList.Error.ViewModel) {
        Alerts.error(controller: self, message: viewModel.message)
    }
    
    func updateMenu(viewModel: FilesList.Menu.ViewModel) {
        updateMenu(pasteIsAviable: viewModel.pasteIsAviable)
        hud.dismiss(animated: true)
    }
    
    func displayTitle(viewModel: FilesList.Folder.ViewModel) {
        floatingHeaderView.configure(title: viewModel.folderName, counterVC: viewModel.counterVC)
    }
    
    func displayItems(viewModel: FilesList.LoadContent.ViewModel) {
        content = viewModel.items
        tableView.reloadData()
        hud.dismiss(animated: true)
    }
    
    func displayDownloaded(viewModel: FilesList.Downloaded.ViewModel) {
        router?.routeToDownloadFileScreen()
        hud.dismiss(animated: true)
    }
    
    func displayAlertForDownload(viewModel: FilesList.ClipBoardForPDF.ViewModel) {
//        "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let urlString = viewModel.urlString
        
        Alerts.confirmationWithMultilineInput(controller: self, title: "Введите данные", message: "Вставьте ссылку на документ", defaultInput: urlString) { input in
            guard let text = input, !text.isEmpty else {
                print("Поле ввода пустое")
                self.hud.dismiss()
                Alerts.error(controller: self, message: "Поле ввода пустое")
                return
            }
            print("Введенные данные: \(text)")
            self.interactor?.downloadPdf(urlString: text)
        }
    }
}

// MARK: - layout & styles
private extension FilesListViewController {
    func setupStyles() {
        view.backgroundColor = .black
        view.addGlow()
        
        tableView.register(cell: ImageCell.self)
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

//  MARK: - extension DataSource
extension FilesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("files.count: \(content.count)")
//        print("files.count: \(content.count), called from:", Thread.callStackSymbols)
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
            self.interactor?.selectItemForEdit(request: FilesList.SelectItem.Request(item: item))
            self.router?.routeToRenameScreen()
        }
        
        switch item.type {
        case .file:
            let cell = ImageCell.get(from: tableView, at: indexPath)
            cell.setupCell(item: item)
            cell.setupMenu(actions: [renameAction, copyAction])
            return cell
        case .folder:
            let cell = FolderCell.get(from: tableView, at: indexPath)
            cell.setupCell(item: item, root: .files)
            cell.setupMenu(actions: [renameAction, copyAction])
            return cell
        }
    }
}

//  MARK: - FloatingHeaderViewBackDelegate
extension FilesListViewController: FloatingHeaderViewBackDelegate {
    func didTabBack1() {
        print(#function)
        router?.routeToBack()
    }
}

//  MARK: - FloatingHeaderViewSortDelegate
extension FilesListViewController: FloatingHeaderViewSortDelegate {
    func didTapChangeSort1(sort: SortType) {
        self.interactor?.changeSort(selectSort: FilesList.SelectSort.Request(selectSort: sort))
    }
}

//  MARK: - UITableViewDelegate
extension FilesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = content[indexPath.row]
        if item.type == .folder {
            self.interactor?.selectFolderForRoute(request: FilesList.SelectFolderForRoute.Request(folderNameForRoute: item.name))
            self.router?.routeToSubList()
        } else {
            if let _ = item.item as? ImageForSave {
                interactor?.prepareImageGallery(request: FilesList.Images.Request(items: content, name: item.name)) {
                    self.router?.routeToImageScreen()
                }
            } else
            if let _ = item.item as? PdfForSave {
                self.interactor?.selectItemForEdit(request: FilesList.SelectItem.Request(item: item))
                self.router?.routeToDocumentScreen()
            }
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
