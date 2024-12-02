import UIKit

protocol RepeatPassCodeScreenBusinessLogic { }
protocol RepeatPassCodeScreenDataStore { }

class RepeatPassCodeScreenInteractor: RepeatPassCodeScreenBusinessLogic, RepeatPassCodeScreenDataStore {
  var presenter: RepeatPassCodeScreenPresentationLogic?
  var worker: RepeatPassCodeScreenWorker?
}
