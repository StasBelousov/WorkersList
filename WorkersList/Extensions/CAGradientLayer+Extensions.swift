//
//  CAGradientLayer+Extensions.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 13.11.2021.
//

import UIKit

extension CAGradientLayer {
    
    func setupLayer(by: UIView) {
        self.frame = by.bounds
        self.cornerRadius = by.bounds.height / 2
        self.startPoint = CGPoint(x: 0, y: 0.5)
        self.endPoint = CGPoint(x: 1, y: 0.5)
    }

}
