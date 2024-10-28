import Foundation
import PDFKit


// Тип ошибки для загрузки и обработки PDF файлов
enum DownloadError: Error {
    case invalidURL
    case invalidFileType
    case compressionFailed
    case invalidPDF
}

struct PDFDownloadResult {
    let data: Data
    let location: URL
    let fileName: String
    let originalSize: Int
    let compressedSize: Int?
    let compressed: Bool
    let message: String
}

class DownloadManager: NSObject, URLSessionDownloadDelegate {
    
    let compressionManager = PDFCompressionManager()
    var onDownloadCompletion: ((Result<PDFDownloadResult, DownloadError>) -> Void)?
    let fileSizeLimit: Int = 15 * 1024 * 1024 // 15 MB
    
    // Метод для загрузки файла
    func downloadTest(urlString: String, completion: @escaping (Result<PDFDownloadResult, DownloadError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard url.pathExtension.lowercased() == "pdf" else {
            completion(.failure(.invalidFileType))
            return
        }
        
        self.onDownloadCompletion = completion
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // Асинхронное чтение данных
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileName = downloadTask.originalRequest?.url?.lastPathComponent ?? "Unknown"
                let data = try Data(contentsOf: location)
                
                // Проверка и обработка загруженного файла
                self.processDownloadedFile(data: data, fileName: fileName, location: location)
            } catch {
                DispatchQueue.main.async {
                    self.onDownloadCompletion?(.failure(.invalidPDF))
                }
            }
        }
    }
    
    // Метод для обработки загруженного файла
    private func processDownloadedFile(data: Data, fileName: String, location: URL) {
        let originalSize = data.count
        
        // Проверка размера файла
        if originalSize > fileSizeLimit {
            
            // Попытка сжатия файла
            guard let compressedData = compressPDF(data) else { return }
            
            let compressedSize = compressedData.count
            
            if compressedSize < originalSize && compressedSize <= fileSizeLimit {
                // Успешное сжатие
                let result = PDFDownloadResult(
                    data: compressedData,
                    location: location,
                    fileName: fileName,
                    originalSize: originalSize,
                    compressedSize: compressedSize,
                    compressed: true,
                    message: "Файл большой, но мы его сжали. Было \(originalSize / 1024) KB, стало \(compressedSize / 1024) KB."
                )
                DispatchQueue.main.async {
                    self.onDownloadCompletion?(.success(result))
                }
            } else {
                // Не удалось сжать до нужного размера
                let result = PDFDownloadResult(
                    data: data,
                    location: location,
                    fileName: fileName,
                    originalSize: originalSize,
                    compressedSize: compressedSize,
                    compressed: false,
                    message: "Файл слишком большой, и мы не смогли его сжать."
                )
                DispatchQueue.main.async {
                    self.onDownloadCompletion?(.failure(.compressionFailed))
                }
            }
        } else {
            // Файл в допустимом размере
            let result = PDFDownloadResult(
                data: data,
                location: location,
                fileName: fileName,
                originalSize: originalSize,
                compressedSize: nil,
                compressed: false,
                message: "Файл загружен успешно."
            )
            DispatchQueue.main.async {
                self.onDownloadCompletion?(.success(result))
            }
        }
    }
    
    // Простая заглушка для сжатия PDF (в реальном проекте должна быть реализована логика сжатия)
    private func compressPDF(_ data: Data, compressionQuality: CGFloat = 0.5) -> Data? {
        // Создаем объект PDFDocument из оригинальных данных
            guard let pdfDocument = PDFDocument(data: data) else {
                print("Невозможно создать PDFDocument")
                return nil
            }
            
            // Создаем новое PDF сжатие
            let newPDFData = NSMutableData()
            let pdfConsumer = CGDataConsumer(data: newPDFData as CFMutableData)
            
            // Получаем размеры страниц
            let options: [AnyHashable: Any] = [kCGPDFContextCreator: "Compressed PDF"]
            
            guard let pdfContext = CGContext(consumer: pdfConsumer!, mediaBox: nil, options as CFDictionary) else {
                print("Невозможно создать CGContext")
                return nil
            }
            
            for pageIndex in 0..<pdfDocument.pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                var mediaBox = page.bounds(for: .mediaBox)
                
                pdfContext.beginPage(mediaBox: &mediaBox)
                
                // Рисуем страницу в контексте
                pdfContext.drawPDFPage(page.pageRef!)
                
                // Опционально, сжимаем изображения
                compressImagesInPDFPage(context: pdfContext, page: page, quality: compressionQuality)
                
                pdfContext.endPage()
            }
            
            pdfContext.closePDF()
            
            return newPDFData as Data
    }
    
    // Логика для сжатия изображений внутри PDF страницы
    private func compressImagesInPDFPage(context: CGContext, page: PDFPage, quality: CGFloat) {
        // Логика для нахождения и сжатия изображений на странице
        // Можно использовать CoreGraphics или другие способы для обработки изображений
    }
    
    // Обработка ошибок при загрузке
    private func handleDownloadError(_ error: Error) {
        DispatchQueue.main.async {
            self.onDownloadCompletion?(.failure(.invalidPDF))
        }
    }
    
    // Обработка завершения задачи с ошибкой
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download error:", error)
            onDownloadCompletion?(.failure(.invalidPDF))
        }
    }
}


//class DownloadManager: NSObject, URLSessionDownloadDelegate {
//    
//    var onDownloadCompletion: ((Data?, URL?, String?, Error?) -> Void)?
//    
//    func downloadTest(urlString: String, completion: @escaping (Data?, URL?, String?, Error?) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(nil, nil, nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//            return
//        }
//        
//        guard url.pathExtension.lowercased() == "pdf" else {
//            completion(nil, nil, nil, NSError(domain: "Invalid File Type", code: 1, userInfo: [NSLocalizedDescriptionKey: "Файл не является PDF"]))
//            return
//        }
//        
//        self.onDownloadCompletion = completion
//        
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//        let downloadTask = urlSession.downloadTask(with: url)
//        downloadTask.resume()
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("downloadLocation:", location)
//        
//        do {
//            let fileName = downloadTask.originalRequest?.url?.lastPathComponent ?? "Unknown"
//            let data = try Data(contentsOf: location)
//            print("данные загружены")
//            print(fileName)
//            
//            if let pdfDocument = PDFDocument(data: data), pdfDocument.pageCount > 0 {
//                // Если PDF успешно создан, передаем данные
//                DispatchQueue.main.async {
//                    self.onDownloadCompletion?(data, location, fileName, nil)
//                }
//            } else {
//                let pdfError = NSError(domain: "DownloadManagerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Файл не является допустимым PDF."])
//                DispatchQueue.main.async {
//                    self.onDownloadCompletion?(nil, nil, nil, pdfError)
//                }
//            }
//        } catch {
//            print("Error reading downloaded file:", error)
//            DispatchQueue.main.async {
//                self.onDownloadCompletion?(nil, nil, nil, error)
//            }
//        }
//    }
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let error = error {
//            print("Download error:", error)
//            onDownloadCompletion?(nil, nil, nil, error)
//        }
//    }
//}
