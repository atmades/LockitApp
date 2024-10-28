import UIKit
import JGProgressHUD

protocol CreatePdfFromPhotoSceneDisplayLogic: AnyObject {
    func displayError(viewModel: CreatePdfFromPhotoScene.Error.ViewModel)
    func displayCurrentData(viewModel: CreatePdfFromPhotoScene.CurrentData.ViewModel)
    func displayCeratedPDF(viewModel: CreatePdfFromPhotoScene.CreatedPDF.ViewModel)
}

class CreatePdfFromPhotoSceneViewController: UIViewController,UICollectionViewDelegateFlowLayout {
    var interactor: CreatePdfFromPhotoSceneBusinessLogic?
    var router: (NSObjectProtocol & CreatePdfFromPhotoSceneRoutingLogic & CreatePdfFromPhotoSceneDataPassing)?
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    // для теста билдера
    let saveButton1 = UIButtonBuilder()
        .setTitle("Save")
        .setTitleColor(.white)
        .setBackgroundColor(.blue)
        .setCornerRadius(8)
        .build()
    
    // MARK: - UI
    private var roundViewBg = UIView()
    private var titleLabel = UILabel()
    private var saveButton = UIButton(type: .system)
    private var cancelButton = UIButton(type: .system)
    private let titleStackView = UIStackView()
    
    private var showPDFButton = UIButton(type: .system)
    private var createPDFButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    private lazy var hud = JGProgressHUD.light()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: ThreeSquareLayout())
    
    private var images: [UIImage] = []
    private var pdfData: Data?
    private var pdfName = ""
    private var newPdfName = ""
    private var placeholderName = "XXX"
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        CreatePdfFromPhotoSceneConfigurator.sharedInstance.configure(viewController: self)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        setupCollectionView()
        setupStyles()
        setupLayout()
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        showPDFButton.addTarget(self, action: #selector(didTapShowPDF), for: .touchUpInside)
        createPDFButton.addTarget(self, action: #selector(didTapCreatePDF), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false // Это позволит касаниям проходить к другим элементам
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: -  Load
    func load() {
        interactor?.getCurrentData()
    }
    
    // MARK: -  @objc func
    @objc private func hideKeyboard() {
        view.endEditing(true)
        
        if newPdfName.isEmpty {
            if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderView {
                header.currentText = pdfName
                header.setNeedsLayout()
            }
        } else {
            pdfName = newPdfName
        }
    }
    
    @objc private func didTapCancel() {
        router?.routeToBack()
    }
    
    @objc private func didTapSave() {
        print(#function)
        interactor?.savePdf() {
            self.router?.routeToBackWithSavedPDF()
        }
    }
    
    @objc private func didTapShowPDF() {
        print(#function)
        if let _ = pdfData {
            router?.routeToViewingCreatedPdfScene()
        } else {
            Alerts.simpleAlert(
                 controller: self,
                 title: "Уведомление",
                 message: "Добавьте изображения и создайте PDF"
             )
        }
    }
    
    @objc private func didTapCreatePDF() {
        print(#function)
        hud.textLabel.text = "Creating doc..."
        hud.show(in: self)
        interactor?.createPdf(images: images)
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        switch gesture.state {
        case .began:
            if let selectedIndexPath = collectionView.indexPathForItem(at: location) {
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

// MARK: - Styles & Layout
extension CreatePdfFromPhotoSceneViewController {
    private func setupStyles() {
        view.backgroundColor = .clear
        
        roundViewBg.layer.cornerRadius = 50
        roundViewBg.layer.masksToBounds = true
        roundViewBg.addBlur()
        
        cancelButton.setImage(R.image.ico_close(), for: .init())
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        saveButton.setTitle("Save pdf", for: .normal)
        saveButton.contentHorizontalAlignment = .right
        saveButton.apply(settings: Styles.Buttons.NavigationBarText.controlSettings)
        
        titleLabel.text = "New Document"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 4
        
        showPDFButton.setTitle("Show PDF", for: .normal)
        showPDFButton.apply(settings: Styles.Buttons.NextPrevievsText.controlSettings)
        let cornersP: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        showPDFButton.layer.cornerRadius = 22
        showPDFButton.layer.maskedCorners = cornersP
        
        createPDFButton.setTitle("Generate PDF", for: .normal)
        createPDFButton.apply(settings: Styles.Buttons.NextPrevievsText.controlSettings)
        let cornersN: CACornerMask = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        createPDFButton.layer.cornerRadius = 22
        createPDFButton.layer.maskedCorners = cornersN
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: CustomCollectionViewCell.self)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:  HeaderView.identifier)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
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
        
        roundViewBg.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleStackView.snp.bottom).offset(0)
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
        buttonStackView.addArrangedSubview(showPDFButton)
        buttonStackView.addArrangedSubview(createPDFButton)
    }
}

// MARK: - DisplayLogic
extension CreatePdfFromPhotoSceneViewController: CreatePdfFromPhotoSceneDisplayLogic {
    func displayCurrentData(viewModel: CreatePdfFromPhotoScene.CurrentData.ViewModel) {
        pdfName = viewModel.name
        collectionView.reloadData()
    }
    
    func displayError(viewModel: CreatePdfFromPhotoScene.Error.ViewModel) {
        hud.dismiss()
        Alerts.simpleAlert(
             controller: self,
             title: "Уведомление",
             message: viewModel.message
         )
    }
    
    func displayCeratedPDF(viewModel: CreatePdfFromPhotoScene.CreatedPDF.ViewModel) {
        self.pdfData = viewModel.pdfData
        hud.dismiss()
        Alerts.simpleAlert(
             controller: self,
             title: "PDF создан",
             message: "Вы можете просмотреть его, а также сохранить"
         )
    }
}

// MARK: - UICollectionViewDataSource
extension CreatePdfFromPhotoSceneViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }
        print(pdfName)
        header.setupCell(placeholder: placeholderName, currentText: pdfName)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 180) 
    }
}

// MARK: - UICollectionViewDelegate
extension CreatePdfFromPhotoSceneViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.item]
        let imageVC = ImageViewController()
        imageVC.image = selectedImage
        present(imageVC, animated: true, completion: nil)
    }
    
    @objc private func handleDeleteCell(notification: Notification) {
        guard let cell = notification.object as? CustomCollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        images.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelInteractiveMovement: UICollectionView) {
        collectionView.cancelInteractiveMovement()
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedImage = images.remove(at: sourceIndexPath.item)
        images.insert(movedImage, at: destinationIndexPath.item)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatePdfFromPhotoSceneViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let fixedImage = image.fixOrientation()
            if let compressedImageData = fixedImage.jpegData(compressionQuality: 0.5),
               let compressedImage = UIImage(data: compressedImageData) {
                images.append(compressedImage)
            }
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CustomCollectionViewCellDelegate
extension CreatePdfFromPhotoSceneViewController: CustomCollectionViewCellDelegate {
    func didTapDeleteButton(in cell: CustomCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        images.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

// MARK: - HeaderViewDelegate
extension CreatePdfFromPhotoSceneViewController: HeaderViewDelegate {
    func textFieldText(text: String) {
        newPdfName = text
    }
    
    func didTapGalleryButton() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            Alerts.simpleAlert(
                 controller: self,
                 title: "Ой",
                 message: "Галлерея не доступна"
             )
            return
        }
        hud.textLabel.text = "Opening gallery..."
        hud.show(in: view)
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true) {
                self.hud.dismiss()
            }
        }
    }
    
    func didTapCameraButton() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            Alerts.simpleAlert(
                 controller: self,
                 title: "Ой",
                 message: "Камера не доступна на данном устройстве"
             )
            return
        }
        hud.textLabel.text = "Opening camera..."
        hud.show(in: view)
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true) {
                self.hud.dismiss()
            }
        }
    }
}

class UIButtonBuilder {
    private var button = UIButton(type: .system)
    
    func setTitle(_ title: String, for state: UIControl.State = .normal) -> UIButtonBuilder {
        button.setTitle(title, for: state)
        return self
    }
    
    func setTitleColor(_ color: UIColor, for state: UIControl.State = .normal) -> UIButtonBuilder {
        button.setTitleColor(color, for: state)
        return self
    }
    
    func setBackgroundColor(_ color: UIColor) -> UIButtonBuilder {
        button.backgroundColor = color
        return self
    }
    
    func setCornerRadius(_ radius: CGFloat) -> UIButtonBuilder {
        button.layer.cornerRadius = radius
        return self
    }
    
    func build() -> UIButton {
        return button
    }
}



