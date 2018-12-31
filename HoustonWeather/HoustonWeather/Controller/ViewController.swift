//
//  ViewController.swift
//  HoustonWeather
//
//  Created by Alex Zhang on 2018-12-31.
//  Copyright © 2018 Alex Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {

    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "982bbc015903b7d73b93970f9b62a54c"
    
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
    
    @IBOutlet weak var currentTemperature: UILabel!
    
    @IBOutlet weak var getWeatherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.layer.cornerRadius = 5
        getWeatherButton.layer.borderWidth = 1
        getWeatherButton.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getWeatherData (url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess {
                print("successfully get JSON response!")
                //Functionality provided by swiftJSON to convert "any" to JSON easily
                //force unwrapped after checking success
                let jso: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: jso)
                print(jso)
            }else {
                print("fail to get JSON response!")
                self.currentTemperature.text = "Fail to get location infomation"
                
            }
        }
    }
    
    func updateWeatherData (json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        }else{
            // if json["main"]["temp"] == nil
            currentTemperature.text = "Weather Unavaliable"
        }
    }
    
    func updateUIWithWeatherData () {
        let temperature:String = String(weatherDataModel.temperature)
        //° == shift + option + 8
        currentTemperature.text = "\(temperature)°"
        currentWeatherImage.image = UIImage(named: weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition))
    }
    
    func userEnteredANewCityName(city: String) {
        let param: [String:String] = ["q":city, "appid":APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: param)
    }
    
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        userEnteredANewCityName(city: "Houston")
    }
    
}

