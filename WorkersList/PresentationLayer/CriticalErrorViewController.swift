//
//  CriticalErrorViewController.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 12.11.2021.
//

import UIKit

class CriticalErrorViewController: UIViewController {
    
    private lazy var informationStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImageView(image: UIImage(named: "saucer.png"))
        image.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 56),
            image.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        let label = UILabel()
        label.text = "The supermind broke everything"
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        let detail = UILabel()
        detail.text = "We will try to fix it quickly"
        detail.font = UIFont(name: "Inter-Regular", size: 16)
        detail.textColor = Colors.lightGreyTextColor
        
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        button.setTitleColor(Colors.tapBarCollectionViewBottomUnderline, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(detail)
        stack.addArrangedSubview(button)
        
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(informationStack)
        
        NSLayoutConstraint.activate([
            informationStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            informationStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationStack.heightAnchor.constraint(equalToConstant: 150),
            informationStack.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    @objc func buttonAction(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
}
