//
//  ThirdViewController.swift
//  WeatherApp
//
//  Created by Michał Aibin on 04.11.2015.
//  Copyright © 2015 CodeRunner. All rights reserved.
//

import UIKit

class Third3DaysController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.frame = self.view.bounds
        self.webView.scalesPageToFit = true
        self.location.delegate = self;
        self.location.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
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
        loadWeatherConditions(2, location: self.location, webView: self.webView, label: self.label, viewController: self);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
        loadWeatherConditions(2, location: self.location, webView: self.webView, label: self.label, viewController: self);
    }
    
    func textFieldShouldReturn(text: UITextField) -> Bool {
        loadWeatherConditions(2, location: self.location, webView: self.webView, label: self.label, viewController: self);
        text.resignFirstResponder()
        return true;
    }

    @IBAction func updateLocation(sender: AnyObject) {
        checkAddressFromLocation(userLocation, location: location, webView: webView, label: label, viewController: self);
    }
}

