//
//  DashboardViewController.swift
//  AdminAddProducts
//
//  Created by 胡嘉诚 on 2021/4/15.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func btnLogout(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popViewController(animated: true)
        }
        catch {
            print(error)
        }
        
    }
    
    
}
