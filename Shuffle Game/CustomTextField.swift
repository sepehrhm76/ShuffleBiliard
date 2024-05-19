//
//  CustomTextField.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

class CustomTextField: UITextField, UITextFieldDelegate {
    
    public static let textFieldHeight: CGFloat = 50.0
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: placeholderColor])
        }
    }
    
    private lazy var hidePasswordButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = .zero
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(hidePasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var placeholderColor: UIColor = .gray {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: placeholderColor])
        }
    }
    
    private var isFieldActive: Bool = false {
        didSet {
            updateBorderColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
        font = UIFont.systemFont(ofSize: 16.0)
        textColor = .black
        autocorrectionType = .no
        autocapitalizationType = .none
        layer.cornerRadius = 7.0
        backgroundColor = .white
        delegate = self
        rightView = hidePasswordButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            isFieldActive = true
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            isFieldActive = false
        }
        return result
    }
    
    private func updateBorderColor() {
        layer.borderColor = isFieldActive ? UIColor.blue.cgColor : UIColor.lightGray.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    internal func canShowPassword(canShow: Bool) {
        switch canShow {
        case true:
            rightViewMode = .always
        case false:
            rightViewMode = .never
        }
    }
    
    @objc private func hidePasswordButtonTapped(sender: UIButton) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.isSecureTextEntry.toggle()
            self.hidePasswordButton.setImage(UIImage(systemName: self.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
        }, completion: nil)
    }
}
