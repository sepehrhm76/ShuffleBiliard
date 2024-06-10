//
//  GameViewController.swift
//  Shuffle Game
//
//  Created by sepehr hajimohammadi on 5/19/24.
//

import UIKit
import SPCodebase

class GameViewController: BaseViewController {
    
    var currentPlayer: Player?
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    private var isSlideInMenuPresented = false
    
    private var selectedRow = 0
    
    private var eachTurnPitokCounter = 0
    
    private var eachTurnRedBallPottedCounter = 0
    
    private var playerRedRemainingKeeper = 0
    
    private var redBallsOnTable = 15
    
    private var colorBalls = [2,3,4,5,6,7]
    
    private var colorPottedBalls: [Int] = []
    
    private var undoColorBalls: [Int] = []
    
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
    
    private(set) lazy var addredBallButton: SPCustomButton = {
        let button = SPCustomButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        button.tintColor = .red
        button.tag = 3
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var redPotsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0"
        label.font = Typography.b24()
        return label
    }()
    
    private lazy var removeRedBallButton: SPCustomButton = {
        let button = SPCustomButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        button.setImage(UIImage(systemName: "circle.slash.fill"), for: .normal)
        button.tintColor = .red
        button.tag = 4
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
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
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemOrange
        button.tag = 5
        button.isEnabled = false
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
        button.tag = 6
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
    
    private lazy var pitokTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Pitoks:"
        label.font = Typography.b20()
        return label
    }()
    
    private(set) lazy var addPitokButton: SPCustomButton = {
        let button = SPCustomButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        button.tintColor = .white
        button.tag = 7
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pitokLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0"
        label.font = Typography.b24()
        return label
    }()
    
    private lazy var removePitokButton: SPCustomButton = {
        let button = SPCustomButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        button.tag = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var endTurnButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        button.setTitle("End turn", for: .normal)
        button.tag = 9
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
        
        view.addSubview(addredBallButton)
        addredBallButton.spAlignLeadingEdge(targetView: redPotsTitleLabel, targetSide: .trailing, constant: 10.0)
        addredBallButton.spAlignBottomEdge(targetView: redPotsTitleLabel, targetSide: .bottom)
        addredBallButton.spSetSize(width: 35.0, height: 35.0)
        
        view.addSubview(redPotsLabel)
        redPotsLabel.spAlignLeadingEdge(targetView: addredBallButton, targetSide: .trailing, constant: 15.0)
        redPotsLabel.spAlignBottomEdge(targetView: addredBallButton, targetSide: .bottom)
        redPotsLabel.spSetSize(height: 30.0)
        
        view.addSubview(removeRedBallButton)
        removeRedBallButton.spAlignLeadingEdge(targetView: redPotsLabel, targetSide: .trailing, constant: 15.0)
        removeRedBallButton.spAlignBottomEdge(targetView: redPotsLabel, targetSide: .bottom)
        removeRedBallButton.spSetSize(width: 35.0, height: 35.0)
        
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
        
        view.addSubview(pitokTitleLabel)
        pitokTitleLabel.spAlignLeadingEdge(constant: 20.0)
        pitokTitleLabel.spAlignTopEdge(targetView: colorPotsTitleLabel, targetSide: .bottom, constant: 40.0)
        pitokTitleLabel.spSetSize(height: 30.0)
        
        view.addSubview(addPitokButton)
        addPitokButton.spAlignLeadingEdge(targetView: pitokTitleLabel, targetSide: .trailing, constant: 10.0)
        addPitokButton.spAlignBottomEdge(targetView: pitokTitleLabel, targetSide: .bottom)
        addPitokButton.spSetSize(width: 35.0, height: 35.0)
        
        view.addSubview(pitokLabel)
        pitokLabel.spAlignLeadingEdge(targetView: addPitokButton, targetSide: .trailing, constant: 15.0)
        pitokLabel.spAlignBottomEdge(targetView: addPitokButton, targetSide: .bottom)
        pitokLabel.spSetSize(height: 30.0)
        
        view.addSubview(removePitokButton)
        removePitokButton.spAlignLeadingEdge(targetView: pitokLabel, targetSide: .trailing, constant: 15.0)
        removePitokButton.spAlignBottomEdge(targetView: pitokLabel, targetSide: .bottom)
        removePitokButton.spSetSize(width: 35.0, height: 35.0)
        
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
    
    private func savePlayerData(player: Player) {
        currentPlayer = MainMenu.savePlayerData(player: player)
        setupPlayersDetailView()
    }
    
    private func setupPlayersDetailView() {
        guard let player = currentPlayer else { return }
        
        if player.redRemaining == 0 {
            dropdownButton.isEnabled = true
        }else {
            dropdownButton.isEnabled = false
        }
        
        if eachTurnPitokCounter == player.pitok {
            removePitokButton.isHidden = true
        }
        
        if eachTurnRedBallPottedCounter == 0 {
            removeRedBallButton.isHidden = true
        }
        
        if redBallsOnTable > 0 {
            addredBallButton.isEnabled = true
        } else {
            addredBallButton.isEnabled = false
        }
        
        nameLabel.text = "\(player.name)'s Turn"
        redRemainingLabel.text = "\(player.redRemaining)"
        redPotsLabel.text = "\(player.redPottedBalls)"
        colorBallsPottedLabel.text = "\(player.coloredPottedBalls)"
        pitokLabel.text = String(player.pitok)
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
        feedbackGenerator.notificationOccurred(.warning)
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
    
    private func checkIfPlayerWinsOrEqualOrLost(for player: Player) {
        if player.redRemaining > redBallsOnTable {
            showWinsOrEqualOrLostMessage(title: "\(player.name) has lost!", message: "get out \(player.name)")
            dropdownButton.isEnabled = false
            addPitokButton.isEnabled = false
            addredBallButton.isEnabled = false
        }
        
        if player.coloredPottedBalls.contains(player.ball) {
            var message = ""
            for i in MainMenu.players {
                message.append("\(i.name) cart was: \(i.ball)\n")
            }
            showWinsOrEqualOrLostMessage(title: "\(player.name) has win!", message: message)
        } else {
            var message = ""
            var playerBalls: [Int] = []
            
            for i in MainMenu.players {
                playerBalls.append(i.ball)
                message.append("\(i.name) potted: \(i.coloredPottedBalls)\n")
                message.append("cart was: \(i.ball)\n")
            }
            var colorPottedToSet = Set(colorPottedBalls)
            var playerBallsToSet = Set(playerBalls)

            if playerBallsToSet.isSubset(of: colorPottedToSet) {
                showWinsOrEqualOrLostMessage(title: "game is Equal!", message: message)
            }
        }
    }
    
    private func showWinsOrEqualOrLostMessage(title: String, message: String) {
        feedbackGenerator.notificationOccurred(.warning)
        let ballAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ballAlertController.addAction(okAction)
        present(ballAlertController, animated: true, completion: nil)
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
        guard var player = currentPlayer else { return }
        let index = sender.tag
        feedbackGenerator.notificationOccurred(.success)
        if index < colorBalls.count {
            let value = colorBalls[index]
            player.coloredPottedBalls.append(value)
            colorPottedBalls.append(value)
            undoButton.isHidden = false
            undoColorBalls.append(value)
            colorBalls.remove(at: index)
            updateDropdownMenu()
            checkIfPlayerWinsOrEqualOrLost(for: player)
            savePlayerData(player: player)
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
        feedbackGenerator.notificationOccurred(.success)
        guard var player = currentPlayer else { return }
        switch sender.tag {
        case 1:
            MainMenu.players.removeAll()
            self.navigationController?.pushViewController(MainMenu(), animated: true)
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        case 2:
            showPasswordAlert(for: player)
        case 3:
            removeRedBallButton.isHidden = false
            eachTurnRedBallPottedCounter += 1
            redBallsOnTable -= 1
            player.redPottedBalls += 1
            if player.redRemaining > 0 {
                player.redRemaining -= 1
            }
            savePlayerData(player: player)
        case 4:
            eachTurnRedBallPottedCounter -= 1
            redBallsOnTable += 1
            player.redPottedBalls -= 1
            if eachTurnRedBallPottedCounter < playerRedRemainingKeeper {
                player.redRemaining += 1
            }
            savePlayerData(player: player)
        case 5:
            dropdownMenu.isHidden.toggle()
        case 6:
            let a = undoColorBalls.last
            undoColorBalls.removeLast()
            colorPottedBalls.removeLast()
            player.coloredPottedBalls.removeLast()
            colorBalls.append(a!)
            if undoColorBalls.isEmpty == true {
                undoButton.isHidden = true
            }
            savePlayerData(player: player)
            updateDropdownMenu()
        case 7:
            player.pitok += 1
            player.redRemaining += 1
            removePitokButton.isHidden = false
            savePlayerData(player: player)
        case 8:
            if player.redRemaining > 0 {
                player.redRemaining -= 1
            }
            player.pitok -= 1
            currentPlayer = MainMenu.savePlayerData(player: player)
            savePlayerData(player: player)
        case 9:
            eachTurnRedBallPottedCounter = 0
            undoColorBalls.removeAll()
            undoButton.isHidden = true
            dropdownMenu.isHidden = true
            player.isPlayerTurn = false
            savePlayerData(player: player)
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
        guard var player = currentPlayer else { return }
        player.isPlayerTurn = true
        eachTurnPitokCounter = player.pitok
        playerRedRemainingKeeper = player.redRemaining
        eachTurnRedBallPottedCounter = 0
        addPitokButton.isEnabled = true
        checkIfPlayerWinsOrEqualOrLost(for: player)
        savePlayerData(player: player)
    }
}
