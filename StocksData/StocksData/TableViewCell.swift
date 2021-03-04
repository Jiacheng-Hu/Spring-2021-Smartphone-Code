//
//  TableViewCell.swift
//  StocksData
//
//  Created by 胡嘉诚 on 2021/3/2.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
