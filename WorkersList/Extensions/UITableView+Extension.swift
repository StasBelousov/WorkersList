//
//  UITableView+Extension.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import UIKit

extension UITableView {
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(cellClass.reuseIdentifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
    func registerCell<T: UITableViewCell>(cellClass: T.Type) {
        register(UINib(nibName: cellClass.reuseIdentifier, bundle: nil),
                 forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}
