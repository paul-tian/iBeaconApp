//
//  BlueTooth.swift
//  iBeaconRanger
//
//  Created by Yuzhe Tian on 2018/5/12.
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth

extension RangerViewController: CLLocationManagerDelegate {
    private func notifiNoAuthorization() {
        let OKAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let alert: UIAlertController = UIAlertController(
            title: "No Authorization",
            message: "Please allow this app to use your location in Settings",
            preferredStyle: .alert
        )
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        let knownBeacons = beacons.filter{$0.proximity != CLProximity.unknown}
//        if knownBeacons.count > 0 {
//            currentClosetBeacon = knownBeacons[0] as CLBeacon
//            print(currentClosetBeacon!)
//            if currentClosetBeacon!.accuracy < iBeaconConfiguration.minimumAccuracy {
//                flag02 = false
//                if flag01 != true {
//                    lastClosetBeacon = currentClosetBeacon
//                    flag01 = true
//                    if view.window != nil {
//                        fetchJson()
//                    }
//                }
//                let printInfo = "You are now in area" + String(format: "%02d", currentClosetBeacon!.major.intValue)
//                areaLabel.text = printInfo
//                if lastClosetBeacon != currentClosetBeacon {
//                    lastClosetBeacon = currentClosetBeacon
//                    if view.window != nil {
//                        fetchJson()
//                    }
//                }
//            } else {
//                flag01 = false
//                areaLabel.text = "Welcome! You're not in range right now."
//                if flag02 != true {
//                    print("No Beacons detected.")
//                    lastClosetBeacon = nil
//                    flag02 = true
//                    jsonURL = nil
//                    if view.window != nil {
//                        fetchJson()
//                    }
//                }
//            }
//        } else {
//            flag01 = false
//            areaLabel.text = "Welcome! You're not in range right now."
//            if flag02 != true {
//                print("No Beacons detected.")
//                lastClosetBeacon = nil
//                flag02 = true
//                jsonURL = nil
//                if view.window != nil {
//                    fetchJson()
//                }
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.unknown}
        if knownBeacons.count > 0 {
            currentClosetBeacon = knownBeacons[0] as CLBeacon
            print(currentClosetBeacon!)
        }
        if knownBeacons.count > 0, knownBeacons[0].accuracy < iBeaconConfiguration.minimumAccuracy {
            flag02 = false // flag02 is true when not in range and false when in range
            if flag01 != true { // flag01 is true when lastClosetBeacon is the same as currentClosetBeacon
                lastClosetBeacon = currentClosetBeacon
                flag01 = true
            }
            let printInfo = "You are now in area" + String(format: "%02d", currentClosetBeacon!.major.intValue)
            areaLabel.text = printInfo
            if lastClosetBeacon != currentClosetBeacon {
                lastClosetBeacon = currentClosetBeacon
            }
//            if view.window != nil {
//                fetchJson()
//            }
        } else {
            flag01 = false
            areaLabel.text = "Welcome! You're not in range right now."
            if flag02 != true {
                print("No Beacons detected.")
                lastClosetBeacon = nil
                flag02 = true
                jsonURL = nil
            }
//            if view.window != nil {
//                fetchJson()
//            }
        }
        if view.window != nil {
            fetchJson()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .denied else {
            notifiNoAuthorization()
            return
        }
    }
}

extension RangerViewController: CBPeripheralManagerDelegate {
    private func notifiBluetoothOff() {
        let OKAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alert: UIAlertController = UIAlertController(
            title: "Bluetooth OFF",
            message: "Please turn on your Bluetooth!",
            preferredStyle: .alert
        )
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func notifiUnsupported() {
        let OKAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let alert: UIAlertController = UIAlertController(
            title: "Unsupported Bluetooth",
            message: "Sorry, but your device has an unsupported bluetooth hardware.",
            preferredStyle: .alert
        )
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        let state: CBManagerState = peripheralManager!.state
        
        if state == .poweredOff { // iOS 11.3.1 system bugs may cause this alert shows unexpectedly
            self.areaLabel.text = "Bluetooth Off"
            notifiBluetoothOff()
        }
        
        if state == .unsupported {
            self.areaLabel.text = "Unsupported Beacon"
            notifiUnsupported()
        }
    }
}
