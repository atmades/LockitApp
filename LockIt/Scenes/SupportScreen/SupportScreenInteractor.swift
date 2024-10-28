import UIKit

protocol SupportScreenBusinessLogic { }
protocol SupportScreenDataStore { }

class SupportScreenInteractor: SupportScreenBusinessLogic, SupportScreenDataStore {
  var presenter: SupportScreenPresentationLogic?
  var worker: SupportScreenWorker?
}
