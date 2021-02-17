//
//  ViewController.swift
//  AlertControllerExample
//
//  Created by 胡嘉诚 on 2021/2/16.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblText: UILabel!
    
    var globalTxtField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblText.text = "Please click the button"
    }

    @IBAction func actionController(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert Example", message: "Alert", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (actionController) in
            print("Ok")
            self.lblText.text = self.globalTxtField?.text
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (actionController) in
            print("Cancel")
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        alert.addTextField { (txtField) in
            txtField.placeholder = "Type Something"
            self.globalTxtField = txtField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

