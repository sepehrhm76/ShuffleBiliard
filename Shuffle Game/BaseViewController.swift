//
//  BaseViewController.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    internal var cancellables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
    }
}
