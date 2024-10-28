import Foundation

struct AlertModel {
    var title: String?
    var message: String?
}

enum AlertsViewModel: Int, CaseIterable  {
    case confirmSaveContact
    case successfulSaveContact
    
    var model: AlertModel? {
        switch self {
        case .confirmSaveContact:
            return AlertModel(title: "", message: "")
        case .successfulSaveContact:
            return AlertModel(title: "", message: "")
        }
    }
}
