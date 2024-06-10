//
//  PlayersNameTextFields.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

protocol PlayersNameTextFieldsDelegateProtocol: NSObjectProtocol {
    func deleteHandler(_ tag: Int)
}

class PlayersNameTextFields: UIView, UITextFieldDelegate {
    
    public var itemTapped: (()->())?
    
    public weak var delegate: PlayersNameTextFieldsDelegateProtocol?
    let kooft = MainMenu()
    
    private lazy var deleteButton: SPCustomButton = {
        let button = SPCustomButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = .clear
        button.layer.shadowOpacity = .zero
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var playerNameTextField: SPCustomTextField = {
        let textField = SPCustomTextField()
        textField.rightView = deleteButton
        textField.rightViewMode = .always
        textField.onSelectBorderColor = UIColor.green.cgColor
        textField.autocapitalizationType = .words
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playerNameTextField)
        playerNameTextField.spAlignEdges(attribute: .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteHandler(tag)
    }
}
