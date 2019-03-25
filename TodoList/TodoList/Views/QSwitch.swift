//
//  QSwitch.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import GameIcons
import UIKit

/**
 Custom switch with filled circle for state "on" and empty circle for state "off"
 */
@IBDesignable public class QSwitch: UIButton {

    @IBInspectable var color: String {
        get {
            // Return the QColor as String
            return String(describing: self.qColor)
        }
        set {
            // Cast the given String to QColor and update background color and foreground image
            guard let qColor = QColor(rawValue: newValue) else {
                return
            }
            self.qColor = qColor
            self.backgroundColor = QColor.lightWhite.color
            self.foregroundImageView.image = self.foregroundImageOff
            self.setForegroundImageView()
        }
    }

    private let foregroundImageView = UIImageView()
    private let foregroundImageOn = GameIcon.plaincircle.image(size: 100).withRenderingMode(.alwaysTemplate)
    private let foregroundImageOff = GameIcon.circle.image(size: 100).withRenderingMode(.alwaysTemplate)

    private var buttonState = false
    private var qColor: QColor = .lightGreen

    /**
     Button state
     */
    public var on: Bool {
        get {
            return buttonState
        }
        set (value) {
            // Set foreground image according to new button state
            self.buttonState = value
            if self.buttonState {
                self.foregroundImageView.image = self.foregroundImageOn
            } else {
                self.foregroundImageView.image = self.foregroundImageOff
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = QColor.lightWhite.color
        self.layer.cornerRadius = QLabel.OUTER_CORNER_RADIUS
        self.layer.masksToBounds = true
        self.layer.borderWidth = QLabel.BORDER_WIDTH
        self.layer.borderColor = QColor.lightWhite.color.cgColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = QColor.lightWhite.color
        self.layer.cornerRadius = QLabel.OUTER_CORNER_RADIUS
        self.layer.masksToBounds = true
        self.layer.borderWidth = QLabel.BORDER_WIDTH
        self.layer.borderColor = QColor.lightWhite.color.cgColor
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.setForegroundImageView()
    }

    /**
     Sets foreground image
     */
    func setForegroundImageView() {
        foregroundImageView.tintColor = self.qColor.color
        foregroundImageView.frame = CGRect(x: self.bounds.minX + 15, y: self.bounds.minY + 15, width: self.bounds.width - 30, height: self.bounds.height - 30)
        self.addSubview(foregroundImageView)
    }

}
