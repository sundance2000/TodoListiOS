//
//  QLabel.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

/**
 Custom label with colored background and round corners
 */
@IBDesignable public class QLabel: UILabel {

    @IBInspectable public var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set(value) {
            self.font = UIFont.boldSystemFont(ofSize: value)
        }
    }

    @IBInspectable public var colorName: String {
        get {
            // Return the QColor as String
            return String(describing: self.qColor)
        }
        set {
            // Cast the given String to QColor
            guard let qColor = QColor(rawValue: newValue) else {
                return
            }
            self.qColor = qColor
        }
    }

    static let BORDER_WIDTH: CGFloat = 5
    static let OUTER_CORNER_RADIUS: CGFloat = 10
    static let INNER_CORNER_RADIUS: CGFloat = 4

    var qColor: QColor = .lightGreen

    public var color: QColor {
        get {
            return self.qColor
        }
        set {
            self.qColor = newValue
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = self.textAlignment
        self.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        self.textColor = UIColor.white
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textAlignment = self.textAlignment
        self.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        self.textColor = UIColor.white
    }

    override public func prepareForInterfaceBuilder() {
        self.textAlignment = self.textAlignment
        self.font = UIFont.boldSystemFont(ofSize: self.fontSize)
        self.textColor = UIColor.white
        self.set()
    }

    /**
     Sets the style of the label
     */
    func set() {
        //self.backgroundColor = self.qColor.color
        // Set corners rounded
        //self.layer.cornerRadius = 10
        //self.layer.masksToBounds = true
        // Set "white" border
        //self.layer.borderWidth = 5
        //self.layer.borderColor = QColor.lightWhite.color.cgColor
        // There is a bug in the rendering engine causing artifacts at corners.
        // So instead of using a border, we set the background color to the border color
        // and add a background texture with the real background color.
        // The background texture has the size of the view minus the border to simulate the real border.
        // !!! Maybe the border feature will work some day. Test with each update of Xcode.
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 2.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let rect = CGRect(x: QLabel.BORDER_WIDTH, y: QLabel.BORDER_WIDTH, width: self.frame.size.width - QLabel.BORDER_WIDTH * 2, height: self.frame.size.height - QLabel.BORDER_WIDTH * 2)
        let roundedRectPath = UIBezierPath(roundedRect: rect, cornerRadius: QLabel.INNER_CORNER_RADIUS).cgPath
        context.addPath(roundedRectPath)
        context.setFillColor(self.qColor.color.cgColor)
        context.closePath()
        context.fillPath()
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        self.backgroundColor = UIColor(patternImage: resultImage)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.set()
    }

    // Reduce inner space by border and corner radius
    override public func drawText(in rect: CGRect) {
        let offset = QLabel.BORDER_WIDTH + QLabel.OUTER_CORNER_RADIUS
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)))
    }

    // Add border and corner radius to intrinsic content size
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        let offset = (QLabel.BORDER_WIDTH + QLabel.OUTER_CORNER_RADIUS) * 2
        size.width += offset
        size.height += offset
        return size
    }

}
