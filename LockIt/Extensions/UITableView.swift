import UIKit

extension UITableView {
    func setAutoDimension() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
    }

    func setup(target: UITableViewDelegate & UITableViewDataSource) {
        setAutoDimension()

        tableFooterView = UIView()
        separatorStyle = .none
        delegate = target
        dataSource = target
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(header: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}
