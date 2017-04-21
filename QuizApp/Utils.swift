//
//  Utils.swift
//  Quiz
//
//  Created by Alexander Tkachenko on 20/04/17.
//  Copyright © 2017 Alexander Tkachenko. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {


    convenience init(redInt: Int, blueInt: Int, greenInt: Int, alpha: CGFloat) {
        assert(redInt >= 0 && redInt <= 255, "Invalid red component")
        assert(blueInt >= 0 && blueInt <= 255, "Invalid green component")
        assert(greenInt >= 0 && greenInt <= 255, "Invalid blue component")
        assert(alpha >= 0.0 && alpha <= 1.0, "Invalid alpha component")

        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(blueInt) / 255.0, blue: CGFloat(greenInt) / 255.0, alpha: alpha)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(redInt: red, blueInt: blue, greenInt: green, alpha: 1.0)
    }


    convenience init(rgb: Int) {
        self.init(
                red: (rgb >> 16) & 0xFF,
                green: (rgb >> 8) & 0xFF,
                blue: rgb & 0xFF
        )
    }

}

class Utils {

    static func showAlert(_ controller: UIViewController,_ title: String?,  _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }

}