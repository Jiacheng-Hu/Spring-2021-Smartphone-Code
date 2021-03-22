//
//  ViewController.swift
//  WorldWeatherTableView
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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    var weatherArr: [Forecast] = [Forecast]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WeatherTableViewCell", owner: self, options: nil)?.first as! WeatherTableViewCell
        cell.lblDate.text = "\(weatherArr[indexPath.row].date)"
        cell.lblCondition.text = weatherArr[indexPath.row].condition
        cell.lblHighTemp.text = "\(weatherArr[indexPath.row].highTemp) ℉"
        cell.lblLowTemp.text = "\(weatherArr[indexPath.row].lowTemp) ℉"
        return cell
    }
    
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCurrTemp: UILabel!
    @IBOutlet weak var lblCurrCondition: UILabel!
    @IBOutlet weak var lblDailyTemp: UILabel!
    @IBOutlet weak var tblWeather: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tblWeather.delegate = self
        tblWeather.dataSource = self
        
        lblCity.text = ""
        lblCurrTemp.text = ""
        lblCurrCondition.text = ""
        lblDailyTemp.text = ""
        for temp in weatherArr {
            print(temp.condition)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currLocation = locations.last {
            let lat = currLocation.coordinate.latitude
            let lng = currLocation.coordinate.longitude
            
            let locationURL = getLocationURL(lat, lng)
            getLocationData(locationURL)
                .done { (cityKey, city) in
                    let cityKey = cityKey
                    self.lblCity.text = city
                    let conditionURL = self.getConditionURL(cityKey)
                    self.getConditionData(conditionURL)
                        .done { (condition, currTemp) in
                            self.lblCurrTemp.text = "\(currTemp) ℉"
                            self.lblCurrCondition.text = condition
                        }.catch { error in
                            print("Error in getting current condition data \(error)")
                        }
                    let oneDayURL: String = self.getOneDayURL(cityKey)
                    self.getOneDayData(oneDayURL)
                        .done { (highTemp, lowTemp) in
                            self.lblDailyTemp.text = "H: \(highTemp) ℉, L: \(lowTemp) ℉"
                        }.catch { error in
                            print("Error in getting one day weather data \(error)")
                        }
                    let fiveDaysURL = self.getFiveDaysURL(cityKey)
                    self.getFiveDaysData(fiveDaysURL)
                        .done { (forecastArr) in
                            self.weatherArr = [Forecast]()
                            for forecast in forecastArr {
                                self.weatherArr.append(forecast)
                            }
                            self.tblWeather.reloadData()
                        }.catch { error in
                            print("Error in getting five days weather data \(error)")
                        }
                }.catch { error in
                    print("Error in getting location data \(error)")
                }
        }
    }
    
    func getLocationURL(_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) -> String {
        var url = locationURL
        url.append("?apikey=\(apiKey)")
        url.append("&q=\(lat),\(lng)")
        return url
    }
    
    func getLocationData(_ url: String) -> Promise <(String, String)> {
        return Promise <(String, String)> { seal -> Void in
            AF.request(url).responseJSON { response in
                if response.error != nil {
                    print(response.error!.localizedDescription)
                }
                guard let data = response.data else {return seal.fulfill(("",""))}
                let locationJson: JSON = JSON(data)
                let cityKey: String = locationJson["Key"].stringValue
                let city: String = locationJson["LocalizedName"].stringValue
                seal.fulfill((cityKey, city))
            }
        }
    }
    
    func getConditionURL(_ key: String) -> String {
        var url: String = conditionURL
        url.append(key)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getConditionData(_ url: String) -> Promise <(String, Int)> {
        return Promise <(String, Int)> { seal -> Void in
            AF.request(url).responseJSON { response in
                if response.error != nil {
                    print(response.error!.localizedDescription)
                }
                guard let data = response.data else {return seal.fulfill(("",0))}
                let conditionJson: [JSON] = JSON(data).arrayValue
                let condition: String = conditionJson[0]["WeatherText"].stringValue
                let currTemp: Int = conditionJson[0]["Temperature"]["Imperial"]["Value"].intValue
                seal.fulfill((condition, currTemp))
            }
            
        }
    }
    
    func getOneDayURL(_ key: String) -> String {
        var url = oneDayURL
        url.append(key)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getOneDayData(_ url: String) -> Promise <(Int, Int)> {
        return Promise <(Int, Int)> { seal -> Void in
            AF.request(url).responseJSON { response in
                if response.error != nil {
                    print(response.error!.localizedDescription)
                }
                guard let data = response.data else {return seal.fulfill((0,0))}
                let oneDayJson: [JSON] = JSON(data)["DailyForecasts"].arrayValue
                let highTemp: Int = oneDayJson[0]["Temperature"]["Maximum"]["Value"].intValue
                let lowTemp: Int = oneDayJson[0]["Temperature"]["Minimum"]["Value"].intValue
                seal.fulfill((highTemp, lowTemp))
            }
            
        }
    }
    
    func getFiveDaysURL(_ key: String) -> String {
        var url: String = fiveDaysURL
        url.append(key)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func getFiveDaysData(_ url: String) -> Promise <[Forecast]>{
        return Promise <[Forecast]> { seal -> Void in
            var arr: [Forecast] = [Forecast]()
            AF.request(url).responseJSON { response in
                if response.error != nil {
                    print(response.error!.localizedDescription)
                }
                guard let data = response.data else {return seal.fulfill(arr)}
                let fiveDaysJson: [JSON] = JSON(data)["DailyForecasts"].arrayValue
                for index in fiveDaysJson {
                    let dateStamp: String = index["Date"].stringValue
                    let startIndex = dateStamp.index(dateStamp.startIndex, offsetBy: 5)
                    let endIndex = dateStamp.index(dateStamp.startIndex, offsetBy: 9)
                    let date = String(dateStamp[startIndex...endIndex])
                    let condition: String = index["Day"]["IconPhrase"].stringValue
                    let highTemp: Int = index["Temperature"]["Maximum"]["Value"].intValue
                    let lowTemp: Int = index["Temperature"]["Minimum"]["Value"].intValue
                    let forecast = Forecast(date: date, condition: condition, highTemp: highTemp, lowTemp: lowTemp)
                    arr.append(forecast)
                }
                seal.fulfill(arr)
            }
        }
    }
}

