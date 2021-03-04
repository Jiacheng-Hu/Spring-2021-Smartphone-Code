//
//  TableViewController.swift
//  StocksData
//
//  Created by 胡嘉诚 on 2021/3/2.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import PromiseKit

class TableViewController: UITableViewController {
    
    @IBOutlet var tblStocks: UITableView!
    var globalTxtField: UITextField?
    var symbolArr: [String] = [String]()
    var stockArr: [Stocks] = [Stocks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromDB()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(objcGetData), for: .valueChanged)
        self.refreshControl = refreshControl
        
        
        
//        do{
//            let _ = try Realm()
//        }catch{
//            print("Error in initializing realm")
//        }
//
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
    }
    
    @IBAction func addSymbol(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Get Stocks Value", message: "Type Symbol", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (addSymbolAction) in
            guard let symbol = self.globalTxtField?.text else {return}
            if symbol == "" {
                return
            }
//            self.symbolArr.append(symbol)
//            self.getData()
//            self.addStockToDB()
            
            if self.doesStockExist(symbol) {
                return
            }
            self.getStocksData(symbol)
            
            
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
        for symbol in symbolArr {
            url.append(symbol + ",")
        }
        url = String(url.dropLast())
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getData() {
        let url = getURL()
        if symbolArr.count == 0 {
            return
        }
        getQuickShortQuote(url)
            .done { (stocks) in
                self.stockArr = [Stocks]()
                for stock in stocks {
                    self.stockArr.append(stock)
                }
                self.updateValuesInDB(stocks: self.stockArr)
                self.tblStocks.reloadData()
            }
            .catch { (error) in
                print(error)
            }
    }
    
    func addStockToDB(_ stock: Stocks) {
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(stock)
            }
        }catch{
            print("Error in initializing realm")
        }
    }
    
    @objc func objcGetData() {
        getData()
        self.refreshControl?.endRefreshing()
    }
    
    func getSymbolURL (_ symbol: String) -> String {
        
        var url = apiURL
        url.append(symbol)
        url.append("?apikey=")
        url.append(apiKey)
        
        return url
        
    }
    
    func getStocksData (_ symbol: String) {
        
        let url = getSymbolURL(symbol)
        
        getQuickShortQuote(url)
        
            .done { (stocks) in
                
                self.addStockToDB(stocks[0])
                self.symbolArr.append(stocks[0].symbol)
                self.getData()
                
            }
            .catch { (error) in
                print(error)
            }
                
    }
    
    func doesStockExist(_ symbol: String) -> Bool {
        
        let realm = try! Realm()
        
        if realm.object(ofType: Stocks.self, forPrimaryKey: symbol) != nil {
            return true
        } else {
            return false
        }
    }
    
    func getDataFromDB() {
        
        do{
            let realm = try Realm()
            
            let stocks = realm.objects(Stocks.self)
            
            for stock in stocks {
                
                symbolArr.append(stock.symbol)
                
            }
            
        }catch{
            print("Error in getting values from database \(error)")
        }
        
        getData()
    }
    
    func updateValuesInDB(stocks: [Stocks]) {
        
        do {
            
            let realm = try Realm()
            
            for stock in stocks {
                
                try realm.write{
                    realm.add(stock, update: .modified)
                }
                
            }
        } catch {
            
            print("Error in updating values in database \(error)")
            
        }
        
    }
    
    
    
    func getQuickShortQuote(_ url: String) -> Promise<[Stocks]> {
        
        return Promise<[Stocks]> {seal -> Void in
            SwiftSpinner.show("Getting Stock Price...")
            AF.request(url).responseJSON { response in
                SwiftSpinner.hide()
                if response.error == nil {
                    
                    var arr = [Stocks]()
                    
                    guard let data = response.data else {return seal.fulfill(arr)}
                    guard let stocks = JSON(data).array else {return seal.fulfill(arr)}
                    
                    for stock in stocks {
                        
                        let symbol = stock["symbol"].stringValue
                        let price = stock["price"].floatValue
                        let volume = stock["volume"].intValue
                        
                        let temp = Stocks()
                        temp.symbol = symbol
                        temp.price = price
                        temp.volume = volume
                        
                        arr.append(temp)
                    }
                    
                    seal.fulfill(arr)
                    
                }else{
                    seal.reject(response.error!)
                }

            }
        }
    }
    
}
