import UIKit

extension UICollectionViewCell {
    private static func get<T: UICollectionViewCell>(from collectionView: UICollectionView, at indexPath: IndexPath) -> T {
        return collectionView.dequeCell(at: indexPath) as T
    }
    static func get(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        return UICollectionViewCell.get(from: collectionView, at: indexPath)
    }
}
