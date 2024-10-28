import UIKit
import SnapKit

final class InformerView: UIView {
    
    private enum Constants {
        static let buttonPadTop: CGFloat = 32
        static let padLeft: CGFloat = 24
        static let padRight: CGFloat = -24
        static let padBottom: CGFloat = -4
        
        static let spacing: CGFloat = 16
        static let numberOfLines = 0
    }
    
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    private let labelStackView = UIStackView()
    
    private var firstTextField = UITextField()
    private let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 10))
    private let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 10))

    private let buttonsStackView = UIStackView()
    private var actionButton = UIButton()
    private var cancelButton = UIButton()
    private var roundView = UIView()
    private var blurBackgroundView = UIView()
    private var blurEffectView: UIVisualEffectView!
    
    var buttonAction: (() -> Void)?
    
    var placeholder = "" {
        didSet {
            firstTextField.placeholder = placeholder
        }
    }
    
    @objc private func buttonTapped() {
        // Вызываем замыкание при нажатии на кнопку, если оно задано
        buttonAction?()
    }
    
        var model: InformerViewModel? {
            didSet {
                guard let model = model else { return }
                actionButton.setTitle(model.actionTitle, for: .init())
                actionButton.isHidden = model.action == nil
    
//                textView.configure(title: model.title,
//                                   titleSettings: Constants.titleSettins,
//                                   text: model.subtitle,
//                                   textSettings: Constants.textSettins,
//                                   spacing: Constants.spacing)
//                textView.setNumberOfLines(titleLines: Constants.numberOfLines,
//                                          textLines: Constants.numberOfLines)
            }
        }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupStyles()
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView) {
        self.alpha = 0.0
        
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1.0
        }
    }
    func dismissFromSuperview() {
        removeFromSuperview()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - setup Styles Layout
private extension InformerView {
    
    @objc func backButtonDidTap() {
        print(#function)
    }
    func setupStyles() {
        
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        backgroundColor = .black.withAlphaComponent(0.1)
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        actionButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        titleLabel.text = "Rename"
        titleLabel.apply(settings: Styles.Typography.Titles.Title22.title)
        titleLabel.textAlignment = .center
        titleLabel.tintColor = .red
        
        firstTextField.backgroundColor = UIColor(named: R.color.color_gray85.name)
        firstTextField.layer.cornerRadius = 12
        
        firstTextField.borderStyle = .none
        firstTextField.autocapitalizationType = .sentences
        firstTextField.layer.masksToBounds = true
        firstTextField.returnKeyType = .next
        firstTextField.autocapitalizationType = .words
        firstTextField.font = .makeAvenir(size: 16)
        firstTextField.textColor = UIColor.white.withAlphaComponent(0.8)
        
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.3), // Устанавливаем красный цвет текста заполнителя
        ]
        let attributedPlaceholder = NSAttributedString(string: " ", attributes: attributes)
        firstTextField.attributedPlaceholder = attributedPlaceholder
        
        paddingViewLeft.backgroundColor = .clear
        firstTextField.leftView = paddingViewLeft
        firstTextField.leftViewMode = .always
        
        paddingViewRight.backgroundColor = .clear
        firstTextField.rightView = paddingViewRight
        firstTextField.rightViewMode = .always
        
        actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        actionButton.apply(settings: Styles.Typography.Titles.Title18.title)

        actionButton.backgroundColor = UIColor(named: R.color.color_main.name)
        actionButton.layer.masksToBounds = true
        actionButton.layer.cornerRadius = 12
        
        actionButton.setTitle("Save", for: .normal)
        actionButton.layer.shadowColor = UIColor(named: R.color.color_main.name)?.cgColor
        actionButton.layer.shadowRadius = 1
        actionButton.layer.shadowOpacity = 0.6
        actionButton.layer.shadowOffset = CGSize(width: 6, height: 6)
        
        roundView.layer.cornerRadius = 40
        roundView.layer.borderWidth = 1
        roundView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        roundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @objc func actionButtonDidTap(_ sender: Any) {
        //        model?.action?()
    }
    
    func setupLayout() {
        addSubview(roundView)
        roundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        roundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.buttonPadTop)
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.right.equalToSuperview().offset(Constants.padRight)
        }
        
        roundView.addSubview(firstTextField)
        firstTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.buttonPadTop)
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.right.equalToSuperview().offset(Constants.padRight)
            make.height.equalTo(64)
        }
        
        roundView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(firstTextField.snp.bottom).offset(Constants.buttonPadTop)
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.right.equalToSuperview().offset(Constants.padRight)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().offset(-46)
        }
    }
}
