//
//  NumberExt.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import Foundation

extension Double {
    func toDays() -> String {
        let decimal = Int(truncatingRemainder(dividingBy: 1) * 100)
        
        if decimal == 0 {
            return self <= 1 ? "\(Int(self)) Day" : "\(Int(self)) Days"
        } else {
            return self <= 1 ? "\(self) Day" : "\(self) Days"
        }
    }
    
    func formatDouble() -> String {
        let intValue = Int(self)
        let formattedString: String

        if self - Double(intValue) == 0 {
            formattedString = "\(intValue)"
        } else {
            formattedString = String(format: "%.1f", self)
        }

        return formattedString
    }
}
