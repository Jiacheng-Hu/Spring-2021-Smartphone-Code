//
//  KeychainService.swift
//  AdminAddProducts
//
//  Created by 胡嘉诚 on 2021/4/15.
//

import Foundation
import KeychainSwift

class KeychainService {
    
    var _localVar = KeychainSwift()
    
    var keyChain: KeychainSwift {
        
        get {
            return _localVar
        }
        
        set {
            _localVar = newValue
        }
        
    }
    
}
