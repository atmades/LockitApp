import UIKit

protocol ChangePasscodeScreenBusinessLogic { }
protocol ChangePasscodeScreenDataStore { }

class ChangePasscodeScreenInteractor: ChangePasscodeScreenBusinessLogic, ChangePasscodeScreenDataStore {
  var presenter: ChangePasscodeScreenPresentationLogic?
  var worker: ChangePasscodeScreenWorker?
}
