//
//  UIColorExt.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(fromUInt64 value: UInt64) {
        // Extract individual RGB components from UInt64
        let red = CGFloat((value / 65536) % 256) / 255.0
        let green = CGFloat((value / 256) % 256) / 255.0
        let blue = CGFloat(value % 256) / 255.0
        let alpha = CGFloat(255) / 255.0

        // Create UIColor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
