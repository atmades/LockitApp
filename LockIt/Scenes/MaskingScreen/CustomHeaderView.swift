import UIKit

class CustomHeaderView: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.text = "Select app icon:"
        label.textAlignment = .center
        backgroundColor = .clear
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
