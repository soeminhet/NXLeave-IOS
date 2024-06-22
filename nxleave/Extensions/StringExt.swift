//
//  StringExt.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let pwsRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\W).{8,}$"
        let pwsPred = NSPredicate(format:"SELF MATCHES %@", pwsRegex)
        return pwsPred.evaluate(with: self)
    }
    
    func toDays() -> String {
        guard let value = Double(self) else {return "-" }
        return value.toDays()
    }
}
