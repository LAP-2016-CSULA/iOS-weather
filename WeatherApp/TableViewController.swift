//
//  ViewController.swift
//  WeatherApp
//
//  Created by kevin on 11/4/15.
//  Copyright © 2015 Kevin Argumedo. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{

    
    var forecast = [Forecast]()
//    Mutable Array may be needed, Structure will be used for now.
//    var items = NSMutableArray()
    var city:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        adds some days of the week, Testing purposes
//        forecast = [Forecast(day: "Monday"),Forecast(day: "Tuesday"),Forecast(day: "Wednesday"), Forecast(day: "Thursday"), Forecast(day: "Friday")]
        
        //Gets Five Day Forecast
        getFiveDayForecastData()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //gets the five day forecast
    func getFiveDayForecastData()
    {
        //API Call using restAPIManager, programmed beforehand
        RestApiManager.sharedInstance.getForecast { json -> Void in
            
            let cityName = json["city"]["name"]
            self.city = "Weather in " + String(cityName)
            
            let list = json["list"]
            for (_, subJson):(String, JSON) in list
            {
                //Date and Time
                let dateTime = String(subJson["dt_txt"])
                let rangeDate = dateTime.startIndex..<dateTime.endIndex.advancedBy(-9)
                let rangeTime = dateTime.startIndex.advancedBy(11)..<dateTime.endIndex
                let time = dateTime[rangeTime]
                let date = dateTime[rangeDate]
                
                let temperature = String(subJson["main"]["temp"])
                var weather = "";
                
                for(_,weath):(String, JSON) in subJson["weather"]
                {
                    weather = String(weath["main"])
                }
                
                print(weather)
                
                //removes everything except weather at noon
                if(time == "12:00:00")
                {
                    //creates a new forecast struct
                    let day:Forecast = Forecast(date: date, time: time, weather: weather ,temperature: temperature)
                    
                    self.forecast.insert(day, atIndex: self.forecast.count)
                }
                dispatch_async(dispatch_get_main_queue(), { tableView?.reloadData()})
            }
        }
    }
    
    
    //gives number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecast.count
    }
    
    //identifies each cell per row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let day : Forecast
        
        self.title = self.city

        day = forecast[indexPath.row]
        
        //To be displayed on cell
        let displayRow: String = day.date + "     " + day.weather + "     " + day.temperature + "K"
        cell.textLabel?.text = displayRow
        
        return cell
    }


}

