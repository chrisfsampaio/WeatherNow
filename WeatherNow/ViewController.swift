//
//  ViewController.swift
//  WeatherNow
//
//  Created by Christian Sampaio on 8/18/15.
//  Copyright © 2015 Christian Sampaio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Weather.fetchCurrentWeather("São Carlos") { weather in
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperature) ˚"
            self.imageView.image = UIImage(named: weather.iconName)
        }
        
        Weather.fetchForecast("São Carlos") { weathers in
            weathers.forEach { element in
//                print(element.dayName)
//                print(element.temperature)
            }
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }


}

