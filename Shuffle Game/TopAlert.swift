//
//  TopAlert.swift
//  Shuffle Game
//
//  Created by sepehr hajimohammadi on 5/19/24.
//

import UIKit
import SPCodebase

class TopAlert: BaseView {
    
    internal enum AlertType: String {
        case error = "Error", success = "Success", warning = "Warning"
    }
    
    static let shared = TopAlert()
    
    private let firstFrameAlertWidthAndHeight = 70.0
    
    private let sideMargin: CGFloat = 15.0
    private let animationDuration = 0.2
    
    private var timer: Timer?
    private var timerCounter = 2.5
    
    private var isHighlightedInternal = false
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.isHidden = true
        label.font = Typography.bold(20)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.isHidden = true
        label.font = Typography.m14()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private func highlight() {
        if !isHighlightedInternal {
            isHighlightedInternal = true
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }
    }
    
    private func unhighlight() {
        if isHighlightedInternal {
            isHighlightedInternal = false
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeup.direction = UISwipeGestureRecognizer.Direction.up
        self.addGestureRecognizer(swipeup)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(type: AlertType, message: String) {
        guard timer?.isValid != true else { return }
        
        let iconImageName: String
        let iconColor: UIColor
        
        guard let keyWindowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first as? UIWindowScene else {
            return
        }
        
        guard let keyWindow = keyWindowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        keyWindow.addSubview(self)
        layer.cornerRadius = firstFrameAlertWidthAndHeight / 2.0
        frame = CGRect(x: (keyWindow.frame.width / 2.0) - (firstFrameAlertWidthAndHeight / 2),
                       y: -firstFrameAlertWidthAndHeight,
                       width: firstFrameAlertWidthAndHeight,
                       height: firstFrameAlertWidthAndHeight)
        
        switch type {
        case .error:
            titleLabel.text = AlertType.error.rawValue
            iconImageName = "xmark.circle.fill"
            iconColor = #colorLiteral(red: 0.9450266957, green: 0.1770647168, blue: 0.1695831418, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.9924299121, green: 0.9287281632, blue: 0.9348064065, alpha: 1)
        case .success:
            titleLabel.text = AlertType.success.rawValue
            iconImageName = "checkmark.circle.fill"
            iconColor = #colorLiteral(red: 0.192897588, green: 0.7594278455, blue: 0.516956985, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.9170510173, green: 0.9557631612, blue: 0.9270833135, alpha: 1)
        case .warning:
            titleLabel.text = AlertType.warning.rawValue
            iconImageName = "exclamationmark.circle.fill"
            iconColor = #colorLiteral(red: 0.9832932353, green: 0.7587742209, blue: 0.1803134978, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.9976586699, green: 0.9765452743, blue: 0.9135218859, alpha: 1)
        }
        
        iconImageView.image = UIImage(systemName: iconImageName)
        iconImageView.tintColor = iconColor
        setIconSize()
        addSubview(iconImageView)
        
        messageLabel.text = message
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
                self.frame.origin.y = 50.0
            }
        }, completion: { _ in
            self.addSubview(self.titleLabel)
            self.addSubview(self.messageLabel)
            UIView.animate(withDuration: self.animationDuration, animations: {
                self.frame.size.width = keyWindow.frame.width - (self.sideMargin * 2)
                self.frame.origin.x = self.sideMargin
                self.layer.cornerRadius = (self.firstFrameAlertWidthAndHeight / 2) / 2
                self.iconImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
                self.titleLabel.frame = CGRect(x: 50, y: 12, width: (self.frame.width / 100) * 30, height: (self.frame.height / 100) * 35)
                self.messageLabel.frame = CGRect(x: 50, y: 40, width: (self.frame.width / 100) * 85, height: (self.frame.height / 100) * 35)
            }, completion: { _ in
                self.titleLabel.isHidden = false
                self.messageLabel.isHidden = false
            })
        })
        startTimer(duration: self.timerCounter)
    }
    
    private func hide() {
        UIView.animate(withDuration: animationDuration) {
            var newBounds = self.bounds
            newBounds.size.width = self.firstFrameAlertWidthAndHeight
            self.bounds = newBounds
            self.layer.cornerRadius = self.firstFrameAlertWidthAndHeight / 2
            self.setIconSize()
            self.titleLabel.isHidden = true
            self.messageLabel.isHidden = true
        } completion: { _ in
            UIView.animate(withDuration: self.animationDuration) {
                self.frame.origin.y = -self.firstFrameAlertWidthAndHeight
            } completion: { _ in
                self.titleLabel.removeFromSuperview()
                self.messageLabel.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    
    private func setIconSize() {
        let adjustedWidth = bounds.width + 11
        let adjustedHeight = bounds.height + 11
        let iconOriginX = (bounds.width - adjustedWidth) / 2
        let iconOriginY = (bounds.height - adjustedHeight) / 2
        iconImageView.frame = CGRect(x: iconOriginX, y: iconOriginY, width: adjustedWidth, height: adjustedHeight)
    }
    
    private func startTimer(duration: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.hide()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        stopTimer()
        highlight()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        startTimer(duration: timerCounter)
        unhighlight()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .up:
                stopTimer()
                hide()
                unhighlight()
            default:
                break
            }
        }
    }
}
