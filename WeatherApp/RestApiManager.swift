//
//  RestApiManager.swift
//  WeatherApp
//
//  Created by kevin on 11/5/15.
//  Copyright © 2015 Kevin Argumedo. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager : NSObject {
    
    static let sharedInstance = RestApiManager()
    
    let baseURL = "http://api.openweathermap.org/data/2.5/forecast/"
    let test = "http://api.openweathermap.org/data/2.5/forecast/weather?zip=90280&APPID=c674bbd681d20481f9643e5d4959aa73"
    let test2 = "http://api.randomuser.me/"
    let apikey = "&APPID=c674bbd681d20481f9643e5d4959aa73"
    
    func getForecast(onCompletion: (JSON) -> Void) {
        makeHTTPGetRequest(test, onCompletion: { json , err -> Void in
            onCompletion(json)
        })
    }
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
        makeHTTPGetRequest(test2, onCompletion: { json , err -> Void in
            onCompletion(json)
        })
    }
    
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }
}