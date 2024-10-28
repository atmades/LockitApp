import UIKit

extension UIButton: ControlDesignableProtocol {
    func apply(settings: ControlSettings) {
        if let font = settings.font, let color = settings.titleColor {
            titleLabel?.apply(settings: ControlSettings(font: font, titleColor: color))
            setTitleColor(color, for: .init())
            tintColor = color
        }
        if let color = settings.backgroundColor {
            backgroundColor = color
        }
    }
}
