//
//  UITableViewCell+Extension.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
