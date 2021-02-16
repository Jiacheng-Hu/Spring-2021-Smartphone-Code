//
//  ViewController.swift
//  AlertControllerExample
//
//  Created by 胡嘉诚 on 2021/2/16.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionController(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert Example", message: "Alert", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (actionController) in
            print("Ok")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (actionController) in
            print("Cancel")
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

