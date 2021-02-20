//
//  ViewController.swift
//  GetStockValues
//
//  Created by 胡嘉诚 on 2021/2/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblStockValue: UILabel!
    
    var globalStockTxtField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblStockValue.text = ""
    }
    
    @IBAction func alertAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Stock Sample", message: "Show Stock Value", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            self.lblStockValue.text = self.globalStockTxtField?.text
            print("ok")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("cancel")
        }
        
        alert.addTextField { (stockTxtField) in
            stockTxtField.placeholder = "Please type stock name"
            self.globalStockTxtField = stockTxtField
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

}

