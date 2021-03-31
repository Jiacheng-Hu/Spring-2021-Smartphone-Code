//
//  ViewController.swift
//  LoginProject
//
//  Created by 胡嘉诚 on 2021/3/30.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
//        let email = txtEmail.text!
//        let password = txtPassword.text!
//
//        if email.count == 0 || password.count < 6 {
//            lblStatus.text = "Please enter valid email or password"
//        }
//
//        if !email.isValidEmail {
//            lblStatus.text = "Please enter valid email or password"
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//
//            if error != nil {
//                self.lblStatus.text = error?.localizedDescription
//                return
//            }
//
//        }
        
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    


}

