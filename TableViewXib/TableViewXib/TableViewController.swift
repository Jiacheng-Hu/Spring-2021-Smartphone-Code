//
//  TableViewController.swift
//  TableViewXib
//
//  Created by 胡嘉诚 on 2021/2/15.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cities:[String] = ["Seattle", "Portland", "San Francisco", "New York"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblCities.text = cities[indexPath.row]
        return cell
    }

}
