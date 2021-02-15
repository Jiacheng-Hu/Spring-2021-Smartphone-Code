//
//  TableViewController.swift
//  Sample
//
//  Created by 胡嘉诚 on 2021/2/15.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cities: [String] = ["Seattle", "Los Angeles", "San Francisco", "San Jose", "New York"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblCities.text = cities[indexPath.row]
        return cell
    }

}
