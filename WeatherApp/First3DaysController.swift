//
//  FirstViewController.swift
//  WeatherApp
//
//  Created by Michał Aibin on 03.11.2015.
//  Copyright © 2015 CodeRunner. All rights reserved.
//

import UIKit
import MapKit

class First3DaysController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var label: UILabel!
    
    var locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.frame = self.view.bounds
        self.webView.scalesPageToFit = true
        if (NSUserDefaults.standardUserDefaults().objectForKey("location") != nil){
            locationString = (NSUserDefaults.standardUserDefaults().objectForKey("location") as? String)!;
        }
        self.location.delegate = self;
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.requestWhenInUseAuthorization();
        startTimer(locationManager);
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
        loadWeatherConditions(0, location: self.location, webView: self.webView, label: self.label, viewController: self);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
        loadWeatherConditions(0, location: self.location, webView: self.webView, label: self.label, viewController: self);
    }
    
    func textFieldShouldReturn(text: UITextField) -> Bool {
        loadWeatherConditions(0, location: self.location, webView: self.webView, label: self.label, viewController: self);
        text.resignFirstResponder()
        return true;
    }
    
    @IBAction func updateLocation(sender: AnyObject) {
        checkAddressFromLocation(userLocation, location: location, webView: webView, label: label, viewController: self);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0];
    }
}

