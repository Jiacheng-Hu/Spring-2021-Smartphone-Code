//
//  ViewController.swift
//  GetStockValues
//
//  Created by 胡嘉诚 on 2021/2/20.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var lblStockValue: UILabel!
    
    var globalStockTxtField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblStockValue.text = ""
    }
    
    @IBAction func alertAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Get Stock Price", message: "Type in The Symbol", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
//            self.lblStockValue.text = self.globalStockTxtField?.text
            guard let stock = self.globalStockTxtField?.text else {return}
            self.getStockValue(stock)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            
        }
        
        alert.addTextField { (stockTxtField) in
            stockTxtField.placeholder = "Please type stock name"
            self.globalStockTxtField = stockTxtField
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getStockValue(_ stockSymbol: String) {
        let url = getURL(stockSymbol)
//        print(url)
        SwiftSpinner.show("Getting \(stockSymbol) value")
        AF.request(url).responseJSON { response in
            SwiftSpinner.hide()
            if response.error == nil {
                guard let data = response.data else {return}
                let stockData: JSON = JSON(data)
//                print(stockData)
                guard let stocks = stockData.array else{return}
                if stocks.count == 0{
                    self.lblStockValue.text = "\(stockSymbol) does not exist"
                }else{
                    for stock in stocks {
                        self.lblStockValue.text = "\(stock["symbol"].stringValue) : $\(stock["price"].floatValue)"
                    }
                }
                
            }else{
                print(response.error?.localizedDescription ?? "error")
            }
        }
    }
    
    func getURL(_ stockSymbol: String) -> String{
        return apiURL + stockSymbol + "?apikey=" + apiKey
    }
    

}

