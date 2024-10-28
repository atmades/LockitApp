import UIKit

protocol CameraTrapScreenBusinessLogic { }
protocol CameraTrapScreenDataStore { }

class CameraTrapScreenInteractor: CameraTrapScreenBusinessLogic, CameraTrapScreenDataStore {
  var presenter: CameraTrapScreenPresentationLogic?
  var worker: CameraTrapScreenWorker?
}
