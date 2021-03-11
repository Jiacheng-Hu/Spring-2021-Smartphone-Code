//
//  ViewController.swift
//  WorldWeather
//
//  Created by 胡嘉诚 on 2021/3/11.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import PromiseKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblLng: UILabel!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        lblLat.text = ""
        lblLng.text = ""
    }

    @IBAction func getLatLng(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            
            let lat = currentLocation.coordinate.latitude
            let lng = currentLocation.coordinate.longitude
            
            lblLat.text = "Latitude: \(lat)"
            lblLng.text = "Longitude: \(lng)"
            
            print(lat)
            print(lng)
            
        }
    }
    
}

