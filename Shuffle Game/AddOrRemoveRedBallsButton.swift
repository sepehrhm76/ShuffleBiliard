//
//  AddOrRemoveRedBall.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/26/24.
//

import UIKit
import SPCodebase
import Combine

enum StateType{
    case finished, none
}

class AddOrRemoveRedBallsButton: UIView {
    enum AddOrRemoveButton {
        case add, remove, none
    }
    
    enum IconNames: String {
        case trash = "trash", minus = "minus", plus = "plus"
    }

    var quantityCounter = 0
    var minQuantity = 0
    var buttonNumbber = 0
    private var countdownTimer: Timer?
    private var isFirstTimeClicked = true
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    public private(set) var observable: CurrentValueSubject<StateType, Error> = .init(.none)
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.layer.borderWidth = 1
        stack.layer.borderColor = #colorLiteral(red: 0.582917273, green: 0.7549735904, blue: 0.1221931651, alpha: 1)
        stack.backgroundColor = .black
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        button.tintColor = #colorLiteral(red: 0.582917273, green: 0.7549735904, blue: 0.1221931651, alpha: 1)
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: IconNames.plus.rawValue), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        button.tintColor = #colorLiteral(red: 0.582917273, green: 0.7549735904, blue: 0.1221931651, alpha: 1)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(buttonsStack)
        buttonsStack.spSetSize(height: 35)
        buttonsStack.spAlignLeadingAndBottomEdges()
        
        buttonsStack.addArrangedSubview(addButton)
        addButton.spSetSize(width: 35)
        
        buttonsStack.addArrangedSubview(quantityLabel)
        quantityLabel.spSetSize(width: 60)
        
        buttonsStack.addArrangedSubview(removeButton)
        removeButton.spSetSize(width: 35)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func addButtonTapped(_ sender: UIButton) {
        performActionAfterCountdownStarts()
        
        calculateQuantityCount(action: .add)
        
//        if quantityCounter == 0 {
//            isFirstTimeClicked = true
//        }
//        
//        if isFirstTimeClicked {
//            calculateQuantityCount(action: .add)
//        } else if quantityCounter != 0 && isFirstTimeClicked == false {
//            isFirstTimeClicked = true
//            updateButtonUI(action: .none)
//            return
//        }
    }
    
    @objc
    private func removeButtonTapped(_ sender: UIButton) {
        calculateQuantityCount(action: .remove)
    }
    
    private func performActionAfterCountdownStarts() {
        updateAddButtonUiToPlusIcon()
        UIView.animate(withDuration: 0.2) {
            self.quantityLabel.isHidden = false
            self.removeButton.isHidden = false
            self.removeButton.alpha = 1.0
            self.quantityLabel.alpha = 1.0
            self.buttonsStack.backgroundColor = .white
            self.buttonsStack.layoutIfNeeded()
        }
    }
    
    private func performActionAfterCountdownEnds() {
        addButton.isEnabled = true
        buttonNumbber += quantityCounter
        quantityCounter = 0
//        updateAddButtonUiToQuantityCounterTitle()
        observable.send(.finished)
        UIView.animate(withDuration: 0.2, animations: {
            self.quantityLabel.isHidden = true
            self.removeButton.isHidden = true
            self.removeButton.alpha = 0.0
            self.quantityLabel.alpha = 0.0
            self.buttonsStack.layoutIfNeeded()
        }, completion: { _ in
            self.isFirstTimeClicked = false
        })
    }
    
    private func updateAddButtonUiToPlusIcon() {
        addButton.backgroundColor = .white
        addButton.tintColor = #colorLiteral(red: 0.582917273, green: 0.7549735904, blue: 0.1221931651, alpha: 1)
        addButton.setImage(UIImage(systemName: IconNames.plus.rawValue), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        addButton.setTitle("", for: .normal)
    }
    
    func updateAddButtonUiToQuantityCounterTitle(value: Int) {
        addButton.backgroundColor = #colorLiteral(red: 0.582917273, green: 0.7549735904, blue: 0.1221931651, alpha: 1)
        addButton.tintColor = .black
        addButton.setImage(UIImage(systemName: ""), for: .normal)
        addButton.setTitle(String(value), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
    }
    
    private func calculateQuantityCount(action: AddOrRemoveButton) {
        switch action {
        case .add:
            quantityCounter += 1
            updateButtonUI(action: .add)
        case .remove:
            if quantityCounter == minQuantity {
                performActionAfterCountdownEnds()
            } else {
                quantityCounter -= 1
            }
            updateButtonUI(action: .remove)
        case .none:
            break
        }
    }
    
    private func updateButtonUI(action: AddOrRemoveButton) {
        feedbackGenerator.impactOccurred()
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.performActionAfterCountdownEnds()
        }
        
        addButton.isEnabled = quantityCounter != 15
        
        if quantityCounter == minQuantity {
            setMinusButtonIconAndAnimateRotation(iconName: IconNames.trash.rawValue)
        } else {
            if action == .add && quantityCounter > minQuantity {
                setMinusButtonIconAndAnimateRotation(iconName: IconNames.minus.rawValue)
            }
        }
        quantityLabel.text = String(quantityCounter)
    }
    
    private func setMinusButtonIconAndAnimateRotation(iconName: String) {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.removeButton.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { [self] _ in
            self.removeButton.setImage(UIImage(systemName: iconName), for: .normal)
            UIView.animate(withDuration: 0.15, animations: {
                self.removeButton.transform = .identity
            })
        })
    }
}
