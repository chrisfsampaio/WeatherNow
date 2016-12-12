//
//  WeekCell.swift
//  WeatherNow
//
//  Created by Christian Sampaio on 8/18/15.
//  Copyright © 2015 Christian Sampaio. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var forecastImageView: UIImageView!
    
    func configureWithWeather(_ weather: Weather) {
        dayNameLabel.text = weather.dayName
        forecastImageView.image = UIImage(named: weather.iconName)
    }
}
