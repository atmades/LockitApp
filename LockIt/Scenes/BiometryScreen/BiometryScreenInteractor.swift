import UIKit

protocol BiometryScreenBusinessLogic { }
protocol BiometryScreenDataStore { }

class BiometryScreenInteractor: BiometryScreenBusinessLogic, BiometryScreenDataStore {
    var presenter: BiometryScreenPresentationLogic?
    var worker: BiometryScreenWorker?
}
