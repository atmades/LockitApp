import Foundation

struct InformerViewModel {
    let title: String
    let subtitle: String
    let actionTitle: String
    let action: (() -> Void)?
}
