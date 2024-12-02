import UIKit
import AudioToolbox

class CircleIndicatorView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var circles: [UIView] = []
    
    init(circleCount: Int) {
        super.init(frame: .zero)
        setupView(circleCount: circleCount)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(circleCount: 6)
    }
    
    private func setupView(circleCount: Int) {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        for _ in 0..<circleCount {
            let circle = UIView()
            let size: CGFloat = 20
            circle.layer.cornerRadius = size/2
            circle.layer.borderWidth = 1
            let green = UIColor(named: R.color.color_main.name)?.cgColor
            let alternativeColor = UIColor.white.withAlphaComponent(0.4).cgColor
            circle.layer.borderColor = green ?? alternativeColor
            circle.backgroundColor = .clear
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.widthAnchor.constraint(equalToConstant: size).isActive = true
            circle.heightAnchor.constraint(equalToConstant: size).isActive = true
            stackView.addArrangedSubview(circle)
            circles.append(circle)
        }
    }
    
    func updateIndicator(filledCount: Int) {
        let color = UIColor(named: R.color.color_main.name) ?? .green
        for (index, circle) in circles.enumerated() {
            circle.backgroundColor = index < filledCount ? color : .clear
        }
    }
    
    func updateWithError() {
        errorIndicator()
        triggerVibration()
        shakeAnimation { [weak self] in
            self?.emptyIndicator()
        }
    }
    
    func updateClear() {
        emptyIndicator()
    }
    
    private func errorIndicator() {
        let color = UIColor(named: R.color.color_red.name) ?? UIColor.red
        for circle in circles {
            circle.backgroundColor = color
            circle.layer.borderColor = color.cgColor
        }
    }
    
    private func emptyIndicator() {
        let color = UIColor.clear
        for circle in circles {
            circle.backgroundColor = color
            circle.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        }
    }
    
    private func triggerVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    private func shakeAnimation(completion: @escaping () -> Void) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 4
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: stackView.center.x - 10, y: stackView.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: stackView.center.x + 10, y: stackView.center.y))
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        
        stackView.layer.add(shake, forKey: "position")
        CATransaction.commit()
    }
}
