//
//  WeatherTableViewCell.swift
//  WorldWeatherTableView
//
//  Created by 胡嘉诚 on 2021/3/14.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblHighTemp: UILabel!
    @IBOutlet weak var lblLowTemp: UILabel!
    

    
    
}
