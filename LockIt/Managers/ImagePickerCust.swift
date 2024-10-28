import UIKit
import JGProgressHUD

class ImagePickerCust: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController: UIImagePickerController?
    var complition: ((UIImage) -> ())?
    var complition2: ((UIImage, String, Date) -> ())?
    
    // Метод для отображения контроллера выбора изображения
    func showImagePickerVC(in viewController: UIViewController, sourceType: UIImagePickerController.SourceType, complition: ((UIImage, String, Date) -> ())?) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            Alerts.simpleAlert(
                controller: viewController,
                title: "Ошибка",
                message: "Данный источник не доступен на устройстве"
            )
            return
        }
        let hud = JGProgressHUD.light()
        hud.textLabel.text = "Opening ..."
        hud.show(in: viewController.view)
        
        self.complition2 = complition
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.sourceType = sourceType
        viewController.present(imagePickerController!, animated: true) {
            hud.dismiss()
        }
    }
    
    // Обработка выбранного изображения
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let currentDate = Date()
            let generatedUUID = UUID().uuidString
            self.complition2?(image, generatedUUID, currentDate)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var images: [UIImage] = []
    var onImagePicked: ((UIImage) -> Void)?
    weak var viewController: UIViewController? // Объявляем как weak
    
    var maxPhotos: Int = 5 // Максимальное количество фотографий
    
    func takePhoto(from viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            images.append(image) // Добавляем фотографию в массив
            onImagePicked?(image) // Возврат изображения через замыкание
        }
        
        picker.dismiss(animated: true) {
            if self.images.count < self.maxPhotos {
                if let viewController = self.viewController {
                    self.takePhoto(from: viewController) // Открываем камеру снова
                } else {
                    print("viewController is nil")
                }
            } else {
                print("Достигнуто максимальное количество фотографий.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


