import UIKit

protocol testPresentationLogic { }

class testPresenter: testPresentationLogic {
  weak var viewController: testDisplayLogic?
}
