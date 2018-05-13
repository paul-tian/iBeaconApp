//
//  BlueTooth.swift
//  iBeaconRanger
//
//  Created by Yuzhe Tian on 2018/5/12.
//  Copyright © 2018年 Paul Tian. All rights reserved.
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
//        if state == .poweredOff {
//            self.areaLabel.text = "Bluetooth Off"
//            notifiBluetoothOff()
//        }
        if state == .unsupported {
            self.areaLabel.text = "Unsupported Beacon"
            notifiUnsupported()
        }
    }
}
