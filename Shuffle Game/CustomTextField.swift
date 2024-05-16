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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

