//
//  ViewController.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

class MainMenu: BaseViewController {
    
    static var players: [Player] = []
    static var roundToWin = 1
    
    var colorBalls = [2,3,4,5,6,7]
    
    private var redBallCount = 1
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 50.0
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 20.0, right: 20.0)
        return view
    }()
    
    private lazy var playerNamesStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20.0
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var redBallCounter: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 1
        return pickerView
    }()
    
    private lazy var roundCounter: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 2
        return pickerView
    }()
    
    private lazy var counterContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var redBallText: UILabel = {
        let label = UILabel()
        label.text = "Red Balls Count To Free"
        return label
    }()
    
    private lazy var roundText: UILabel = {
        let label = UILabel()
        label.text = "Play Roud To Win"
        return label
    }()
    
    private lazy var addPlayerButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        button.setTitle("Add player", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    private lazy var loadGameButton: SPCustomButton = {
        let button = SPCustomButton()
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        button.setTitle("Load game", for: .normal)
        button.setTitle("There is notthing to load!", for: .disabled)
        button.setTitleColor(.darkGray, for: .disabled)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    
    private lazy var startGameButton: SPCustomButton = {
        let button = SPCustomButton()
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        button.setTitle("Assign balls", for: .normal)
        button.setTitle("Players can't be less than 2", for: .disabled)
        button.setTitleColor(.darkGray, for: .disabled)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.spAlignEdges(attribute: .all)
        scrollView.spSetSizeConstraintToOtherView(side: .widthAnchor)
        
        scrollView.addSubview(stackView)
        stackView.spSetSizeConstraintToOtherView(side: .widthAnchor)
        stackView.spAlignEdges(attribute: .all, margin: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        stackView.addArrangedSubview(counterContainer)
        counterContainer.spSetSize(height: 150)
        
        counterContainer.addSubview(redBallText)
        redBallText.spAlignLeadingEdge()
        redBallText.spAlignTopEdge(constant: 10.0)
        
        counterContainer.addSubview(roundText)
        roundText.spAlignTrailingEdge()
        roundText.spAlignTopEdge(constant: 10.0)
        
        counterContainer.addSubview(redBallCounter)
        redBallCounter.spAlignCenterX(targetView: redBallText, targetSide: .centerX)
        redBallCounter.spAlignBottomEdge()
        redBallCounter.spSetSize(width: 100.0, height: 100.0)
        
        counterContainer.addSubview(roundCounter)
        roundCounter.spAlignCenterX(targetView: roundText, targetSide: .centerX)
        roundCounter.spAlignBottomEdge()
        roundCounter.spSetSize(width: 100.0, height: 100.0)
        
        stackView.addArrangedSubview(playerNamesStack)
        
        stackView.addArrangedSubview(loadGameButton)
        loadGameButton.spSetSize(height: SPCustomButton.buttonHeight)
        
        stackView.addArrangedSubview(startGameButton)
        startGameButton.spSetSize(height: SPCustomButton.buttonHeight)
        
        view.addSubview(addPlayerButton)
        addPlayerButton.spAlignTrailingAndTopEdges(trailingConstant: -20.0, topConstant: 60.0)
        addPlayerButton.spSetSize(width: 100.0, height: 30.0)
        
        spConfigureGestureRecognizerToDismissKeyboard()
        
        loadPlayers()
        
        //        redBallCounter.selectRow(2, inComponent: 0, animated: true)
        //        roundCounter.selectRow(2, inComponent: 0, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func assignColorBall() -> Int {
        guard let randomIndex = colorBalls.indices.randomElement() else { return 0 }
        let randomBall = colorBalls[randomIndex]
        colorBalls.remove(at: randomIndex)
        return randomBall
    }
    
    private func makePlayers() {
        MainMenu.players = []
        for index in 0..<playerNamesStack.arrangedSubviews.count {
            if let playerComponent = playerNamesStack.arrangedSubviews[index] as? PlayersNameTextFields {
                let playerName = playerComponent.playerNameTextField.text ?? ""
                MainMenu.players.append(
                    Player(
                        id: MainMenu.players.count,
                        name: playerName,
                        ball: assignColorBall(),
                        redRemaining: redBallCount,
                        win: 0,
                        isWinner: false,
                        coloredPottedBalls: [],
                        redPottedBalls: 0,
                        pitok: 0,
                        isPlayerTurn: false
                    )
                )
            }
        }
    }
    
    @discardableResult
    static func savePlayerData(player: Player) -> Player? {
        guard let playerIndex = MainMenu.players.firstIndex(where: {$0.id == player.id}) else { return nil }
        MainMenu.players.remove(at: playerIndex)
        MainMenu.players.insert(player, at: playerIndex)
        return player
    }
    
    func loadPlayers() {
        if let savedPlayers = UserDefaults.standard.object(forKey: "players") as? Data {
            if let loadedPlayers = try? JSONDecoder().decode([Player].self, from: savedPlayers) {
                MainMenu.players = loadedPlayers
                loadGameButton.isEnabled = true
            } else {
                loadGameButton.isEnabled = false
            }
        }
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        switch sender.tag {
        case 1:
            if playerNamesStack.arrangedSubviews.count < 7 {
                
                if playerNamesStack.arrangedSubviews.count == 1 {
                    startGameButton.isEnabled = true
                }
                
                if playerNamesStack.arrangedSubviews.count == 5 {
                    addPlayerButton.isHidden = true
                }
                
                lazy var textField = PlayersNameTextFields()
                textField.delegate = self
                playerNamesStack.addArrangedSubview(textField)
                textField.tag = playerNamesStack.arrangedSubviews.count
                textField.spSetSize(height: 50)
                textField.playerNameTextField.text = "Player \(playerNamesStack.arrangedSubviews.count)"
            }
        case 2:
            navigationController?.pushViewController(GameViewController(), animated: true)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        case 3:
            makePlayers()
            self.navigationController?.pushViewController(SelectingCartViewController(), animated: true)
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        default:
            break
        }
    }
}

extension MainMenu: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            redBallCount = row + 1
        case 2:
            MainMenu.roundToWin = row + 1
        default:
            break
        }
    }
}

extension MainMenu: PlayersNameTextFieldsDelegateProtocol {
    func deleteHandler(_ tag: Int) {
        guard let textField = playerNamesStack.arrangedSubviews.first(where: {$0.tag == tag}) else {
            return
        }
        textField.removeFromSuperview()
        
        addPlayerButton.isHidden = false
        
        if playerNamesStack.arrangedSubviews.count == 1 {
            startGameButton.isEnabled = false
        }
    }
}

extension MainMenu {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentInset.bottom = keyboardSize.height + 50.0
            scrollView.contentInset = contentInset
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        view.layoutIfNeeded()
    }
}

