import UIKit

@objc protocol CreatePdfFromPhotoSceneRoutingLogic {
    func routeToBack()
    func routeToViewingCreatedPdfScene()
    func routeToBackWithSavedPDF()
}

protocol CreatePdfFromPhotoSceneDataPassing {
    var dataStore: CreatePdfFromPhotoSceneDataStore? { get }
}

class CreatePdfFromPhotoSceneRouter: NSObject, CreatePdfFromPhotoSceneRoutingLogic, CreatePdfFromPhotoSceneDataPassing {
    
    weak var viewController: CreatePdfFromPhotoSceneViewController?
    var dataStore: CreatePdfFromPhotoSceneDataStore?
    
    func routeToBack() {
        viewController?.dismiss(animated: true)
    }
    
    func routeToViewingCreatedPdfScene() {
        let vc = ViewingCreatedPdfSceneViewController()
        var destinationDS = vc.router?.dataStore
        passViewingCreatedPdfScene(destination: &destinationDS)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        viewController?.navigationController?.present(navBarOnModal, animated: true)
    }
    
    func routeToBackWithSavedPDF() {
        viewController?.dismiss(animated: true) { [weak self] in
            guard self != nil else { return }
            guard let identifier = self?.dataStore?.notificationIdentifier else { return }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: identifier), object: nil)
        }
    }
}

private extension CreatePdfFromPhotoSceneRouter {
    func passViewingCreatedPdfScene(destination: inout ViewingCreatedPdfSceneDataStore?) {
        destination?.pdfData = dataStore?.pdfData
        destination?.pdfName = dataStore?.pdfName ?? ""
    }
}
