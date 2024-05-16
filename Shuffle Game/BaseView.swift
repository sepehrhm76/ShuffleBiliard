//
//  BaseView.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit

open class BaseView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
