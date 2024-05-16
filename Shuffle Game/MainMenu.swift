//
//  ViewController.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

class MainMenu: BaseViewController {
    
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
        view.isLayoutMarginsRelativeArrangement = true
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
        return pickerView
    }()
    
    private lazy var roundCounter: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
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
    
    private lazy var addPlayerButton: CustomButton = {
        let button = CustomButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Add player", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    private lazy var startGameButton: CustomButton = {
        let button = CustomButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Start Game", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.spAlignEdges(attribute: .all)
        
        scrollView.addSubview(stackView)
        stackView.spSetSizeConstraintToOtherView(side: .widthAnchor)
        stackView.spAlignEdges(attribute: .all, margin: .init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        stackView.addArrangedSubview(counterContainer)
        counterContainer.spSetSize(height: 100)
        
        counterContainer.addSubview(redBallText)
        redBallText.spAlignLeadingEdge()
        redBallText.spAlignTopEdge(constant: 10.0)
        
        counterContainer.addSubview(roundText)
        roundText.spAlignTrailingEdge()
        roundText.spAlignTopEdge(constant: 10.0)
        
        counterContainer.addSubview(redBallCounter)
        redBallCounter.spAlignCenterX(targetView: redBallText, targetSide: .centerX)
        redBallCounter.spAlignBottomEdge()
        redBallCounter.spSetSize(width: 100.0, height: 50.0)
        
        counterContainer.addSubview(roundCounter)
        roundCounter.spAlignCenterX(targetView: roundText, targetSide: .centerX)
        roundCounter.spAlignBottomEdge()
        roundCounter.spSetSize(width: 100.0, height: 50.0)
        
        stackView.addArrangedSubview(playerNamesStack)
               
//        stackView.addArrangedSubview(startGameButton)
//        startGameButton.spSetSize(height: CustomButton.buttonHeight)
        
        view.addSubview(startGameButton)
        startGameButton.spAlignAllEdgesExceptTop(leadingConstant: 20.0, trailingConstant: -20.0, bottomConstant: -50.0)
        startGameButton.spSetSize(height: CustomButton.buttonHeight)
        
        view.addSubview(addPlayerButton)
        addPlayerButton.spAlignTrailingAndTopEdges(trailingConstant: -20.0, topConstant: 80.0)
        addPlayerButton.spSetSize(width: 100.0, height: 30.0)
        
        spConfigureGestureRecognizerToDismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        switch sender.tag {
        case 1:
            if playerNamesStack.arrangedSubviews.count < 7 {
                
                if playerNamesStack.arrangedSubviews.count == 2 {
                    startGameButton.isEnabled = true
                }
                
                if playerNamesStack.arrangedSubviews.count == 5 {
                    addPlayerButton.isEnabled = false
                }
                
                lazy var players = PlayersNameTextFields()
                players.tag = playerNamesStack.arrangedSubviews.count
                
                players.delegate = self
                playerNamesStack.addArrangedSubview(players)
                players.spSetSize(height: 50)
                players.playerNameTextField.tag = playerNamesStack.arrangedSubviews.count
                players.playerNameTextField.text = "Player \(playerNamesStack.arrangedSubviews.count)"
            }
        case 2:
            print("hi")
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
        //        MainMenu.roundCount = row + 1
    }
}

extension MainMenu: PlayersNameTextFieldsDelegateProtocol {
    func deleteHandler(_ tag: Int) {
        guard let textField = playerNamesStack.arrangedSubviews.first(where: {$0.tag == tag}) else {
            return
        }
        textField.removeFromSuperview()
        
        addPlayerButton.isEnabled = true
        
        if playerNamesStack.arrangedSubviews.count == 2 {
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
