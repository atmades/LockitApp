import UIKit

class ThreeSquareLayout: UICollectionViewFlowLayout {
    
    private enum Constants {
        static let itemPad: CGFloat = 8
        static let numberItems: CGFloat = 3
    }
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 20, bottom: 100, right: 20)
        
        let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - (Constants.itemPad * (Constants.numberItems - 1))
        
        let itemWidth = availableWidth / Constants.numberItems
        let itemHeight = itemWidth * 1.5
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.minimumLineSpacing = Constants.itemPad
        self.minimumInteritemSpacing = Constants.itemPad
    }
}


