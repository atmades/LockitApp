import UIKit

protocol MaskingScreenBusinessLogic {
    func getTitleName()
}

protocol MaskingScreenDataStore {
    var countVC: Int { get set }
    var folderName: String { get set }
}

class MaskingScreenInteractor: MaskingScreenBusinessLogic, MaskingScreenDataStore {
    var presenter: MaskingScreenPresentationLogic?
    var worker: MaskingScreenWorker?
    
    var countVC: Int = 0
    var folderName = ""
    
    func getTitleName() {
        self.presenter?.presentFolderName(response: MaskingScreen.Folder.Response(folderName: folderName, counterVC: countVC))
    }
}
