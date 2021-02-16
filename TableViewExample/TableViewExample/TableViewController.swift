//
//  TableViewController.swift
//  TableViewExample
//
//  Created by 胡嘉诚 on 2021/2/12.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cities: [String] = ["Seattle", "San Francisco", "New York", "Bellvue", "Redmond", "Tacoma", "SeaTac", "Los Angeles", "San Jose", "Silicon Valley", "San Diego", "Boston"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }

}
