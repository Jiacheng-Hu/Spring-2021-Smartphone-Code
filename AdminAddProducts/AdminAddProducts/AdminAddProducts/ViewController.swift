//
//  ViewController.swift
//  AdminAddProducts
//
//  Created by 胡嘉诚 on 2021/4/13.
//

import UIKit
import Firebase
import SwiftSpinner

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblStatus.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = KeychainService().keyChain
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        txtPassword.text = ""
    }
    
    func addKeychainAfterLogin(_ uid: String) {
        let keyChain = KeychainService().keyChain
        keyChain.set(uid, forKey: "uid")
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if email == "" || password == "" || password.count < 6 {
            lblStatus.text = "Please enter valid Email/Password"
            return
        }
        
        if !email.isEmail {
            lblStatus.text = "Please enter valid Email"
            return
        }
        
        SwiftSpinner.show("Logging in...")
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            SwiftSpinner.hide()
            guard let self = self else { return }
            
            if error != nil {
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            self.addKeychainAfterLogin(uid)
            
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        
    }
    
    


}

