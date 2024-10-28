import UIKit

extension UIFont {
    static func makeAvenir(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont? {
        switch weight {
        case .medium:
            return R.font.avenirNextCyrMedium(size: size)
        case .semibold:
            return R.font.avenirNextCyrDemi(size: size)
        case .bold:
            return R.font.avenirNextCyrBold(size: size)
        default:
            return R.font.avenirNextCyrRegular(size: size)
        }
    }
}
