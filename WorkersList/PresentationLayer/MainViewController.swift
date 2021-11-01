//
//  ViewController.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 30.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private let cellId = "cellId"

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: WorkerTableViewCell.self)
        tableView.register(WorkerTableViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var workers = [Item]()
    private let imageService = ImageService()
    private var loadingAccess = true

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWorkers()
        view.backgroundColor = .red
        
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
        ])
    }
    
    //MARK: Data request
    private func fetchWorkers() {
        loadingAccess = false
        APIService.shared.fetchCharacters() { [weak self] fetchResult in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch fetchResult {
                case .success(let fetchedItems):
                    self.workers.append(contentsOf: fetchedItems.items ?? [])
                    print(self.workers.count)
                    self.loadingAccess = true
                case .failure(let error):
                    print(error)
                }
                self.tableView.reloadData()
                self.tableView.tableFooterView?.isHidden = true
            }
        }
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkerTableViewCell
        let cellData = workers[indexPath.row]
        
        DispatchQueue.main.async {
            if let urlString = cellData.avatarURL {
                self.imageService.download(at: urlString) { image in
                    guard let avatar = image else { return }
                    cell.cornerRadius(image: avatar)
                    cell.imageView?.layer.cornerRadius = 36
                }
            }
        }
       
        
        cell.workerName.text = cellData.firstName
        cell.workerPosition.text = cellData.position
        cell.selectionStyle = .none
        cell.imageView?.layer.cornerRadius = 36
        
//        let cell = tableView.dequeue(cellClass: WorkerTableViewCell.self, forIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
}
