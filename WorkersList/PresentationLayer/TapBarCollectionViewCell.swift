//
//  TapBarCollectionViewCell.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 07.11.2021.
//

import UIKit

class TapBarCollectionViewCell: UICollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 15)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView(frame: CGRect(x: 0,
                                                 y: self.frame.height - 2,
                                                 width: nameLabel.frame.width,
                                                 height: 2))
        underlineView.backgroundColor = UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.isHidden = true
        return underlineView
    }()
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bottomUnderlineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            self.bottomUnderlineView.isHidden = self.isSelected ? false : true
        }
    }
    
    func setUp(text: String) {
        nameLabel.text = text
    }
    
}
