//
//  CustomButton.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import SPCodebase

class CustomButton: UIButton {
    
    public static let buttonHeight: CGFloat = 50.0
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 10.0
        setTitleColor(.white, for: .normal)
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
