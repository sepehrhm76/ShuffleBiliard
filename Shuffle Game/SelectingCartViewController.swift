//
//  SelectingCartViewController.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

class SelectingCartViewController: BaseViewController {
    
    private var passwordFieldBottomConstraint: NSLayoutConstraint?
    
    private var timer: Timer?
    
    private var isCartFlipped =  false
    
    private var playersDetail = MainMenu.players
    
    private lazy var topText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Typography.b30()
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cartView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 5.0
        view.layer.borderColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cartViewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cartName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Typography.b24()
        return label
    }()
    
    private lazy var cartBall: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Typography.b24()
        label.isHidden = true
        return label
    }()
    
    private lazy var nextPlayerButton: SPCustomButton = {
        let button = SPCustomButton()
        button.backgroundColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordTextField: SPCustomTextField = {
        let textField = SPCustomTextField()
        textField.isSecureTextEntry = true
        textField.canShowPassword(canShow: true)
        textField.placeholder = "Enter password"
        textField.hidePasswordColor = #colorLiteral(red: 0.1098328278, green: 0.4609313361, blue: 0.1896262395, alpha: 1)
        textField.onSelectBorderColor = UIColor.green.cgColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topText)
        topText.spAlignCenterX()
        topText.spAlignTopEdge(constant: 100.0)
        topText.spSetSize(height: 30.0)
        
        view.addSubview(containerView)
        containerView.spAlignLeadingAndTrailingEdges()
        containerView.spAlignCenterY()
        containerView.spSetSize(height: 300.0)
        
        containerView.addSubview(cartView)
        cartView.spAlignAllEdgesExceptBottom(leadingConstant: 20.0, trailingConstant: -20.0)
        cartView.spSetSize(height: 200.0)
        
        cartView.addSubview(cartName)
        cartName.spAlignCenterXAndCenterYEdges()
        
        cartView.addSubview(cartBall)
        cartBall.spAlignCenterXAndCenterYEdges()
        
        containerView.addSubview(passwordTextField)
        passwordTextField.spAlignLeadingAndTrailingEdges(leadingConstant: 20.0, trailingConstant: -20.0)
        passwordFieldBottomConstraint = passwordTextField.spAlignBottomEdge()
        passwordTextField.spSetSize(height: SPCustomTextField.textFieldHeight)
        
        view.addSubview(nextPlayerButton)
        nextPlayerButton.spAlignAllEdgesExceptTop(leadingConstant: 20.0, trailingConstant: -20.0, bottomConstant: -50.0)
        nextPlayerButton.spSetSize(height: SPCustomButton.buttonHeight)

        showPlayerDetail()
        spConfigureGestureRecognizerToDismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showPlayerDetail() {
        guard !playersDetail.isEmpty else { return }
        
        if playersDetail.count == 1 {
            nextPlayerButton.setTitle("Start Game", for: .normal)
        }
        
        topText.text = "\(playersDetail.first?.name ?? "") take phone:"
        cartName.text = playersDetail.first?.name
        cartBall.text = String(playersDetail.first?.ball ?? 0)
        
        passwordTextField.text = "1"
    }
    
    private func openCart() {
        UIView.transition(with: cartView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.cartView.backgroundColor = .lightGray
            self.cartName.isHidden = true
            self.cartBall.isHidden = false
        }, completion: nil)
        isCartFlipped = true
        startTimer(duration: 2.0)
    }
    
    private func closeCart() {
        UIView.transition(with: cartView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.cartView.backgroundColor = .white
            self.cartName.isHidden = false
            self.cartBall.isHidden = true
        }, completion: nil)
        isCartFlipped = false
        stopTimer()
    }
    
    private func startTimer(duration: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.closeCart()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func cartViewTapped() {
        if !isCartFlipped {
            openCart()
        } else {
            closeCart()
        }
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        if let password = passwordTextField.text, !password.isEmpty, var currentPlayer = playersDetail.first {
            currentPlayer.password = password
            
            if let index = MainMenu.players.firstIndex(where: { $0.name == currentPlayer.name }) {
                MainMenu.players[index] = currentPlayer
                passwordTextField.text?.removeAll()
                playersDetail.removeFirst()
                closeCart()
            }
            
            if nextPlayerButton.currentTitle == "Start Game" {
                navigationController?.pushViewController(GameViewController(), animated: true)
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            } else {
                showPlayerDetail()
            }
            
        } else {
            passwordTextField.hasError = true
            SPTopAlert.shared.show(type: .error, message: "Password can't be empty!")
        }
    }
}

extension SelectingCartViewController {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let passwordFieldBottomConstraint = passwordFieldBottomConstraint else {
            return
        }
        
        passwordFieldBottomConstraint.constant = -40.0
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let passwordFieldBottomConstraint = passwordFieldBottomConstraint {
            passwordFieldBottomConstraint.constant = 0.0
            view.layoutIfNeeded()
        }
    }
}
