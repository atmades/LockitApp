import UIKit

extension UILabel: ControlDesignableProtocol {
    
    func apply(settings: ControlSettings) {
        if let font = settings.font {
            self.font = font
        }
        if let color = settings.titleColor {
            textColor = color
        }
        if let color = settings.backgroundColor {
            backgroundColor = color
        }
    }
    
}
