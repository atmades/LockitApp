import UIKit

protocol RepeatPassCodeScreenDisplayLogic: AnyObject {
  func displaySomething(viewModel: RepeatPassCodeScreen.Something.ViewModel)
}

class RepeatPassCodeScreenViewController: UIViewController {
  var interactor: RepeatPassCodeScreenBusinessLogic?
  var router: (NSObjectProtocol & RepeatPassCodeScreenRoutingLogic & RepeatPassCodeScreenDataPassing)?

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
extension RepeatPassCodeScreenViewController: RepeatPassCodeScreenDisplayLogic { }
