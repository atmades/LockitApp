import UIKit

struct ControlSettings {
    let font: UIFont?
    let titleColor: UIColor?
    let backgroundColor: UIColor?
    let lineSpacing: CGFloat?

    init(font: UIFont? = nil, titleColor: UIColor? = nil, lineSpacing: CGFloat? = nil, backgroundColor: UIColor? = nil, linSpacing: CGFloat? = nil) {
        self.font = font
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.lineSpacing = lineSpacing
    }
}
