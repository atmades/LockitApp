import UIKit

@objc protocol testRoutingLogic { }

protocol testDataPassing {
  var dataStore: testDataStore? { get }
}

class testRouter: NSObject, testRoutingLogic, testDataPassing {
  weak var viewController: testViewController?
  var dataStore: testDataStore?
}
