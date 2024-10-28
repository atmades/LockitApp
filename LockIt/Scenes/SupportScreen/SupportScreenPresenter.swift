import UIKit

protocol SupportScreenPresentationLogic { }

class SupportScreenPresenter: SupportScreenPresentationLogic {
  weak var viewController: SupportScreenDisplayLogic?
}
