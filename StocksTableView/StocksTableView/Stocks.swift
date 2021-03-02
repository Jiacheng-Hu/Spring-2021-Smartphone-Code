//
//  Stocks.swift
//  StocksTableView
//
//  Created by 胡嘉诚 on 2021/3/2.
//

import Foundation

class Stocks{
    
    var symbol: String
    var price: Float
    var volume: Int
    
    init(symbol: String, price: Float, volume: Int) {
        self.symbol = symbol
        self.price = price
        self.volume = volume
    }
}
