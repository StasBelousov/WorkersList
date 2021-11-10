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
    
    var tapBarValues: [String] = []
    
    let collectionview: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 10
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
    
    private lazy var topUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.765, green: 0.765, blue: 0.776, alpha: 0.5)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
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
        view.addSubview(topUnderlineView)
        view.backgroundColor = .white
        
        
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            // Constrain the container view to the view controller
            collectionview.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            collectionview.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 16),
            collectionview.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -16),
            collectionview.heightAnchor.constraint(equalToConstant: 36),
            
            //Constrain the tableview to the view controller
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.collectionview.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            topUnderlineView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            topUnderlineView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topUnderlineView.heightAnchor.constraint(equalToConstant: 1)
            
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
                    for worker in self.workers {
                        if let department = worker.departmentTitle {
                            if !self.tapBarValues.contains(department) {
                                self.tapBarValues.append(department)
                            }
                        }
                    }
                    self.tapBarValues.insert("All", at: 0)
                    self.loadingAccess = true
                case .failure(let error):
                    print(error)
                }
                self.collectionview.reloadData()
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
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: indexPath) as? TapBarCollectionViewCell else {
            fatalError("Collection View Cell class not found.")
        }
        cell.setupUI(text: tapBarValues[indexPath.row])
//        if indexPath.row == 0 {
//            cell.isSelected = true
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tapBarValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Add more space left and right the tab
        let addSpace: CGFloat = 16
        let tabTitle = tapBarValues[indexPath.row]
        let tabSize = CGSize(width: 500, height: collectionview.frame.height)
        let titleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        // Calculate the width of the Tab Title string
        let titleWidth = NSString(string: tabTitle).boundingRect(with: tabSize, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).size.width
        
        let tabWidth = titleWidth + addSpace
        
        return CGSize(width: tabWidth, height: collectionview.frame.height)
    }
    
}
