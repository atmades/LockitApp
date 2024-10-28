import UIKit
import QuickLook
import PDFKit


class PDFCell: UITableViewCell {
    var pdfView: PDFView!
    
    //    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .blue
        selectionStyle = .none
        
        pdfView = PDFView()
        pdfView.autoScales = true
        
        contentView.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(pdfData: Data?) {
        guard let pdfData = pdfData else { return }
        if let document = PDFDocument(data: pdfData) {
              pdfView.document = document
            print(document)
          } else {
              print("Ошибка PDFCell : Невозможно создать PDF документ из переданных данных")
          }
    }
    
}
