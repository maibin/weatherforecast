//
//  Utilities.swift
//  WeatherApp
//
//  Created by Michal Aibin on 24.11.2015.
//  Copyright © 2015 CodeRunner. All rights reserved.
//

import UIKit

func showSimpleAlertWithTitle(message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: "Invalid parameter", message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}


func checkForSpecialDigits(text: UITextField) -> String {
    return (text.text!.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "-").stringByReplacingOccurrencesOfString("ą", withString: "a").stringByReplacingOccurrencesOfString("ć", withString: "c").stringByReplacingOccurrencesOfString("ę", withString: "e").stringByReplacingOccurrencesOfString("ł", withString: "l").stringByReplacingOccurrencesOfString("ń", withString: "n").stringByReplacingOccurrencesOfString("ó", withString: "o").stringByReplacingOccurrencesOfString("ś", withString: "s").stringByReplacingOccurrencesOfString("ż", withString: "z").stringByReplacingOccurrencesOfString("ź:", withString: "z"));
}

func loadWeatherConditions(whichDay: Int, location: UITextField!, webView: UIWebView!, label: UILabel!, viewController: UIViewController){
    if (locationString != ""){
        var htmlSearch = ["<a class=\"units imperial\">&deg;F</a></div>", "</div><p class=\"local-time-line\">", ""];
        var htmlIndex = 0;
        NSUserDefaults.standardUserDefaults().setObject(locationString, forKey: "location");
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + checkForSpecialDigits(location) + "/forecasts/latest")!;
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            //will happen when task completes
            
            if (whichDay == 0){
                htmlIndex = 1;
            } else if (whichDay == 1){
                htmlIndex = 1;
                htmlSearch = ["<div class=\"forecast-cont\"><table class=\"forecasts\">", "</div><div class=\"not_in_print centered-b b-with-whitespace\">", "<table class=\"forecasts\">"];
            } else if (whichDay == 2){
                htmlSearch = ["<div class=\"forecast-cont\"><table class=\"forecasts\">", "</div><div class=\"not_in_print centered-b b-with-whitespace\">", "<table class=\"forecasts\">"];
                htmlIndex = 2;
            }
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let webArray = webContent?.componentsSeparatedByString(htmlSearch[0]);
                let initArray = webContent?.componentsSeparatedByString("<link href=\"/favicon.ico\"")
                
                if !webArray![0].containsString("You may have mistyped the address"){
                    
                    let weatherArray = webArray![htmlIndex].componentsSeparatedByString(htmlSearch[1]);
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        webView.loadHTMLString(String(initArray![0] + htmlSearch[2] + weatherArray[0]), baseURL: nil);
                        label.hidden = true;
                    })
                    
                } else {
                    if (location.text! != ""){
                        showSimpleAlertWithTitle("There is no \(location.text!) in our database, please provide different city", viewController: viewController);
                    }
                }
            }
        }
        task.resume();
    } else {
        location.placeholder = "Type a location, e.g. London, Vancouver";
    }
}
