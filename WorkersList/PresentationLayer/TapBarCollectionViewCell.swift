//
//  TapBarCollectionViewCell.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 07.11.2021.
//

import UIKit

class TapBarCollectionViewCell: UICollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.lightGreyTextColor
        label.font = UIFont(name: "Inter-Medium", size: 15)
        label.textAlignment = .center
      
        return label
    }()
    
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Colors.tapBarCollectionViewBottomUnderline
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.isHidden = true
        return underlineView
    }()
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bottomUnderlineView)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            bottomUnderlineView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            bottomUnderlineView.widthAnchor.constraint(equalTo: self.widthAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: 2)
    ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            self.bottomUnderlineView.isHidden = self.isSelected ? false : true
        }
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            nameLabel.text = ""
        }
    
    func setupUI(text: String) {
        nameLabel.text = text
//        if text == "All" {
//            bottomUnderlineView.isHidden = false
//        }
    }
    
}
