import UIKit
import PDFKit

protocol DownloadFileScreenDisplayLogic: AnyObject {
    func displayCurrentData(viewModel: DownloadFileScreen.CurrentData.ViewModel)
}

class DownloadFileScreenViewController: UIViewController {
    var interactor: DownloadFileScreenBusinessLogic?
    var router: (NSObjectProtocol & DownloadFileScreenRoutingLogic & DownloadFileScreenDataPassing)?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    var pdfData = Data()
    var pdfName = ""
    
    // MARK: - UI
    private var roundViewBg = UIView()
    private var titleLabel = UILabel()
    private var saveButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)
    private let titleStackView = UIStackView()
    private var zoomInButton = UIButton(type: .system)
    private var zoomOutButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    private var pdfView = PDFView()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        DownloadFileScreenConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayout()
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        
        interactor?.getCurrentData()
    }
    
    @objc func didTapCancel() {
        router?.routeToBack()
    }
    
    @objc func didTapSave() {
        interactor?.saveFile() {
            self.router?.goBackAndReloadList()
        }
    }
    
    @objc func zoomIn() {
        let newScale = min(pdfView.scaleFactor * 1.2, pdfView.maxScaleFactor)
        pdfView.scaleFactor = newScale
    }

    @objc func zoomOut() {
        let newScale = max(pdfView.scaleFactor * 0.8, pdfView.minScaleFactor)
        pdfView.scaleFactor = newScale
    }
}

// MARK: - styles & layout
extension DownloadFileScreenViewController {
    private func setupStyles() {
        view.backgroundColor = .clear
        
        roundViewBg.layer.cornerRadius = 50
        roundViewBg.layer.masksToBounds = true
        roundViewBg.addBlur()
        
        cancelButton.setImage(R.image.ico_close(), for: .init())
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        saveButton.setImage(R.image.ico_save(), for: .init())
        saveButton.contentHorizontalAlignment = .right
        saveButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        titleLabel.text = "Document"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        pdfView.autoScales = true // Автоматическое масштабирование PDF
        pdfView.displayMode = .singlePageContinuous // Отображение всех страниц с прокруткой
        pdfView.displayDirection = .vertical // Вертикальный скроллинг
        
        
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 4
        
        zoomOutButton.setTitle("Zoom Out", for: .normal)
        zoomOutButton.apply(settings: Styles.Buttons.NextPrevievsText.controlSettings)
        let cornersP: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        zoomOutButton.layer.cornerRadius = 22
        zoomOutButton.layer.maskedCorners = cornersP
        
        zoomInButton.setTitle("Zoom In", for: .normal)
        zoomInButton.apply(settings: Styles.Buttons.NextPrevievsText.controlSettings)
        let cornersN: CACornerMask = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        zoomInButton.layer.cornerRadius = 22
        zoomInButton.layer.maskedCorners = cornersN
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
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-16)
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

        roundViewBg.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom)
            make.left.equalToSuperview()
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
        
        buttonStackView.addArrangedSubview(zoomOutButton)
        buttonStackView.addArrangedSubview(zoomInButton)
    }
}

extension DownloadFileScreenViewController: DownloadFileScreenDisplayLogic {
    func displayCurrentData(viewModel: DownloadFileScreen.CurrentData.ViewModel) {
        pdfData = viewModel.pdfData
        pdfName = viewModel.pdfName
        titleLabel.text = pdfName
        
        if let document = PDFDocument(data: pdfData) {
            pdfView.document = document
        } else {
            Alerts.error(controller: self, message: "Ошибка загрузки. Невозможно создать PDF документ из переданных данных")
            print("Ошибка DownloadFileScreenViewController : Невозможно создать PDF документ из переданных данных")
        }
        
    }
    
    
}
