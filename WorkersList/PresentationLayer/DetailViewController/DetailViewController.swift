//
//  DetailViewController.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 15.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    private enum Constants {
        static let tableViewCell = "DetailCellId"
    }
    
    var workerData: Item?
    var logoImage: UIImage?
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "back.png")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissFunc), for: .touchUpInside)
        return button
    }()
    
    lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: Constants.tableViewCell)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(detailTableView)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            
            detailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailTableView.topAnchor.constraint(equalTo: view.topAnchor),
            detailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func dismissFunc() {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCell, for: indexPath) as! DetailTableViewCell
        
        if let data = workerData {
            cell.setData(cellData: data)
        }
        if let image = logoImage {
            cell.setImage(image: image) 
        }
        
        return cell
    }
    
}
