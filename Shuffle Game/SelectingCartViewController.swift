//
//  SelectingCartViewController.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

class SelectingCartViewController: BaseViewController {
    
    private var textTopConstraint: NSLayoutConstraint?
    private var cartCenterXConstraint: NSLayoutConstraint?
    
    private var isCartFlipped =  false
    
    private var playersDetail = MainMenu.players
    
    private lazy var topText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Typography.b30()
        return label
    }()
    
    private lazy var cartView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 5.0
        view.layer.borderColor = UIColor.systemGreen.cgColor
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
    
    private lazy var nextPlayerButton: CustomButton = {
        let button = CustomButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.isSecureTextEntry = true
        textField.canShowPassword(canShow: true)
        textField.placeholder = "Enter password"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topText)
        topText.spAlignCenterX()
        textTopConstraint = topText.spAlignTopEdge(constant: 50.0)
        topText.spSetSize(height: 100.0)
        
        view.addSubview(cartView)
        cartView.spAlignLeadingAndTrailingEdges(leadingConstant: 20.0, trailingConstant: -20.0)
        cartCenterXConstraint = cartView.spAlignCenterY()
        cartView.spSetSize(height: 200.0)
        
        cartView.addSubview(cartName)
        cartName.spAlignCenterXAndCenterYEdges()
        
        cartView.addSubview(cartBall)
        cartBall.spAlignCenterXAndCenterYEdges()
        
        view.addSubview(passwordTextField)
        passwordTextField.spAlignLeadingAndTrailingEdges(leadingConstant: 20.0, trailingConstant: -20.0)
        passwordTextField.spAlignTopEdge(targetView: cartView, targetSide: .bottom, constant: 50.0)
        passwordTextField.spSetSize(height: CustomTextField.textFieldHeight)
        
        view.addSubview(nextPlayerButton)
        nextPlayerButton.spAlignAllEdgesExceptTop(leadingConstant: 20.0, trailingConstant: -20.0, bottomConstant: -50.0)
        nextPlayerButton.spSetSize(height: CustomButton.buttonHeight)
        
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
    }
    
    private func openCart() {
        UIView.transition(with: cartView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.cartView.backgroundColor = .lightGray
            self.cartName.isHidden = true
            self.cartBall.isHidden = false
        }, completion: nil)
        isCartFlipped = true
    }
    
    private func closeCart() {
        UIView.transition(with: cartView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.cartView.backgroundColor = .white
            self.cartName.isHidden = false
            self.cartBall.isHidden = true
        }, completion: nil)
        isCartFlipped = false
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
        } else {
            TopAlert.shared.show(type: .error, message: "Password can't be empty!")
        }
        
        if nextPlayerButton.currentTitle == "Start Game" {
            navigationController?.pushViewController(GameViewController(), animated: true)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            showPlayerDetail()
        }
    }
}

extension SelectingCartViewController {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let textTop = textTopConstraint,
              let cartCenterX = cartCenterXConstraint else {
            return
        }
        
        let keyboardHeight = keyboardSize.height
        textTop.constant = -keyboardHeight
        cartCenterX.constant = -keyboardHeight
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let textTop = textTopConstraint,
           let cartCenterX = cartCenterXConstraint {
            textTop.constant = 50.0
            cartCenterX.constant = 0.0
            view.layoutIfNeeded()
        }
    }
}
