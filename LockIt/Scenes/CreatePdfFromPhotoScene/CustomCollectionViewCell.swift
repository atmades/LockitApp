import UIKit


protocol CustomCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: CustomCollectionViewCell)
}

class CustomCollectionViewCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let deleteButton = UIButton(type: .system)
    
    weak var delegate: CustomCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayout()
        backgroundColor = .cyan
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }


    @objc private func deleteButtonTapped() {
//        NotificationCenter.default.post(name: NSNotification.Name("DeleteCell"), object: self)
        delegate?.didTapDeleteButton(in: self)
    }

    func configure(with image: UIImage) {
        imageView.image = image
    }
}
