//
//  MapViewController.swift
//  Paymob Wallet
//
//  Created by mahmoud on 10/16/17.
//  Copyright © 2017 mahmoud. All rights reserved.
//

import UIKit
//import CoreLocation
import WebKit

class MapViewController: PayMobViewController {
    
//    , UIWebViewDelegate, CLLocationManagerDelegate
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var presenter: MapPresenter?
//    var locationManager: CLLocationManager!

    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.localization()
//
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//
//        webView.delegate = self
    }

    
//    func localization() {
//        self.navigationItem.title = NSLocalizedString("map", comment: "map")
//    }
//    
//    @IBAction func menuTapped(_ sender: Any) {
//        presenter?.menuClicked()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            manager.startUpdatingLocation()
//            //loader.hidden = true
//            webView.loadRequest(URLRequest(url: URL(string: "https://www.google.com/maps/d/embed?mid=1yedrPPyyw-J8Qc6MnEOWN9wH1ZU")!))
//        } else if status == .denied || status == .notDetermined {
//            //loader.hidden = true
//            webView.loadRequest(URLRequest(url: URL(string: "https://www.google.com/maps/d/embed?mid=1yedrPPyyw-J8Qc6MnEOWN9wH1ZU")!))
//            
//        }
//    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if locations.first != nil {
//            locationManager.stopUpdatingLocation()
//        }
//    }
//
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        loader.isHidden = false
//        loader.startAnimating()
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        loader.isHidden = true
//        webView.isHidden = false
//    }
//
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        loader.isHidden = true
//
//    }
    
}
