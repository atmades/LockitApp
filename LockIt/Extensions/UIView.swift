import UIKit

extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var safeAreaBottom: CGFloat {
        get {
            if #available(iOS 15.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let windowsInScene = windowScene.windows
                    for window in windowsInScene {
                        let safeAreaInsets = window.safeAreaInsets
                        let bottomSafeAreaHeight = safeAreaInsets.bottom
                        return bottomSafeAreaHeight
                    }
                }
            } else {
                let window = UIApplication.shared.windows.first
                let safeAreaInsets = window?.safeAreaInsets
                let bottomSafeAreaHeight = safeAreaInsets?.bottom ?? 0
                return bottomSafeAreaHeight
            }
            return 0.0
        }
    }
    
    func addGlow() {
        let glowImageView = UIImageView()
        let image = UIImage(named: R.image.glow.name)
        glowImageView.image = image
        
        addSubview(glowImageView)
        glowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            glowImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glowImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            glowImageView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
    }
    
    func addBlur() {
        backgroundColor = .black.withAlphaComponent(0.1)
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
    }
}
