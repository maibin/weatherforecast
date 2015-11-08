//
//  FirstViewController.swift
//  WeatherApp
//
//  Created by Michał Aibin on 03.11.2015.
//  Copyright © 2015 CodeRunner. All rights reserved.
//

import UIKit

var locationString:String = "";

class First3DaysController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.frame = self.view.bounds
        self.webView.scalesPageToFit = true
        if (NSUserDefaults.standardUserDefaults().objectForKey("location") != nil){
            locationString = (NSUserDefaults.standardUserDefaults().objectForKey("location") as? String)!;
        }
        self.location.delegate = self;
        self.location.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidChange(textField: UITextField){
        if (location.text != ""){
            locationString = location.text!;
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        location.text = locationString;
        loadWeatherConditions();
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
        loadWeatherConditions();
    }
    
    func loadWeatherConditions(){
        if (locationString != ""){
            NSUserDefaults.standardUserDefaults().setObject(locationString, forKey: "location");
            let url = NSURL(string: "http://www.weather-forecast.com/locations/" + checkForSpecialDigits(location) + "/forecasts/latest")!;
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                //will happen when task completes
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let webArray = webContent?.componentsSeparatedByString("<a class=\"units imperial\">&deg;F</a></div>");
                    let initArray = webContent?.componentsSeparatedByString("<link href=\"/favicon.ico\"")
                    
                    if !webArray![0].containsString("You may have mistyped the address"){
                        
                        let weatherArray = webArray![1].componentsSeparatedByString("</div><p class=\"local-time-line\">");
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.webView.loadHTMLString(String(initArray![0] + weatherArray[0]), baseURL: nil);
                            self.label.hidden = true;
                        })
                        
                    } else {
                        if (self.location.text! != ""){
                            self.createAnAlert("There is no \(self.location.text!) in our database, please provide different city");
                        }
                    }
                }
            }
            task.resume();
        } else {
            location.placeholder = "Type a location, e.g. London, Vancouver";
        }
    }
    
    func textFieldShouldReturn(text: UITextField) -> Bool {
        loadWeatherConditions();
        text.resignFirstResponder()
        return true;
    }
    
    func checkForSpecialDigits(text: UITextField) -> String {
        return (text.text!.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "-").stringByReplacingOccurrencesOfString("ą", withString: "a").stringByReplacingOccurrencesOfString("ć", withString: "c").stringByReplacingOccurrencesOfString("ę", withString: "e").stringByReplacingOccurrencesOfString("ł", withString: "l").stringByReplacingOccurrencesOfString("ń", withString: "n").stringByReplacingOccurrencesOfString("ó", withString: "o").stringByReplacingOccurrencesOfString("ś", withString: "s").stringByReplacingOccurrencesOfString("ż", withString: "z").stringByReplacingOccurrencesOfString("ź:", withString: "z"));
    }
    
    func createAnAlert(message: String){
        let alertController = UIAlertController(title: "Invalid parameter", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

