import UIKit

class FloatingSettingsHeaderView: UIView {
    private enum Constants {
        static let padTop: CGFloat = 56
        static let padLeft: CGFloat = 16
        static let padRight: CGFloat = -16
        static let padBottom:  CGFloat = -8
        static let titleSettings: ControlSettings = Styles.Typography.Titles.Title27.title
    }
    
    weak var delegate: AnyObject?

    @objc func didTapGoBack() {
        if let backDelegate = delegate as? FloatingHeaderViewBackDelegate {
            backDelegate.didTabBack1()
        }
    }
    
    // MARK: - UI
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let newButton = UIButton()
    private var blurEffectView: UIVisualEffectView!
    
    //    MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupStyle()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Public
    func configure(title: String?, counterVC: Int) {
        titleLabel.text = title
        counterVC == 1 ? (backButton.isHidden = true) : (backButton.isHidden = false)
    }
}

extension FloatingSettingsHeaderView {
    
    private func setupStyle() {
        backgroundColor = .black
        
        backButton.setImage(UIImage(named: R.image.ico_arrow_back.name), for: .normal)
        backButton.addTarget(self, action: #selector(didTapGoBack), for: .touchUpInside)
        
        titleLabel.apply(settings: Constants.titleSettings)
//        newButton.setImage(UIImage(named: R.image.ic_plus.name), for: .normal)
    }
    
    private func setupLayout() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.padLeft)
            make.top.equalToSuperview().offset(Constants.padTop)
            make.bottom.equalToSuperview().offset(Constants.padBottom)
        }
//        addSubview(newButton)
//        newButton.snp.makeConstraints { make in
//            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8)
//            make.right.equalToSuperview().offset(Constants.padRight)
//            make.top.equalToSuperview().offset(54)
//            make.width.equalTo(32)
//            make.height.equalTo(32)
//        }
    }
}
