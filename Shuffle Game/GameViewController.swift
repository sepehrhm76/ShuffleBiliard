//
//  GameViewController.swift
//  Shuffle Game
//
//  Created by sepehr hajimohammadi on 5/19/24.
//

import UIKit
import SPCodebase

class GameViewController: BaseViewController {
    
    private var currentPlayer: Player?
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    private var isSlideInMenuPresented = false
    
    private var selectedRow = 0
    
    private var colorBalls = [2,3,4,5,6,7]
    
    private var undoArray: [Int] = []
    
    private lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.50
    
    private lazy var addRedBallButton = AddOrRemoveRedBallsButton()
    
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
        button.tag = 1
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = Typography.b30()
        return label
    }()
    
    private lazy var redRemainingTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Red ball remaining:"
        label.font = Typography.b20()
        return label
    }()
    
    private lazy var redRemainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Typography.b24()
        return label
    }()
    
    private lazy var showBallTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Show ball:"
        label.font = Typography.b20()
        return label
    }()
    
    private lazy var showBallButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var redPotsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Red ball pots:"
        label.font = Typography.b20()
        return label
    }()
    
    private lazy var selectColorPotsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Select color balls:"
        label.font = Typography.b20()
        return label
    }()
    
    private lazy var dropdownButton: SPCustomButton = {
        let button = SPCustomButton(type: .system)
        button.setImage(UIImage(systemName: "cricket.ball"), for: .normal)
        button.backgroundColor = .systemOrange
        button.tintColor = .white
        button.tag = 3
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dropdownMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.isHidden = true
        return view
    }()
    
    private lazy var undoButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = .lightGray
        button.isHidden = true
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        button.tintColor = .darkGray
        button.tag = 4
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorPotsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Color balls potted:"
        label.font = Typography.b20()
        return label
    }()
    
    private lazy var colorBallsPottedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Typography.b24()
        return label
    }()
    
    private lazy var endTurnButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = .systemGreen
        button.setTitle("End turn", for: .normal)
        button.tag = 5
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainMenu.players.shuffle()
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
        
        view.addSubview(nameLabel)
        nameLabel.spAlignCenterX()
        nameLabel.spAlignTopEdge(constant: 80.0)
        nameLabel.spSetSize(height: 30.0)
        
        view.addSubview(redRemainingTitleLabel)
        redRemainingTitleLabel.spAlignLeadingEdge(constant: 20.0)
        redRemainingTitleLabel.spAlignTopEdge(targetView: nameLabel, targetSide: .bottom, constant: 40.0)
        redRemainingTitleLabel.spSetSize(height: 30.0)
        
        view.addSubview(redRemainingLabel)
        redRemainingLabel.spAlignLeadingEdge(targetView: redRemainingTitleLabel, targetSide: .trailing, constant: 10.0)
        redRemainingLabel.spAlignBottomEdge(targetView: redRemainingTitleLabel, targetSide: .bottom)
        redRemainingLabel.spSetSize(height: 30.0)
        
        view.addSubview(showBallTitleLabel)
        showBallTitleLabel.spAlignLeadingEdge(constant: 20.0)
        showBallTitleLabel.spAlignTopEdge(targetView: redRemainingTitleLabel, targetSide: .bottom, constant: 40.0)
        showBallTitleLabel.spSetSize(height: 30.0)
        
        view.addSubview(showBallButton)
        showBallButton.spAlignLeadingEdge(targetView: showBallTitleLabel, targetSide: .trailing, constant: 10.0)
        showBallButton.spAlignBottomEdge(targetView: showBallTitleLabel, targetSide: .bottom)
        showBallButton.spSetSize(width: 35.0 ,height: 35.0)
        
        view.addSubview(redPotsTitleLabel)
        redPotsTitleLabel.spAlignLeadingEdge(constant: 20.0)
        redPotsTitleLabel.spAlignTopEdge(targetView: showBallTitleLabel, targetSide: .bottom, constant: 40.0)
        redPotsTitleLabel.spSetSize(height: 30.0)
        
        view.addSubview(addRedBallButton)
        addRedBallButton.spAlignLeadingEdge(targetView: redPotsTitleLabel, targetSide: .trailing, constant: 10.0)
        addRedBallButton.spAlignBottomEdge(targetView: redPotsTitleLabel, targetSide: .bottom)
        addRedBallButton.spSetSize(width: 140.0, height: 40.0)
        
        view.addSubview(selectColorPotsTitleLabel)
        selectColorPotsTitleLabel.spAlignLeadingEdge(constant: 20.0)
        selectColorPotsTitleLabel.spAlignTopEdge(targetView: redPotsTitleLabel, targetSide: .bottom, constant: 40.0)
        selectColorPotsTitleLabel.spSetSize(height: 30.0)
        
        view.addSubview(dropdownButton)
        dropdownButton.spAlignLeadingEdge(targetView: selectColorPotsTitleLabel, targetSide: .trailing, constant: 10.0)
        dropdownButton.spAlignBottomEdge(targetView: selectColorPotsTitleLabel, targetSide: .bottom)
        dropdownButton.spSetSize(width: 35.0, height: 35.0)
        
        view.addSubview(dropdownMenu)
        dropdownMenu.spAlignCenterX()
        dropdownMenu.spAlignBottomEdge(targetView: dropdownButton, targetSide: .top, constant: -10)
        dropdownMenu.spSetSize(width: 180.0, height: 180.0)
        
        view.addSubview(undoButton)
        undoButton.spAlignLeadingEdge(targetView: dropdownButton, targetSide: .trailing, constant: 10.0)
        undoButton.spAlignBottomEdge(targetView: dropdownButton, targetSide: .bottom)
        undoButton.spSetSize(width: 35.0, height: 35.0)
        
        view.addSubview(colorPotsTitleLabel)
        colorPotsTitleLabel.spAlignLeadingEdge(constant: 20.0)
        colorPotsTitleLabel.spAlignTopEdge(targetView: selectColorPotsTitleLabel, targetSide: .bottom, constant: 40.0)
        colorPotsTitleLabel.spSetSize(height: 30.0)
        
        view.addSubview(colorBallsPottedLabel)
        colorBallsPottedLabel.spAlignLeadingEdge(targetView: colorPotsTitleLabel, targetSide: .trailing, constant: 10.0)
        colorBallsPottedLabel.spAlignBottomEdge(targetView: colorPotsTitleLabel, targetSide: .bottom)
        colorBallsPottedLabel.spSetSize(height: 30.0)
        
        view.addSubview(endTurnButton)
        endTurnButton.spAlignAllEdgesExceptTop(leadingConstant: 20.0, trailingConstant: -20.0, bottomConstant: -50.0)
        endTurnButton.spSetSize(height: SPCustomButton.buttonHeight)
        
        if MainMenu.players.count > 0 {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            playersTableView.selectRow(at: firstIndexPath, animated: false, scrollPosition: .none)
            tableView(playersTableView, didSelectRowAt: firstIndexPath)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        updateDropdownMenu()
    }
    
    private func setupPlayersDetailView(player: Player) {
        nameLabel.text = "\(player.name)'s Turn"
        redRemainingLabel.text = "\(player.redRemaining)"
        colorBallsPottedLabel.text = "\(player.coloredPottedBalls)"
        addRedBallButton.quantityCounter = player.redPottedBalls
        addRedBallButton.updateAddButtonUiToQuantityCounterTitle()
    }
    
    private func toggleSideMenu() {
        if isSlideInMenuPresented {
            closeSideMenu()
        } else {
            openSideMenu()
        }
    }
    
    private func openSideMenu() {
        view.bringSubviewToFront(menuView)
        dropdownMenu.isHidden = true
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
    
    private func showPasswordAlert(for player: Player) {
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
    
    private func updateDropdownMenu() {
        dropdownMenu.subviews.forEach { $0.removeFromSuperview() }
        
        var lastButton: UIButton?
        
        for (index, item) in colorBalls.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(String(item), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(dropdownItemTapped(_:)), for: .touchUpInside)
            
            dropdownMenu.addSubview(button)
            button.spAlignLeadingAndTrailingEdges()
            
            if let lastButton = lastButton {
                button.spAlignTopEdge(targetView: lastButton, targetSide: .bottom)
            } else {
                button.spAlignTopEdge()
            }
            lastButton = button
        }
    }
    
    @objc private func dropdownItemTapped(_ sender: UIButton) {
        let index = sender.tag
        feedbackGenerator.impactOccurred()
        if index < colorBalls.count {
            let value = colorBalls[index]
            currentPlayer?.coloredPottedBalls.append(value)
            MainMenu.savePlayerData(player: currentPlayer!)
            undoButton.isHidden = false
            undoArray.append(value)
            colorBalls.remove(at: index)
            updateDropdownMenu()
            setupPlayersDetailView(player: currentPlayer!)
        }
    }
    
    @objc private func sideMenuButtonTapped() {
        toggleSideMenu()
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        closeSideMenu()
        dropdownMenu.isHidden = true
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
        switch sender.tag {
        case 1:
            MainMenu.players.removeAll()
            self.navigationController?.pushViewController(MainMenu(), animated: true)
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        case 2:
            showPasswordAlert(for: currentPlayer!)
        case 3:
            dropdownMenu.isHidden.toggle()
            print(MainMenu.players)
        case 4:
            let a = undoArray.last
            undoArray.removeLast()
            currentPlayer?.coloredPottedBalls.removeLast()
            MainMenu.savePlayerData(player: currentPlayer!)
            colorBalls.append(a!)
            if undoArray.isEmpty == true {
                undoButton.isHidden = true
            }
            updateDropdownMenu()
            setupPlayersDetailView(player: currentPlayer!)
        case 5:
            undoArray.removeAll()
            undoButton.isHidden = true
            dropdownMenu.isHidden = true
            currentPlayer?.redPottedBalls = addRedBallButton.quantityCounter
            currentPlayer?.isPlayerTurn = false
            MainMenu.savePlayerData(player: currentPlayer!)
            if MainMenu.players.count > 0 {
                selectedRow = (selectedRow + 1) % MainMenu.players.count
                let nextIndexPath = IndexPath(row: selectedRow, section: 0)
                playersTableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
                tableView(playersTableView, didSelectRowAt: nextIndexPath)
            }
        default:
            break
        }
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainMenu.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.textLabel?.text = MainMenu.players[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPlayer = MainMenu.players[indexPath.row]
        currentPlayer?.isPlayerTurn = true
        MainMenu.savePlayerData(player: currentPlayer!)
        addRedBallButton.minQuantity = currentPlayer!.redPottedBalls
        addRedBallButton.quantityCounter = addRedBallButton.minQuantity
        setupPlayersDetailView(player: currentPlayer!)
    }
}
