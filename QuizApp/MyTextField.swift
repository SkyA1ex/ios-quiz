//
//  MyTextField.swift
//  Quiz
//
//  Created by Alexander Tkachenko on 20/04/17.
//  Copyright © 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation
import UIKit

class PaddingTextField: UITextField {


    var padding: CGFloat = 0


    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }


    override var borderStyle: UITextBorderStyle {
        didSet {
            let border = CALayer()
            let borderWidth = CGFloat(1.0)
            border.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
            border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width * 2, height: borderWidth)

            border.borderWidth = borderWidth
            layer.addSublayer(border)
            layer.masksToBounds = true
        }
        willSet {
        }
    }


}
