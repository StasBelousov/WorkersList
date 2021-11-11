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
    
    private let imageService = ImageService()
    private var loadingAccess = true
    private var tapBarValues = [String]()
    private var workers = [Item]()
    private var filteredWorkers = [Item]()
    private var isFiltering = false
    private var selectedDepartment = String()
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else {
            searchedWorker = String()
            return false }
        
        return text.isEmpty
    }
    private var isSearching: Bool {
        return !searchBarIsEmpty
    }
    private var searchedWorker = String()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundImage = UIImage()
        bar.searchBarStyle = .minimal
        bar.returnKeyType = .done
        bar.searchTextField.backgroundColor = Colors.lightGrey
        bar.setBookmark()
        bar.tintColor = Colors.tapBarCollectionViewBottomUnderline
        bar.searchTextField.setIcon("search.png")
        bar.placeholder = "Enter name, tag, email..."
        bar.delegate = self
        return bar
    }()
    
    lazy var collectionview: UICollectionView = {
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
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var topUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Colors.backgroundUnderline
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var nobodyFoundView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView(image: UIImage(named: "magnifying-glass.png"), highlightedImage: nil)
        image.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = "Nobody found"
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        let detail = UILabel()
        detail.text = "Please, try to change the request"
        detail.font = UIFont(name: "Inter-Regular", size: 16)
        detail.textColor = Colors.lightGreyTextColor
        
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(detail)
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWorkers()
        collectionview.delegate = self
        collectionview.dataSource = self
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        view.addSubview(collectionview)
        view.addSubview(tableView)
        view.addSubview(topUnderlineView)
        view.addSubview(nobodyFoundView)
        view.backgroundColor = .white
        
        nobodyFoundView.isHidden = true
        
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        hideKeyboardWhenTappedAround()
        
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            collectionview.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionview.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: collectionview.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topUnderlineView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            topUnderlineView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topUnderlineView.heightAnchor.constraint(equalToConstant: 1),
            
            nobodyFoundView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor, constant: 180),
            nobodyFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nobodyFoundView.heightAnchor.constraint(equalToConstant: 120),
            nobodyFoundView.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.setBookmark()
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
                    self.filteredWorkers = self.workers
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
    private func searchWorker() {
        filteredWorkers = workers
        isFiltering = true
        if isFiltering, selectedDepartment != "All", !selectedDepartment.isEmpty {
            
            filteredWorkers = workers.filter(
                {(worker: Item) -> Bool in
                    return worker.departmentTitle!.contains(selectedDepartment)
                })
        }
        if isSearching {
            filteredWorkers = filteredWorkers.filter({ (worker: Item) -> Bool in
                return worker.firstName!.lowercased().contains(searchedWorker.lowercased())
            })
        }
    }
    
    //MARK: Actions
    
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfWorkers = isFiltering ? filteredWorkers.count : workers.count
        nobodyFoundView.isHidden = !(numberOfWorkers == 0)
        return numberOfWorkers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCell, for: indexPath) as! WorkerTableViewCell
        let cellData = isFiltering ? filteredWorkers[indexPath.row] : workers[indexPath.row]
        
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
        //            cell. = true
        //        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tapBarValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let depertmentName = tapBarValues[indexPath.row]
        isFiltering = true
        selectedDepartment = depertmentName
        searchWorker()
        tableView.reloadData()
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

//MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedWorker = searchText
        searchWorker()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    
}

