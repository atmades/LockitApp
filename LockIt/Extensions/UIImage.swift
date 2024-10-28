import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return scaledImage
    }
    
    func fixOrientation() -> UIImage {
        // Проверяем, нужно ли корректировать ориентацию
        guard imageOrientation != .up else {
            return self
        }
        
        // Поворачиваем изображение в соответствии с его текущей ориентацией
        guard let cgImage = self.cgImage else { return self }
        guard let colorSpace = cgImage.colorSpace else { return self }
        
        let width = self.size.width
        let height = self.size.height
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0).rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height).rotated(by: -.pi / 2)
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0).scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0).scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Создаем новый контекст для рисования изображения с корректной ориентацией
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height),
                                      bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                      space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return self
        }
        
        context.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        // Создаем новое изображение из контекста
        guard let newCgImage = context.makeImage() else { return self }
        return UIImage(cgImage: newCgImage)
    }
    
}
