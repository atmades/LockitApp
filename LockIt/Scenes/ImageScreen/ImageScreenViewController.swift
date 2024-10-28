import UIKit

protocol ImageScreenDisplayLogic: AnyObject {
    func displayItems(viewModel: ImageScreen.LoadContent.ViewModel)
    func displaySharing(viewModel: ImageScreen.Share.ViewModel)
}

class ImageScreenViewController: UIViewController {
    var interactor: ImageScreenBusinessLogic?
    var router: (NSObjectProtocol & ImageScreenRoutingLogic & ImageScreenDataPassing)?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    var content: [ItemForPresent] = []
    var indexForStart = 0
    var currentIndex = 0
    lazy var currentItem = content[indexForStart]
    
    // MARK: - UI
    private var imageView: ImageScrollView!
    
    private var titleLabel = UILabel()
    private var shareButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)
    private let titleStackView = UIStackView()
    private var roundViewBg = UIView()
    
    private var nextButton = UIButton(type: .system)
    private var previewButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        ImageScreenConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print(#function)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        imageView = ImageScrollView(frame: view.bounds)
        setupLayout()
        loadContent()
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        previewButton.addTarget(self, action: #selector(didTapPreview), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        imageView.addGestureRecognizer(swipeLeftGesture)

        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        imageView.addGestureRecognizer(swipeRightGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func didTapCancel() {
        print(#function)
        router?.routeToBack()
    }
    
    @objc func didTapShare() {
        print(#function)
        interactor?.shareImage(index: currentIndex)
    }
    
    func loadContent() {
        interactor?.loadContent()
    }
    
    private func updateUI() {
        guard let imageItem = content[indexForStart].item as? ImageForSave else { return }

        if let image = UIImage(data: imageItem.imageData) {
            imageView.set(image: image)
        }
    }
    
    @objc func didTapPreview() {
        showPreviousImage()
    }
    
    @objc func didTapNext() {
        showNextImage()
        if currentIndex == content.count - 1 {

        }
    }
    
    // Sliding
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            showNextImage()
        } else if sender.direction == .right {
            showPreviousImage()
        }
    }

    private func showNextImage() {
        let nextIndex = currentIndex + 1
        if nextIndex < content.count {
            currentItem = content[nextIndex]
            currentIndex = nextIndex
            guard let imageItem = currentItem.item as? ImageForSave else { return }
            guard let image = UIImage(data: imageItem.imageData) else { return }
            animation(image: image)
        }
    }
   private func showPreviousImage() {
        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            currentItem = content[previousIndex]
            currentIndex = previousIndex
            guard let imageItem = currentItem.item as? ImageForSave else { return }
            guard let image = UIImage(data: imageItem.imageData) else { return }
            animation(image: image)
        }
    }
    
    private func animation(image: UIImage) {
        imageView.alpha = 0.0
        self.imageView.set(image: image)
        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = 1.0
        }
    }
    
}
// MARK: - styles & layout
extension ImageScreenViewController {
    private func setupStyles() {
        view.backgroundColor = .clear
        
        roundViewBg.layer.cornerRadius = 50
        roundViewBg.layer.masksToBounds = true
        roundViewBg.addBlur()
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.contentHorizontalAlignment = .right
        shareButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        titleLabel.text = "Images"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 4
        
        previewButton.setTitle("Preview", for: .normal)
        previewButton.apply(settings: Styles.Buttons.NextPrevievsText.controlSettings)
        let cornersP: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        previewButton.layer.cornerRadius = 22
        previewButton.layer.maskedCorners = cornersP
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.apply(settings: Styles.Buttons.NextPrevievsText.controlSettings)
        let cornersN: CACornerMask = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        nextButton.layer.cornerRadius = 22
        nextButton.layer.maskedCorners = cornersN
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
        titleStackView.addArrangedSubview(shareButton)
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(44)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(44)
        }

        roundViewBg.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleStackView.snp.bottom)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        roundViewBg.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-28)
            make.height.equalTo(44)
        }
        buttonStackView.addArrangedSubview(previewButton)
        buttonStackView.addArrangedSubview(nextButton)
    }
    
    @objc func backButtonDidTap() {
        router?.routeToBack()
    }
}

// MARK: - DisplayLogic
extension ImageScreenViewController: ImageScreenDisplayLogic {
    func displaySharing(viewModel: ImageScreen.Share.ViewModel) {
        DispatchQueue.main.async {
            if FileManager.default.fileExists(atPath: viewModel.temporaryURL.path()) {
                print("displaySharing Файл существует, можно продолжать шаринг")
                
            } else {
                print("Файл не найден по пути: \(viewModel.temporaryURL.path())")
            }
            let activityViewController = UIActivityViewController(activityItems: [viewModel.temporaryURL], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func displayItems(viewModel: ImageScreen.LoadContent.ViewModel) {
        content = viewModel.itemImages
        indexForStart = viewModel.index
        currentIndex = viewModel.index
        updateUI()
    }
}
