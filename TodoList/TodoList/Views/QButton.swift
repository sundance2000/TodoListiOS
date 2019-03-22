//
//  QSwitch.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

@IBDesignable public class QButton: UIButton {

    @IBInspectable var fontSize: CGFloat = 13.0

    @IBInspectable var color: String {
        get {
            return String(describing: self.qColor)
        }
        set {
            guard let qColor = QColor(rawValue: newValue) else {
                return
            }
            self.qColor = qColor
            self.backgroundColor = self.qColor.color
            self.label.text = "Label"
            self.setLabel()
        }
    }

    public let label = UILabel()

    var qColor: QColor = .lightGreen

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.qColor.color
        self.layer.cornerRadius = QLabel.OUTER_CORNER_RADIUS
        self.layer.masksToBounds = true
        self.layer.borderWidth = QLabel.BORDER_WIDTH
        self.layer.borderColor = QColor.lightWhite.color.cgColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = self.qColor.color
        self.layer.cornerRadius = QLabel.OUTER_CORNER_RADIUS
        self.layer.masksToBounds = true
        self.layer.borderWidth = QLabel.BORDER_WIDTH
        self.layer.borderColor = QColor.lightWhite.color.cgColor
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.setLabel()
    }

    func setLabel() {
        self.label.textAlignment = .left
        self.label.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        self.label.textColor = UIColor.white
        self.label.frame = CGRect(x: self.bounds.minX + 15, y: self.bounds.minY + 15, width: self.bounds.width - 30, height: self.bounds.height - 30)
        self.addSubview(self.label)
    }

}
