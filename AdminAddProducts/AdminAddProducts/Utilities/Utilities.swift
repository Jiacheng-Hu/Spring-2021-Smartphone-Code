//
//  Utilities.swift
//  AdminAddProducts
//
//  Created by 胡嘉诚 on 2021/4/14.
//

import Foundation

extension String {
    
    var isEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
        
    }
}
