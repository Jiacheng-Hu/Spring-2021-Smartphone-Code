//
//  Forecast.swift
//  WorldWeatherTableView
//
//  Created by 胡嘉诚 on 2021/3/14.
//

import Foundation

class Forecast {
    
    var date: String
    var condition: String
    var highTemp: Int
    var lowTemp: Int
    
    init(date: String, condition: String, highTemp: Int, lowTemp: Int) {
        self.date = date
        self.condition = condition
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }
    
}
