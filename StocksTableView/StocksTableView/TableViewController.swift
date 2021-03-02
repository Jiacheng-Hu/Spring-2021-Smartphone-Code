//
//  TableViewController.swift
//  StocksTableView
//
//  Created by 胡嘉诚 on 2021/3/2.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class TableViewController: UITableViewController {
    
    @IBOutlet var tblStocks: UITableView!
    var symbolArr: [String] = [String]()
    var stockArr: [Stocks] = [Stocks]()
    var globalTxtField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    @IBAction func addSymbol(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Get Stock Values", message: "Type Symbol", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (addSymbolAction) in
            
            guard let symbol = self.globalTxtField?.text else {return}
            if symbol == ""{
                return
            }else{
                self.symbolArr.append(symbol)
            }
            self.getData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (addSymbolAction) in
            
        }
        
        alert.addTextField { (symbolTxtField) in
            self.globalTxtField = symbolTxtField
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stockArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell

        cell.lblSymbol.text = "\(stockArr[indexPath.row].symbol): "
        cell.lblPrice.text = "$ \(stockArr[indexPath.row].price)"

        return cell
    }
    
    func getURL() -> String {
        
        var url = apiURL
        for symbol in symbolArr{
            url.append(symbol + ",")
        }
        url = String (url.dropLast())
        url.append("?apikey=\(apiKey)")
        return url
        
    }
    
    func getData() {
        
        let url = getURL()
        if symbolArr.count == 0{
            return
        }
        SwiftSpinner.show("Getting Values...")
        AF.request(url).responseData { response in
            SwiftSpinner.hide()
            if response.error == nil{
                guard let stockData = response.data else {return}
                if stockData.count == 0{
                    return
                }
                self.stockArr = [Stocks]()
                guard let stocks = JSON(stockData).array else {return}
                for stock in stocks{
                    let symbol = stock["symbol"].stringValue
                    let price = stock["price"].floatValue
                    let volume = stock["volume"].intValue
                    self.stockArr.append(Stocks(symbol: symbol, price: price, volume: volume))
                }
                self.tblStocks.reloadData()
            }
        }
    }

}
