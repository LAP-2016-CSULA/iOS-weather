//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by kevin on 11/9/15.
//  Copyright © 2015 Kevin Argumedo. All rights reserved.
//

import UIKit
import Foundation

class WeatherViewController: UIViewController{
    
    @IBOutlet var weatherPic: UIImageView!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var weatherTitle: UILabel!
    var day : Forecast?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        weatherTitle.text = day?.weather
    
        temperature.text = day?.temperature
        
        if(day?.weather.lowercaseString == "clear")
        {
            weatherPic.image = UIImage(named: "clear")
        }
        else if (day?.weather.lowercaseString == "rain")
        {
            weatherPic.image = UIImage(named: "rain")
        }
        else if (day?.weather.lowercaseString == "snow")
        {
            weatherPic.image = UIImage(named: "snow")
        }
        else
        {
            weatherPic.image = UIImage(named:"background")
        }
        
        
    }
    
    
}

