import UIKit

@objc protocol RepeatPassCodeScreenRoutingLogic { }

protocol RepeatPassCodeScreenDataPassing {
  var dataStore: RepeatPassCodeScreenDataStore? { get }
}

class RepeatPassCodeScreenRouter: NSObject, RepeatPassCodeScreenRoutingLogic, RepeatPassCodeScreenDataPassing {
  weak var viewController: RepeatPassCodeScreenViewController?
  var dataStore: RepeatPassCodeScreenDataStore?
}
