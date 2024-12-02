import UIKit

protocol SetPassCodeScreenBusinessLogic { }
protocol SetPassCodeScreenDataStore { }

class SetPassCodeScreenInteractor: SetPassCodeScreenBusinessLogic, SetPassCodeScreenDataStore {
  var presenter: SetPassCodeScreenPresentationLogic?
  var worker: SetPassCodeScreenWorker?
}
