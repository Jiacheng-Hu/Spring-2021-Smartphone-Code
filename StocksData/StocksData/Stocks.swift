//
//  Stocks.swift
//  StocksData
//
//  Created by 胡嘉诚 on 2021/3/2.
//

import Foundation
import RealmSwift

class Stocks: Object{
    
    @objc dynamic var symbol: String = ""
    @objc dynamic var price: Float = 0.0
    @objc dynamic var volume: Int = 0
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    
}
