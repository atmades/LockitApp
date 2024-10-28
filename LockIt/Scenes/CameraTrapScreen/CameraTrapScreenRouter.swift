import UIKit

@objc protocol CameraTrapScreenRoutingLogic { }

protocol CameraTrapScreenDataPassing {
  var dataStore: CameraTrapScreenDataStore? { get }
}

class CameraTrapScreenRouter: NSObject, CameraTrapScreenRoutingLogic, CameraTrapScreenDataPassing {
  weak var viewController: CameraTrapScreenViewController?
  var dataStore: CameraTrapScreenDataStore?
}
