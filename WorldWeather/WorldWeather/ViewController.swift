//
//  ViewController.swift
//  WorldWeather
//
//  Created by 胡嘉诚 on 2021/3/13.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit
import RealmSwift
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCurrTemp: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        lblCity.text = ""
        lblCurrTemp.text = ""
        lblCondition.text = ""
        lblTemperature.text = ""
        
    }
    
    @IBAction func getWeatherButton(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currLocation = locations.last {
            
            let lat = currLocation.coordinate.latitude
            
            let lng = currLocation.coordinate.longitude
            
            let url = getLocationURL(lat, lng)
            
            getLocationData(url)
                .done { (key, city) in
                    self.lblCity.text = city
                    let conditionURL = self.getConditionURL(key)
                    self.getConditionData(conditionURL)
                        .done { (condition, currTemp) in
                            self.lblCondition.text = condition
                            self.lblCurrTemp.text = "\(currTemp) ℉"
                        }.catch { error in
                            print("Error in getting condition data \(error.localizedDescription)")
                        }
                    let dailyTempURL = self.getDailyTempURL(key)
                    self.getDailyTempData(dailyTempURL)
                        .done { (highTemp, lowTemp) in
                            self.lblTemperature.text = "H: \(highTemp) ℉, L: \(lowTemp) ℉"
                        }.catch { error in
                            print("Error in getting daily temperature data \(error.localizedDescription)")
                        }
                }.catch { error in
                    print("Error in getting location data \(error.localizedDescription)")
                }
            
        }
        
    }
    
    func getLocationURL(_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) -> String{
        
        var url = locationURL
        
        url.append("?apikey=\(apiKey)")
        
        url.append("&q=\(lat),\(lng)")
        
        return url
        
    }
    
    func getLocationData(_ url: String) -> Promise<(String, String)> {
        
        return Promise<(String, String)> { seal -> Void in
            
            SwiftSpinner.show("Getting Weather...")
            
            AF.request(url).responseJSON { response in
                
                SwiftSpinner.hide()
                
                if response.error != nil {
                    
                    print(response.error!.localizedDescription)
                    
                }
                
                guard let data = response.data else {return seal.fulfill(("",""))}
                
                let locationJson = JSON(data)
                
                let key: String = locationJson["Key"].stringValue
                
                let city: String = locationJson["LocalizedName"].stringValue
                
                seal.fulfill((key, city))
                
            }
            
        }
        
    }
    
    func getConditionURL(_ key: String) -> String {
        
        var url = conditionURL
        
        url.append(key)
        
        url.append("?apikey=\(apiKey)")
        
        return url
        
    }
    
    func getConditionData(_ url: String) -> Promise<(String, Int)> {
        
        return Promise<(String, Int)> { seal -> Void in
            
            SwiftSpinner.show("Getting Weather...")
            
            AF.request(url).responseJSON { response in
                
                SwiftSpinner.hide()
                
                if response.error != nil {
                    
                    print(response.error!.localizedDescription)
                    
                }
                
                guard let data = response.data else {return seal.fulfill(("", 0))}
                
                let conditionJson: [JSON] = JSON(data).arrayValue
                
                let condition: String = conditionJson[0]["WeatherText"].stringValue
                
                let currTemp: Int = conditionJson[0]["Temperature"]["Imperial"]["Value"].intValue
                
                seal.fulfill((condition, currTemp))

            }
            
        }
    }
    
    func getDailyTempURL(_ key: String) -> String {
        
        var url = dailyTempURL
        
        url.append(key)
        
        url.append("?apikey=\(apiKey)")
        
        return url
        
    }
    
    func getDailyTempData(_ url: String) -> Promise<(Int, Int)> {
        
        return Promise<(Int, Int)> { seal -> Void in
            
            SwiftSpinner.show("Getting Weather...")
            
            AF.request(url).responseJSON { response in
                
                SwiftSpinner.hide()
                
                if response.error != nil {
                    
                    print(response.error!.localizedDescription)
                    
                }
                
                guard let data = response.data else {return seal.fulfill((0,0))}
                
                let dailyTempJson: [JSON] = JSON(data)["DailyForecasts"].arrayValue
                
                let highTemp: Int = dailyTempJson[0]["Temperature"]["Maximum"]["Value"].intValue
                
                let lowTemp: Int = dailyTempJson[0]["Temperature"]["Minimum"]["Value"].intValue
                
                seal.fulfill((highTemp, lowTemp))
                
            }
            
        }
    }
    

}

