//
//  GameViewController.swift
//  Shuffle Game
//
//  Created by sepehr hajimohammadi on 5/19/24.
//

import UIKit
import SPCodebase

class GameViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isSlideInMenuPresented = false
    private var playersDetail = MainMenu.players.shuffled()
    
    private lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.50
    
    private lazy var sideMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(sideMenuButtonTapped))
        return button
    }()
    
    private lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1022628322, green: 0.3703129888, blue: 0.286925137, alpha: 1)
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var exitButton: CustomButton = {
        let button = CustomButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 0.0
        button.setTitle("Exit", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var playersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlayerCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.setLeftBarButton(sideMenuButton, animated: false)
        
        view.addSubview(menuView)
        menuView.spAlignEdges(attribute: .all, margin: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -slideInMenuPadding))
        
        view.addSubview(containerView)
        containerView.spAlignEdges(attribute: .all)
        
        menuView.addSubview(playersTableView)
        playersTableView.spAlignAllEdgesExceptBottom()
        playersTableView.spAlignBottomEdge(targetView: menuView, targetSide: .centerY, constant: 30.0)
        
        menuView.addSubview(exitButton)
        exitButton.spAlignAllEdgesExceptTop(bottomConstant: -20.0)
        exitButton.spSetSize(height: 30.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        containerView.addGestureRecognizer(tapGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = .left
        containerView.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRightGesture.direction = .right
        containerView.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc private func sideMenuButtonTapped() {
        toggleSideMenu()
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if isSlideInMenuPresented {
            closeSideMenu()
        }
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left && isSlideInMenuPresented {
            closeSideMenu()
        } else if gesture.direction == .right && !isSlideInMenuPresented {
            openSideMenu()
        }
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        MainMenu.players.removeAll()
        self.navigationController?.pushViewController(MainMenu(), animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func toggleSideMenu() {
        if isSlideInMenuPresented {
            closeSideMenu()
        } else {
            openSideMenu()
        }
    }
    
    private func openSideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.containerView.frame.width - self.slideInMenuPadding
        } completion: { finished in
            self.isSlideInMenuPresented = true
        }
    }
    
    private func closeSideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = 0.0
        } completion: { finished in
            self.isSlideInMenuPresented = false
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.textLabel?.text = playersDetail[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection if needed
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Show ball") { (action, view, completionHandler) in
            
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}


