//
//  WeekTableViewController.swift
//  WeatherNow
//
//  Created by Christian Sampaio on 8/18/15.
//  Copyright © 2015 Christian Sampaio. All rights reserved.
//

import UIKit

class WeekTableViewController: UITableViewController {
    
    var weathers: [Weather]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .whiteColor()
        self.refreshControl?.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
        
        Weather.fetchForecast("São Carlos") { weathers in
            self.weathers = weathers
            
            self.tableView.reloadData()
        }
    }
    
    func refreshData() {
        Weather.fetchForecast("São Carlos") { weathers in
            self.weathers = weathers
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WeekCell") as! WeekCell
        let weather = self.weathers![indexPath.row]
        cell.configureWithWeather(weather)
        
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
