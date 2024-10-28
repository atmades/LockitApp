import UIKit

extension UITableViewCell {
    private static func get<T: UITableViewCell>(from tableView: UITableView, at indexPath: IndexPath) -> T {
        return tableView.dequeueCell(for: indexPath) as T
    }
    static func get(from tableView: UITableView, at indexPath: IndexPath) -> Self {
        return UITableViewCell.get(from: tableView, at: indexPath)
    }
}

//extension UITableViewCell: RoundCellStyleProtocol {
//    func setRoundStyle(row: Int, count: Int) {
//        let corners: CACornerMask
//        let radius: CGFloat = 20
//        if row == 0 && count == 1 {
//            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        } else if row == 0 {
//            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        } else if row == count - 1 {
//            corners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        } else {
//            corners = []
//        }
//        layer.maskedCorners = corners
//        layer.cornerRadius = radius
//    }
//}
