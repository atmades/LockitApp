import UIKit
import AudioToolbox

protocol PasscodeKeyboardViewDelegate: AnyObject {
    func numberTapped(_ number: Int)
    func deleteTapped()
}

class PasscodeKeyboardView: UIView {
    
    weak var delegate: PasscodeKeyboardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear  // Добавляем цвет фона для отладки
        setupKeyboard()
        self.isUserInteractionEnabled = true  // Включаем взаимодействие
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        setupKeyboard()
        self.isUserInteractionEnabled = true
    }
    
    private func setupKeyboard() {
        let keyboardStackView = UIStackView()
        keyboardStackView.axis = .vertical
        keyboardStackView.spacing = 30
        keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttons = (1...9).map { createNumberButton(number: $0) }
        let deleteButton = createDeleteButton()
        
        for i in 0..<3 {
            let rowStackView = UIStackView(arrangedSubviews: Array(buttons[i*3...(i*3+2)]))
            rowStackView.axis = .horizontal
            rowStackView.spacing = 30
            keyboardStackView.addArrangedSubview(rowStackView)
        }
        
        let emptyButton = UIButton(type: .system)
        emptyButton.isUserInteractionEnabled = false
        emptyButton.translatesAutoresizingMaskIntoConstraints = false
        emptyButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let lastRowStackView = UIStackView(arrangedSubviews: [emptyButton, createNumberButton(number: 0), deleteButton])
        lastRowStackView.axis = .horizontal
        lastRowStackView.spacing = 30
        keyboardStackView.addArrangedSubview(lastRowStackView)
        
        addSubview(keyboardStackView)
        NSLayoutConstraint.activate([
            keyboardStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            keyboardStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func createNumberButton(number: Int) -> UIButton {
        let size: CGFloat = 80
        let button = UIButton(type: .system)
        button.setTitle("\(number)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        let titleColor = UIColor(named: R.color.color_main.name) ?? UIColor.white
        let backColor = UIColor(named: R.color.color_gray80.name) ?? UIColor.darkGray
        button.backgroundColor = backColor
        button.tintColor = titleColor
        button.layer.cornerRadius = size/2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.tag = number
        button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createDeleteButton() -> UIButton {
        let button = UIButton(type: .system)
        let size: CGFloat = 80
        button.setBackgroundImage(UIImage(named: R.image.ico_deleteKeyboard.name), for: .normal)
        button.setBackgroundImage(UIImage(named: R.image.ico_deleteKeyboardSelected.name), for: .selected)
        button.setTitle(" ", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        return button
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        print("Tapped number: \(sender.tag)")
        triggerHapticAndSoundFeedback()
        delegate?.numberTapped(sender.tag)
    }
    
    @objc private func deleteButtonTapped() {
        print("Tapped delete")
        triggerHapticAndSoundFeedback()
        delegate?.deleteTapped()
    }
    
    private func triggerHapticAndSoundFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIDevice.current.playInputClick()
    }
}

