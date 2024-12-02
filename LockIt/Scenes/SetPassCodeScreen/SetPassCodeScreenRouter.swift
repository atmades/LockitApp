import UIKit

@objc protocol SetPassCodeScreenRoutingLogic { }

protocol SetPassCodeScreenDataPassing {
  var dataStore: SetPassCodeScreenDataStore? { get }
}

class SetPassCodeScreenRouter: NSObject, SetPassCodeScreenRoutingLogic, SetPassCodeScreenDataPassing {
  weak var viewController: SetPassCodeScreenViewController?
  var dataStore: SetPassCodeScreenDataStore?
}
