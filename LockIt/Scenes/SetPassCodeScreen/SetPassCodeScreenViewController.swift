import UIKit

protocol SetPassCodeScreenDisplayLogic: AnyObject {
  func displaySomething(viewModel: SetPassCodeScreen.Something.ViewModel)
}

class SetPassCodeScreenViewController: UIViewController {
  var interactor: SetPassCodeScreenBusinessLogic?
  var router: (NSObjectProtocol & SetPassCodeScreenRoutingLogic & SetPassCodeScreenDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - DisplayLogic
extension SetPassCodeScreenViewController: SetPassCodeScreenDisplayLogic { }
