import UIKit

protocol SetPassCodeViewDelegate: AnyObject {
    func numberTapped(_ number: Int)
    func deleteTapped()
    func skipButtonTapped()
}

class SetPassCodeView: UIView {
    
    private let circlesView = CircleIndicatorView(circleCount: 4)
    private let keyboardView = PasscodeKeyboardView()
    private let skipButton = UIButton(type: .system)
    
    private var enteredPasscode = ""
    
    weak var delegate: SetPassCodeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyles()
        setupLayout()
    }
    
    @objc private func didTapSkipButton() {
        delegate?.skipButtonTapped()
        circlesView.updateWithError()
    }
    
    func updateIndicator(count: Int) {
        circlesView.updateIndicator(filledCount: count)
    }
    
    
    func clearIndicators() {
        circlesView.updateClear()
    }
    
    func errorIndicator() {
        circlesView.updateWithError()
    }
    
    private func setupStyles() {
        keyboardView.delegate = self
        
        skipButton.setTitle("Set passcode later", for: .normal)
        skipButton.tintColor = .white
        skipButton.backgroundColor = .white.withAlphaComponent(0.05)
        skipButton.layer.cornerRadius = 12
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        addSubview(keyboardView)
        keyboardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
       addSubview(circlesView)
        circlesView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(keyboardView.snp.top).offset(-150)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
}

extension SetPassCodeView: PasscodeKeyboardViewDelegate {
    func numberTapped(_ number: Int) {
        delegate?.numberTapped(number)
    }
    
    func deleteTapped() {
        circlesView.updateIndicator(filledCount: enteredPasscode.count)
        delegate?.deleteTapped()
    }

}
