import UIKit
import PDFKit
import Vision

protocol PDFManagerProtocol {
    func createPDF(from images: [UIImage], completion: @escaping (Result<Data, Error>) -> Void)
}

class PDFManager: PDFManagerProtocol {
    
    // Метод для создания PDF из изображений с распознаванием текста и иллюстраций
    func createPDF(from images: [UIImage], completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pdfDocument = PDFDocument()
            let dispatchGroup = DispatchGroup()
            var pageIndex = 0
            
            for image in images {
                dispatchGroup.enter()
                self.processImage(image) { [weak self] pageData in
                    guard let self = self, let page = self.createPDFPage(from: image, with: pageData) else {
                        dispatchGroup.leave()
                        return
                    }
                    pdfDocument.insert(page, at: pageIndex)
                    pageIndex += 1
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                guard let pdfData = pdfDocument.dataRepresentation() else {
                    completion(.failure(NSError(domain: "PDFCreationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create PDF data"])))
                    return
                }
                completion(.success(pdfData))
            }
        }
    }
    
    // Обработка изображения и распознавание текста и иллюстраций с использованием Vision
    private func processImage(_ image: UIImage, completion: @escaping ([String: Any]?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            var detectedText = ""
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    detectedText.append("\(topCandidate.string)\n")
                }
            }
            
            // Определяем, содержит ли изображение иллюстрации
            let containsIllustrations = self.detectIllustrations(in: image)
            
            completion(["text": detectedText, "containsIllustrations": containsIllustrations])
        }
        request.recognitionLevel = .accurate
        
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    
    // Создание PDF-страницы на основе изображения и данных OCR
    private func createPDFPage(from image: UIImage, with data: [String: Any]?) -> PDFPage? {
        guard let pdfPage = PDFPage(image: image) else {
            return nil
        }
        
        if let detectedText = data?["text"] as? String, let containsIllustrations = data?["containsIllustrations"] as? Bool {
            print("Detected text: \(detectedText)")
            print("Contains illustrations: \(containsIllustrations)")
            
            // Создаем аннотацию типа FreeText с распознанным текстом
            let annotation = PDFAnnotation(bounds: CGRect(x: 20, y: 20, width: 300, height: 100), forType: .freeText, withProperties: nil)
            
            // Устанавливаем содержимое аннотации
            annotation.contents = detectedText
            
            // Устанавливаем свойства шрифта и цвета
            annotation.font = UIFont.systemFont(ofSize: 12)
            annotation.fontColor = .black
            annotation.backgroundColor = .clear  // Устанавливаем прозрачный фон (по желанию)
            
            // Добавляем аннотацию к странице PDF
            pdfPage.addAnnotation(annotation)
        }
        
        return pdfPage
    }
 
    
//    private func createPDFPage(from image: UIImage, with data: [String: Any]?) -> PDFPage? {
//        let pdfPage = PDFPage(image: image)
//        
//        if let detectedText = data?["text"] as? String, let containsIllustrations = data?["containsIllustrations"] as? Bool {
//            print("Detected text: \(detectedText)")
//            print("Contains illustrations: \(containsIllustrations)")
//            
//            // Здесь можно добавить логику аннотирования текста или другой обработки
//        }
//        return pdfPage
//    }
    
    // Пример метода для распознавания иллюстраций
    private func detectIllustrations(in image: UIImage) -> Bool {
        // Простая логика для иллюстраций, можно расширить до использования CoreML или анализа гистограммы
        return true
    }
}

