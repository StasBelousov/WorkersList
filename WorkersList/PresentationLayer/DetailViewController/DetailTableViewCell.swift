//
//  DetailTableViewCell.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 15.11.2021.
//


import UIKit

class DetailTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let birthdayButton = "Date of birth unknown"
        static let phoneButton = "Phone number unknown"
    }
    
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
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let workerPosition: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.workerTableViewCellPosition
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    var birthdayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setTitle(Constants.birthdayButton, for: .normal)
        let image = UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var phoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setTitle(Constants.phoneButton, for: .normal)
        let image = UIImage(systemName: "phone")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
   
    //MARK: Override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        infoStackView.addArrangedSubview(workerImage)
        infoStackView.addArrangedSubview(workerName)
        infoStackView.addArrangedSubview(workerPosition)
        contentView.addSubview(infoStackView)
        contentView.addSubview(birthdayButton)
        contentView.addSubview(phoneButton)
        
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            
            workerImage.heightAnchor.constraint(equalToConstant: 104),
            workerImage.widthAnchor.constraint(equalToConstant: 104),
            
            workerName.heightAnchor.constraint(equalToConstant: 28),
            
            workerPosition.heightAnchor.constraint(equalToConstant: 18),
            
            infoStackView.heightAnchor.constraint(equalToConstant: 200),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 72),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            birthdayButton.heightAnchor.constraint(equalToConstant: 75),
            birthdayButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            birthdayButton.widthAnchor.constraint(equalToConstant: 250),
            birthdayButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 20),
            
            phoneButton.heightAnchor.constraint(equalToConstant: 75),
            phoneButton.widthAnchor.constraint(equalToConstant: 250),
            phoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            phoneButton.topAnchor.constraint(equalTo: birthdayButton.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup functions
    func setImage(image: UIImage) {
        workerImage.image = image
        workerImage.clipsToBounds = true
        workerImage.layer.cornerRadius = workerImage.frame.height / 2
    }
    
    func setData(cellData: Item) {
        workerName.text = "\(cellData.firstName ?? "") \( cellData.lastName ?? "")"
        workerPosition.text = cellData.position
        
        if let number = cellData.phone {
            let formattedNumber = "+7 \(number)"
            phoneButton.setTitle(formattedNumber, for: .normal)
        }
        if let birthday = cellData.birthday {
            let dateFormatter = DateFormatter(format: "yyyy.MM.dd")
            
            let date =
                birthday.lowercased().toDateString(dateFormatter: dateFormatter, outputFormat: "dd MMMM yyyy")
            
            birthdayButton.setTitle(date, for: .normal)
        
        }
        phoneButton.addTarget(self, action: #selector(phoneButtonPressed), for: .touchUpInside)
        
    }
    
    //MARK: Actions
    @objc func phoneButtonPressed() {
        
        if phoneButton.title(for: .normal) != Constants.phoneButton, let url = NSURL(string: "tel://\(String(describing: phoneButton.title))") as URL?, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

