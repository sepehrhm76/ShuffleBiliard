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
        view.isHidden = true
        return view
    }()
    
    private lazy var exitButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = .red
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
        
        view.backgroundColor = .systemGray6
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.setLeftBarButton(sideMenuButton, animated: false)
        
        view.addSubview(menuView)
        menuView.spAlignAllEdgesExceptTrailing(leadingConstant: -slideInMenuPadding)
        menuView.spSetSize(width: slideInMenuPadding)
        
        menuView.addSubview(playersTableView)
        playersTableView.spAlignAllEdgesExceptBottom()
        playersTableView.spAlignBottomEdge(targetView: menuView, targetSide: .centerY, constant: 30.0)
        
        menuView.addSubview(exitButton)
        exitButton.spAlignAllEdgesExceptTop(leadingConstant: 10.0, trailingConstant: -10.0, bottomConstant: -50.0)
        exitButton.spSetSize(height: 30.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
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
            self.menuView.frame.origin.x = 0.0
            self.menuView.isHidden = false
        } completion: { finished in
            self.isSlideInMenuPresented = true
        }
    }
    
    private func closeSideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
            self.menuView.frame.origin.x = -self.slideInMenuPadding
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
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            let newOriginX = menuView.frame.origin.x + translation.x
            if newOriginX >= -slideInMenuPadding && newOriginX <= 0 {
                menuView.isHidden = false
                menuView.frame.origin.x = newOriginX
                gesture.setTranslation(.zero, in: view)
            }
        case .ended:
            if velocity.x > 500 || (menuView.frame.origin.x > -slideInMenuPadding / 2 && velocity.x > -500) {
                openSideMenu()
            } else {
                closeSideMenu()
            }
        default:
            break
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
