//
//  ImageManager.swift
//  LockIt
//
//  Created by Maxim on 10/10/2024.
//

import UIKit

class ImageManager {
    private var images: [UIImage] = []
    
    func add(image: UIImage) {
        images.append(image)
    }
    
    func delete(at index: Int) {
        images.remove(at: index)
    }
    
    func move(from sourceIndex: Int, to destinationIndex: Int) {
        let image = images.remove(at: sourceIndex)
        images.insert(image, at: destinationIndex)
    }
}
