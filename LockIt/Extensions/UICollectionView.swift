import UIKit

extension UICollectionView {
    func register(cellIds: [String]) {
        cellIds.forEach({
            register(UINib(nibName: $0, bundle: nil), forCellWithReuseIdentifier: $0)
        })
    }
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeCell<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            return T()
        }
        return cell
    }
}
