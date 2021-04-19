//
//  ViewController.swift
//  PickerViewSample
//
//  Created by 胡嘉诚 on 2021/4/19.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var txtCategories: UITextField!
    
    let arr = ["Beauty", "Beverages", "Breakfast", "Cooking", "Dairy", "Deserts", "Fruits", "Household", "Jams", "Mixes", "Snacks", "Vegetables"]
    
    let pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        txtCategories.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCategories.text = arr[row]
        txtCategories.resignFirstResponder()
    }
    
}

