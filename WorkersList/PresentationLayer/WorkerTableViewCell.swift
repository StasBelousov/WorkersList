//
//  TableViewCell.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import UIKit

class WorkerTableViewCell: UITableViewCell {
    
    let workerName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        workerName.translatesAutoresizingMaskIntoConstraints = false
        workerName.font = UIFont.systemFont(ofSize: 15)
        
        contentView.addSubview(workerName)
        
        NSLayoutConstraint.activate([
            workerName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            workerName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            workerName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            workerName.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
