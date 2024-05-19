//
//  GameViewController.swift
//  Shuffle Game
//
//  Created by sepehr hajimohammadi on 5/19/24.
//

import UIKit
import SPCodebase

class GameViewController: BaseViewController {
    
    private var isSlideInMenuPresented = false
    
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
        
        print(playersDetail)
        
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
        exitButton.spAlignAllEdgesExceptTop(bottomConstant: -50.0)
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
    
    private func showPasswordAlert(for indexPath: IndexPath) {
        let player = playersDetail[indexPath.row]
        let alertController = UIAlertController(title: "Enter Password", message: "Please enter the password:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let password = alertController.textFields?.first?.text, password == player.password {
                self.showBallInfoAlert(for: player)
            } else {
                self.showErrorMessage(in: alertController)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showBallInfoAlert(for player: Player) {
        let ballAlertController = UIAlertController(title: "\(player.name)'s Ball", message: "Your ball is \(player.ball)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ballAlertController.addAction(okAction)
        present(ballAlertController, animated: true, completion: nil)
    }
    
    private func showErrorMessage(in alertController: UIAlertController) {
        let errorMessage = NSAttributedString(string: "Password incorrect. Please try again.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        alertController.setValue(errorMessage, forKey: "attributedMessage")
        alertController.textFields?.first?.text = ""
        present(alertController, animated: true, completion: nil)
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
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Show ball") { _, _, completionHandler in
            self.showPasswordAlert(for: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
}


