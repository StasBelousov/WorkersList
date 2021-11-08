//
//  ViewController.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 30.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private enum Constants {
        static let tableViewCell = "cellId"
        static let collectionViewCell = "CollectionViewCell"
        
    }
    
    let testArray = ["ALL", "iOS", "Android", "Admin", "Bob", "ALL", "iOS", "Android", "Admin", "Bob"]
    
    let collectionview: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collection.setCollectionViewLayout(layout, animated: true)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TapBarCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCell)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: WorkerTableViewCell.self)
        tableView.register(WorkerTableViewCell.self, forCellReuseIdentifier: Constants.tableViewCell)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var workers = [Item]()
    private let imageService = ImageService()
    private var loadingAccess = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWorkers()
        collectionview.delegate = self
        collectionview.dataSource = self
        
        view.addSubview(collectionview)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            // Constrain the container view to the view controller
            collectionview.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            collectionview.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 16),
            collectionview.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor),
            collectionview.heightAnchor.constraint(equalToConstant: 36),
            
            //Constrain the tableview to the view controller
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.collectionview.bottomAnchor),
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

//MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCell, for: indexPath) as! WorkerTableViewCell
        let cellData = workers[indexPath.row]
        
        if let urlString = cellData.avatarURL {
            self.imageService.download(at: urlString) { image in
                guard let avatar = image else { return }
                cell.setImage(image: avatar)
            }
        }
        
        cell.setData(cellData: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: indexPath) as? TapBarCollectionViewCell else {
            fatalError("Collection View Cell class not found.")
        }
        cell.setUp(text: testArray[indexPath.row])
        if indexPath.row == 0 {
            cell.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.setNeedsLayout()
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Add more space left and right the tab
        let addSpace: CGFloat = 20
        let tabTitle = testArray[indexPath.row]
        let tabSize = CGSize(width: 500, height: collectionview.frame.height)
        let titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        // Calculate the width of the Tab Title string
        let titleWidth = NSString(string: tabTitle).boundingRect(with: tabSize, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).size.width
        
        let tabWidth = titleWidth + addSpace
        
        return CGSize(width: tabWidth, height: collectionview.frame.height)
    }
    
}
