//
//  GradienTableViewCell.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 13.11.2021.
//

import UIKit

class GradienTableViewCell: UITableViewCell {
    
    let workerImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage()
        image.layer.cornerRadius = image.frame.height / 2
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let workerImageLayer = CAGradientLayer()
    
    let workerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let workerNameLayer = CAGradientLayer()
    
    let workerPosition: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let workerPositionLayer = CAGradientLayer()
    
    let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 3
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let workerImageGroup = makeAnimationGroup()
        workerImageGroup.beginTime = 0.0
        workerImageLayer.add(workerImageGroup, forKey: "backgroundColor")
              
        let workerNameGroup = makeAnimationGroup(previousGroup: workerImageGroup)
        workerNameLayer.add(workerNameGroup, forKey: "backgroundColor")
        
        let workerPositionGroup = makeAnimationGroup(previousGroup: workerImageGroup)
        workerPositionLayer.add(workerPositionGroup, forKey: "backgroundColor")
        
        workerImage.layer.addSublayer(workerImageLayer)
        workerName.layer.addSublayer(workerNameLayer)
        workerPosition.layer.addSublayer(workerPositionLayer)
        
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
            
            infoStackView.heightAnchor.constraint(equalToConstant: 31),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            workerPosition.widthAnchor.constraint(equalToConstant: 80),
            workerPosition.heightAnchor.constraint(equalToConstant: 12),
            
            workerName.widthAnchor.constraint(equalToConstant: 145),
            workerName.heightAnchor.constraint(equalToConstant: 16)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
            workerImageLayer.setupLayer(by: workerImage)
            workerNameLayer.setupLayer(by: workerName)
            workerPositionLayer.setupLayer(by: workerPosition)
    }
  
}

extension GradienTableViewCell {
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
            let animDuration: CFTimeInterval = 1.5
            let firstAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
            firstAnimation.fromValue = Colors.gradientLightGrey.cgColor
            firstAnimation.toValue = Colors.gradientDarkGrey.cgColor
            firstAnimation.duration = animDuration
            firstAnimation.beginTime = 0.0

            let secondAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
            secondAnimation.fromValue = Colors.gradientDarkGrey.cgColor
            secondAnimation.toValue = Colors.gradientLightGrey.cgColor
            secondAnimation.duration = animDuration
            secondAnimation.beginTime = firstAnimation.beginTime + firstAnimation.duration

            let group = CAAnimationGroup()
            group.animations = [firstAnimation, secondAnimation]
            group.repeatCount = .greatestFiniteMagnitude
            group.duration = secondAnimation.beginTime + secondAnimation.duration
            group.isRemovedOnCompletion = false

            if let previousGroup = previousGroup {
                // Offset groups by 0.33 seconds for effect
                group.beginTime = previousGroup.beginTime + 0.33
            }
            return group
        }
}
