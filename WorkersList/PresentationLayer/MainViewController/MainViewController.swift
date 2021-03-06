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
        static let gradietCellId = "gradietCellId"
    }
    
    private let imageService = ImageService()
    private var loadingAccess = false
    private var tapBarValues = [String]()
    private var workers = [Item]()
    private var filteredWorkers: [Item] = [] {
        didSet { mainTableView.reloadData() }
    }
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
    var buttomSheet: filterMode = .none {
        didSet { searchWorker() }
    }
    private var shouldDetailControllerDismiss = false
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundImage = UIImage()
        bar.searchBarStyle = .minimal
        bar.returnKeyType = .search
        bar.searchTextField.backgroundColor = Colors.backgroudWhite
        // bar.setBookmark()
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refresh
    }()
    
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: WorkerTableViewCell.self)
        tableView.register(WorkerTableViewCell.self, forCellReuseIdentifier: Constants.tableViewCell)
        tableView.register(GradienTableViewCell.self, forCellReuseIdentifier: Constants.gradietCellId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.addSubview(refreshControl)
        return tableView
    }()
    
    private lazy var topUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Colors.backgroundUnderline
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var nobodyFoundView: UIStackView = {
        let image = UIImageView(image: UIImage(named: "magnifying-glass.png"), highlightedImage: nil)
        image.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = "Nobody found"
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        let detail = UILabel()
        detail.text = "Please, try to change the request"
        detail.font = UIFont(name: "Inter-Regular", size: 16)
        detail.textColor = Colors.lightGreyTextColor
        
        let stack = UIStackView(arrangedSubviews: [image, label, detail])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    //MARK: Override ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        view.addSubview(collectionview)
        view.addSubview(mainTableView)
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
            
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.topAnchor.constraint(equalTo: collectionview.bottomAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topUnderlineView.bottomAnchor.constraint(equalTo: mainTableView.topAnchor),
            topUnderlineView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topUnderlineView.heightAnchor.constraint(equalToConstant: 1),
            
            nobodyFoundView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor, constant: 180),
            nobodyFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nobodyFoundView.heightAnchor.constraint(equalToConstant: 120),
            nobodyFoundView.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    //MARK: Override viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        setBookmark()
        fetchWorkers()
    }
    
    //MARK: Data request
    private func fetchWorkers() {
        loadingAccess = false
        APIService.shared.fetchCharacters() { [weak self] fetchResult in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch fetchResult {
                case .success(let fetchedItems):
                    self.filteredWorkers.removeAll()
                    self.tapBarValues.removeAll()
                    self.workers.removeAll()
                    self.workers.append(contentsOf: fetchedItems.items)
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
                    let newViewController = CriticalErrorViewController()
                    newViewController.modalPresentationStyle = .fullScreen
                    self.present(newViewController, animated: true)
                    print(error)
                }
                self.collectionview.reloadData()
                self.mainTableView.reloadData()
                self.mainTableView.tableFooterView?.isHidden = true
            }
        }
    }
    
    //MARK: Sorting funcions
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
                let result = (worker.firstName ?? "") + (worker.lastName ?? "") + (worker.userTag ?? "")
                return result.lowercased().contains(searchedWorker.lowercased())
            })
        }
        
        if let button = searchBar.searchTextField.rightView as? UIButton {
            switch buttomSheet {
            case .none:
                button.isSelected = false
            case .alphabet:
                button.isSelected = true
                filteredWorkers = filteredWorkers.sorted {
                    var isSorted = false
                    if let firstItem = $0.firstName, let secondItem = $1.firstName {
                        isSorted = firstItem.lowercased() < secondItem.lowercased()
                    }
                    return isSorted
                }
            case .birthday:
                button.isSelected = true
                filteredWorkers = filteredWorkers.sorted {
                    var isSorted = false
                    if let firstItem = $0.birthday, let secondItem = $1.birthday {
                        isSorted = firstItem.lowercased() < secondItem.lowercased()
                    }
                    return isSorted
                }
            }
        }
    }
    
    func setBookmark() {
        searchBar.showsBookmarkButton = true
        if let button = searchBar.searchTextField.rightView as? UIButton {
            button.setImage(UIImage(named: "mark_grey.png"), for: .normal)
            button.setImage(UIImage(named: "mark_color.png"), for: .highlighted)
            button.setImage(UIImage(named: "mark_color.png"), for: .selected)
            button.addTarget(self, action: #selector(self.presentModalController(_:)), for: .touchDown)
        }
    }
    
    //MARK: Actions
    @objc func refresh(_ sender: AnyObject) {
        fetchWorkers()
        searchBar.text = nil
        buttomSheet = .none
        sender.endRefreshing()
    }
    
    @objc func presentModalController(_ sender: AnyObject) {
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.buttomSheet = buttomSheet
        
         
        self.present(vc, animated: true, completion: nil)
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfWorkers = isFiltering ? filteredWorkers.count : workers.count
        let resultNumberOfWorkers = loadingAccess ? numberOfWorkers : 10
        nobodyFoundView.isHidden = !(resultNumberOfWorkers == 0)
        return resultNumberOfWorkers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if loadingAccess {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCell, for: indexPath) as! WorkerTableViewCell
            
            let cellData = isFiltering ? filteredWorkers[indexPath.row] : workers[indexPath.row]
            
            if let urlString = cellData.avatarURL {
                self.imageService.download(at: urlString) { image in
                    guard let avatar = image else { return }
                    if self.loadingAccess {
                        cell.setImage(image: avatar)
                    }
                }
            }
            cell.setData(cellData: cellData)
            cell.birthdayLabel.text = buttomSheet == .birthday ? cellData.formattedBirthday : ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.gradietCellId, for: indexPath) as! GradienTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard loadingAccess else { return }
        let detail = DetailViewController()
        detail.modalPresentationStyle = .fullScreen
        detail.workerData = isFiltering ? filteredWorkers[indexPath.row] : workers[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! WorkerTableViewCell
        detail.logoImage = cell.workerImage.image
        self.present(detail, animated:true, completion: nil)
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        isFiltering = true
        searchBar.setShowsCancelButton(false, animated: true)
        searchWorker()
    }
    
}

