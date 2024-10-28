import UIKit

@objc protocol CreatePdfFromPhotoRoutingLogic { }

protocol CreatePdfFromPhotoDataPassing {
  var dataStore: CreatePdfFromPhotoDataStore? { get }
}

class CreatePdfFromPhotoRouter: NSObject, CreatePdfFromPhotoRoutingLogic, CreatePdfFromPhotoDataPassing {
  weak var viewController: CreatePdfFromPhotoViewController?
  var dataStore: CreatePdfFromPhotoDataStore?
}
