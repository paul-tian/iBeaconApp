//
//  ViewController.swift
//  BeaconDetector
//
//  Created by Yuzhe Tian on 30/01/2018.
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString:"B0702880-A295-A8AB-F734-031A98A512DE")!, identifier: "Macbook")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1);
       
        //if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
        //locationManager.requestWhenInUseAuthorization()
        //}
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //print(beacons)
        //var closetBeacon: CLBeacon
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.unknown}
        if (knownBeacons.count > 0) {
            let closetBeacon = knownBeacons[0] as CLBeacon
            print(closetBeacon)
        }
//        print(closetBeacon)
//            didSet {
//                BeaconLabel.text = closetBeacon
//        }
    }
    
}

