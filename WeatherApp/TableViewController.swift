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
        
        tableView.backgroundColor = UIColor.grayColor()
        
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
                
                let kTemperature = String(subJson["main"]["temp"])
                var weather = "";
                
                //accesses JSON list and gets weather
                for(_,weath):(String, JSON) in subJson["weather"]
                {
                    weather = String(weath["main"])
                }
                
                //removes everything except weather at a certain time
                if(time == "21:00:00")
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let nDate = dateFormatter.dateFromString(date);
                    dateFormatter.dateFormat = "EEEE"
                    
                    let rDate = dateFormatter.stringFromDate(nDate!)
                    
                    let temperature = self.kelvintoFahrenheit(kTemperature)

                    //creates a new forecast struct
                    let day:Forecast = Forecast(date: rDate, time: time, weather: weather ,temperature: temperature)
                    
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
        let displayRow: String = day.date + "     " + day.weather + "     " + day.temperature + "F"
        cell.textLabel?.text = displayRow
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    //Converts Kelvin to Fahrenheit
    func kelvintoFahrenheit(kelv:String) ->String
    {
        let kelvin = Double(kelv)
        let tFahr:String = String(((kelvin! * 9.0)/5.0) - 459.67)
        
        if (tFahr.characters.count > 4)
        {
            let fRange = tFahr.startIndex..<tFahr.startIndex.advancedBy(4)
            return tFahr[fRange]
        }
        else
        {
            return tFahr
        }
    }
}

