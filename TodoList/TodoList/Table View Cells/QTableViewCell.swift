//
//  QTableViewCell.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

/**
 Custom table view cell to change basic layout
 */
open class QTableViewCell: UITableViewCell {

    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.x += 5
            frame.size = CGSize(width: frame.width - 10, height: frame.height)
            super.frame = frame
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = QColor.lightWhite.color
        self.selectionStyle = .none
    }

}
