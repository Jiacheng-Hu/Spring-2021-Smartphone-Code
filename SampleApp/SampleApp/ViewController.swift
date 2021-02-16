//
//  ViewController.swift
//  SampleApp
//
//  Created by 胡嘉诚 on 2021/1/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var insIsVisible:Bool = false
    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var imgContent: UIImageView!
    
    @IBAction func pressFunction(_ sender: UIButton) {
        if (insIsVisible == false) {
            imgContent.image = UIImage(named: "Ins")
            lblContent.text = "Instagram"
            insIsVisible = true
        } else {
            imgContent.image = UIImage(named: "FB")
            lblContent.text = "Facebook"
            insIsVisible = false
        }
    }
    


}

