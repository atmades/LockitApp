import UIKit

protocol TextViewCellDelegate: AnyObject {
    func textDidSet(_ text: String)
    
    func textViewDidBeginEditing(_ cell: TextViewCell)
    func textViewDidEndEditing(_ cell: TextViewCell)
    
    func updateCellHeight(_ cell: TextViewCell)
}

class TextViewCell: UITableViewCell {
    
    private enum Constants {
        static let textSettings: ControlSettings = Styles.Typography.Texts.Text14.text
    }
    
    private let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
    private let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
    var textView = UITextView()

    var placeholder = "" {
        didSet {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }
    
    var isRequired = false {
        didSet {
            if isRequired {
                placeholder = placeholder + " *"
            }
        }
    }
    var currentText: String? {
        didSet {
            textView.text = currentText
        }
    }
    
    weak var delegate: TextViewCellDelegate?
    let placeholderColor = UIColor.white.withAlphaComponent(0.3)
    let textColor = UIColor.white.withAlphaComponent(0.8)
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextViewCell {
    private func setupStyles() {
        textView.backgroundColor = UIColor(named: R.color.color_gray85.name)
        textView.layer.cornerRadius = 12
        textView.autocapitalizationType = .sentences
        textView.layer.masksToBounds = true
        textView.returnKeyType = .next
        textView.autocapitalizationType = .words
        textView.font = .makeAvenir(size: 16)
        textView.textColor = textColor
        
        textView.isScrollEnabled = false
        
        backgroundColor = .clear
        
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 14, bottom: 20, right: 14)
        
        textView.delegate = self
    }
    
    private func setupLayout() {
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
//            make.height.equalTo(300)
//            make.height.greaterThanOrEqualTo(300)

        }
    }
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholder {
            textView.text = nil
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         delegate?.textViewDidBeginEditing(self)
     }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.textColor = placeholderColor
        }  else {
            textView.textColor = textColor
        }
        delegate?.textDidSet(textView.text)
        delegate?.updateCellHeight(self)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing(self)
    }
}
