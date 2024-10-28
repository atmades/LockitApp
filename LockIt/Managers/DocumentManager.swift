import UIKit
import Vision
import PDFKit

class DocumentManager {
    
    var recognizedTexts: [String] = []
    
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let request = VNRecognizeTextRequest { request, error in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let recognizedTexts = results.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                let fullText = recognizedTexts.joined(separator: "\n")
                self.recognizedTexts.append(fullText) // Сохраняем распознанный текст
                print("Recognized text: \(fullText)")
            }
        }
        
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing text recognition: \(error)")
        }
    }
    
    func createPDF(from images: [UIImage]) {
        let pdfDocument = PDFDocument()
        
        for (index, image) in images.enumerated() {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
            
            // Добавление текста на страницу, если нужно
            if index < recognizedTexts.count {
                let text = recognizedTexts[index]
                // Здесь можно добавить текст на страницу, если нужно
            }
        }
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let pdfURL = documentDirectory.appendingPathComponent("document.pdf")
        
        pdfDocument.write(to: pdfURL)
        print("PDF сохранен по пути: \(pdfURL.path)")
    }
}
