import UIKit

protocol BiometryScreenPresentationLogic { }

class BiometryScreenPresenter: BiometryScreenPresentationLogic {
  weak var viewController: BiometryScreenDisplayLogic?
}
