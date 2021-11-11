//
//  TableViewCell.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import UIKit

class WorkerTableViewCell: UITableViewCell {
    
    let workerImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "default_logo.png")
        image.layer.cornerRadius = image.frame.height / 2
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let workerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.workerTableViewCellNameLabel
        label.font = UIFont(name: "Inter-Medium", size: 16)
        return label
    }()
    
    let workerPosition: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.workerTableViewCellPosition
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        infoStackView.addArrangedSubview(workerName)
        infoStackView.addArrangedSubview(workerPosition)
        contentView.addSubview(infoStackView)
        contentView.addSubview(workerImage)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            workerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            workerImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            workerImage.trailingAnchor.constraint(equalTo: infoStackView.leadingAnchor, constant: -16),
            workerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            workerImage.heightAnchor.constraint(equalToConstant: 72),
            workerImage.widthAnchor.constraint(equalToConstant: 72),
            
            infoStackView.heightAnchor.constraint(equalToConstant: 45),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setImage(image: UIImage) {
        workerImage.image = image
        workerImage.clipsToBounds = true
        workerImage.layer.cornerRadius = workerImage.frame.height / 2
    }
    
    func setData(cellData: Item) {
        
        workerName.text = "\(cellData.firstName ?? "") \( cellData.lastName ?? "")"
        workerPosition.text = cellData.departmentTitle
    }
    
}
