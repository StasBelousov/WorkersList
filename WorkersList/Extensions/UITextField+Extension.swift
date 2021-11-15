//
//  UITextField+Extension.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 10.11.2021.
//

import UIKit

extension UITextField {

    func setIcon(_ image: String) {

        let iconView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))

        iconView.image = UIImage(named: image)

        let iconContainerView = UIView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))

        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

