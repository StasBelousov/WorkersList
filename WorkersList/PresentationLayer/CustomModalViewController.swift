//
//  CustomModalViewController.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 13.11.2021.
//

import UIKit

class CustomModalViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sorting"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    var byAlphabetButton: UIButton {
        get {
            self.setupFilterButton(title: "By alphabet")
           }
    }
    
    var byBirthdayButton: UIButton {
        get {
            self.setupFilterButton(title: "By birthday")
           }
    }
       
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, byAlphabetButton,byBirthdayButton, spacer])
       
        stackView.axis = .vertical
        stackView.spacing = 40.0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    var buttomSheet: filterMode = .none
    
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep updated with new height
    var currentContainerHeight: CGFloat = 300
    
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    //MARK: Override ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupConstraints()
        setupPanGesture()
      
    }
    //MARK: Override viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    //MARK: Setup functions 
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    func setupFilterButton(title: String) -> UIButton {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        button.titleLabel?.textAlignment = .left
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "freeFilter.png"), for: .normal)
        switch buttomSheet {
        case .alphabet:
            if title == "By alphabet" {
            button.setImage(UIImage(named: "selectedFilter.png"), for: .normal)}
        case .birthday:
            if title == "By birthday" {
                button.setImage(UIImage(named: "selectedFilter.png"), for: .normal)}
        default:
            button.setImage(UIImage(named: "freeFilter.png"), for: .normal)
        }
        title == "By alphabet" ?
            button.addTarget(self, action: #selector(alphabetButtonPressed), for: .touchUpInside) :
            button.addTarget(self, action: #selector(birthdayButtonPressed), for: .touchUpInside)
        return button
    }
    
    
    //MARK: Animation functions
    func animatePresentContainer() {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    
    //MARK: Actions
    @objc func alphabetButtonPressed() {
        if let presenter = presentingViewController as? MainViewController {
            if buttomSheet != .alphabet {
                presenter.buttomSheet = .alphabet
            } else if buttomSheet == .alphabet {
                presenter.buttomSheet = .none
            }
            print(presenter.buttomSheet)
           }
       dismiss(animated: true, completion: nil)
    }
    
    @objc func birthdayButtonPressed() {
        if let presenter = presentingViewController as? MainViewController {
            if buttomSheet != .birthday {
                presenter.buttomSheet = .birthday
            } else if buttomSheet == .birthday {
                presenter.buttomSheet = .none
            }
            
            print(presenter.buttomSheet)
           }
       dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    //MARK: Constraints function
    func setupConstraints() {
        // 4. Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -26),
    
        
        dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
        dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        // set container static constraint (trailing & leading)
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // 6. Set container to default height
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
}
