//
//  Weather.swift
//  WeatherNow
//
//  Created by Christian Sampaio on 8/18/15.
//  Copyright © 2015 Christian Sampaio. All rights reserved.
//

import Foundation
import Alamofire

struct Weather {
    let cityName: String
    let temperature: Double
    let date: Date
    let iconName: String
    
    static let formatter = DateFormatter()
    
    var dayName: String {
        Weather.formatter.dateFormat = "EEEE"
        
        return Weather.formatter.string(from: self.date)
    }
    
}

func ==(item1: Weather, item2: Weather) -> Bool {
    return item1.date == item2.date
}

extension Weather {
    
    //Tempo atual
    init?(json: [String: AnyObject]) {
        
        let name = (json["name"] as? String),
        timeInterval = json["dt"] as? Double,
        temperatureValue = json["main"]?["temp"] as? Double,
        weather = json["weather"] as? [[String: AnyObject]],
        iconCode = weather?.first?["icon"] as? String
        
        self.init(cityName: name, timeInterval: timeInterval, temperature: temperatureValue, iconCode: iconCode)
    }
    
    //Previsão para 5 dias
    init?(cityName: String, json: [String: AnyObject]) {
        let timeInterval = json["dt"] as? Double,
        temperatureValue = json["main"]?["temp"] as? Double,
        weather = json["weather"] as? [[String: AnyObject]],
        iconCode = weather?.first?["icon"] as? String
        
        self.init(cityName: cityName, timeInterval: timeInterval, temperature: temperatureValue, iconCode: iconCode)
    }
    
    init?(cityName: String?, timeInterval: Double?, temperature: Double?, iconCode: String?) {
        guard let name = cityName,
            let dateInterval = timeInterval,
            let temperatureValue = temperature,
            let iconCodeName = iconCode else {
                return nil
        }
        
        self.cityName = name
        self.date = Date(timeIntervalSince1970: dateInterval)
        self.temperature = temperatureValue
        self.iconName = Weather.iconName(iconCodeName)
    }
}

extension Weather {
    
    static func parseForecast(_ forecastJSON: [String: AnyObject]) -> [Weather] {
        
        guard let name = forecastJSON["city"]?["name"] as? String, let list = forecastJSON["list"] as? [[String: AnyObject]] else {
                return []
        }
        
        let calendar = Calendar.current
        
        let temperatures = list.flatMap { Weather(cityName: name, json: $0) }
        
        let filteredTemperatures = temperatures.filter { element in
            let components = calendar.dateComponents([.hour], from: element.date)
            //FIXME: components.hour returns values not considering timesaving, now starts at 1hour, so it's using components.hour == 13 here.
            return components.hour == 13
        }
        return filteredTemperatures
    }
}

extension Weather {
    
    static func fetchCurrentWeather(_ cityName: String, completion: @escaping (Weather) -> Void) {
        
        let parameters = ["q" : cityName, "units" : "metric", "APPID" : "c1a08f415bc60f69b9b814bd85477654"]
        let endpoint = "http://api.openweathermap.org/data/2.5/weather"
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                if let weather = Weather(json: (value as! [String: AnyObject])) {
                    completion(weather)
                }
                
            case .failure(let error):
                dump(error)
            }
            
        }
    }
    
    static func fetchForecast(_ cityName: String, completion: @escaping ([Weather]) -> Void) {
        
        let parameters = ["q" : cityName, "units" : "metric", "APPID" : "c1a08f415bc60f69b9b814bd85477654"]
        let endpoint = "http://api.openweathermap.org/data/2.5/forecast"
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let temperatures = Weather.parseForecast(value as! [String: AnyObject])
                completion(temperatures)
                
            case .failure(let error):
                print("\(error)")
            }
            
        }
    }
    
    static func iconName(_ code: String) -> String {
        switch code {
        case "01d":
            return "clear-day"
            
        case "01n":
            return "clear-night"
            
        case "02d", "03d", "04d", "02n", "03n", "04n":
            return "cloudy"
            
        case "09d", "10d", "11d", "09n", "10n", "11n":
            return "rain"
            
        case "13d", "13n":
            return "snow"
            
        default:
            return "clear-day"
        }
    }
    
}
