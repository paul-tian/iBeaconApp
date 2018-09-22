//
//  ViewController.swift
//  iBeaconSender
//
//  Created by Yuzhe Tian on 2018/5/12.
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import UserNotifications

class BroadcastViewController: UIViewController, UIPageViewControllerDelegate {
    
    private var broadcasting: Bool = false
    private var beacon: CLBeaconRegion?
    private var peripheralManager: CBPeripheralManager?
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var uuidLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Request permission to display alerts and play sounds.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if granted {
                // Enable or disable features based on authorization.
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.iOSWhiteColor()
        let UUID: UUID = iBeaconConfiguration.uuid
        let major: CLBeaconMajorValue = CLBeaconMajorValue(iBeaconConfiguration.major)
        let minor: CLBeaconMinorValue = CLBeaconMinorValue(iBeaconConfiguration.minor)
        let identifier = iBeaconConfiguration.identifier
        self.beacon = CLBeaconRegion(
            proximityUUID: UUID,
            major: major,
            minor: minor,
            identifier: identifier
        )
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        uuidLabel.text = "major:\(self.beacon!.major!)" + " " + "minor:\(self.beacon!.minor!)"
    }
    
    deinit {
        self.beacon = nil
        self.peripheralManager = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Status Bar -

extension BroadcastViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.broadcasting {
            return .lightContent
        }
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

//MARK: - Actions -

extension BroadcastViewController {
    @IBAction private func broadcastBeacon(sender: UIButton) -> Void {
        let state: CBManagerState = self.peripheralManager!.state
        
        if (state == .unsupported) {
            let CloseAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            
            let alert: UIAlertController = UIAlertController(
                title: "Unsupported Hardware",
                message: "Sorry, this devices is not supported!",
                preferredStyle: .alert
            )
            
            alert.addAction(CloseAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if (state == .poweredOff && !self.broadcasting) { // iOS 11.3.1 system bugs may cause this alert shows unexpectedly
            let OKAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            let alert: UIAlertController = UIAlertController(
                title: "Bluetooth OFF",
                message: "Please power on your Bluetooth!",
                preferredStyle: .alert
            )
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let titleFromStatus: () -> String = {
            let title: String = (self.broadcasting) ? "Start" : "Stop"
            return title + " Broadcast"
        }
        
        let buttonTitleColor: UIColor = (self.broadcasting) ? UIColor.iOSBlueColor() : UIColor.iOSWhiteColor()
        
        sender.setTitle(titleFromStatus(), for: UIControl.State.normal)
        sender.setTitleColor(buttonTitleColor, for: UIControl.State.normal)
        
        let labelTextFromStatus: () -> String = {
            let text: String = (self.broadcasting) ? "Not Broadcast" : "Broadcasting..."
            return text
        }
        
        self.statusLabel.text = labelTextFromStatus()
        
        let animations: () -> Void = {
            self.broadcasting = !self.broadcasting
            let backgroundColor: UIColor = (self.broadcasting) ? UIColor.iOSBlueColor() : UIColor.iOSWhiteColor()
            self.view.backgroundColor = backgroundColor
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        let completion: (Bool) -> Void = {
            finish in
            self.advertising(start: self.broadcasting)
        }
        
        UIView.animate(withDuration: 0.5, animations: animations, completion: completion)
    }
    
    // MARK: - Broadcast Beacon
    
    @objc func advertising(start: Bool) -> Void {
        if self.peripheralManager == nil {
            return
        }
        
        if (!start) {
            self.peripheralManager!.stopAdvertising()
            return
        }
        
        let state: CBManagerState = self.peripheralManager!.state
        
        if (state == .poweredOn) {
            let UUID:UUID = (self.beacon?.proximityUUID)!
            let serviceUUIDs: Array<CBUUID> = [CBUUID(nsuuid: UUID)]
            
            var peripheralData: Dictionary<String, Any> =
                self.beacon!.peripheralData(withMeasuredPower: nil)
                    as NSDictionary as! Dictionary<String, Any>
            peripheralData[CBAdvertisementDataLocalNameKey] = "iBeaconSender"
            peripheralData[CBAdvertisementDataServiceUUIDsKey] = serviceUUIDs
            
            self.peripheralManager!.startAdvertising(peripheralData)
            
            //************************************************************************

            
            
            //************************************************************************
        }
    }
}

// MARK: - CBPeripheralManager Delegate -

extension BroadcastViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        let state: CBManagerState = peripheralManager!.state

        if state == .poweredOff {
            self.statusLabel.text = "Bluetooth Off"
//
//            if self.broadcasting {
//                self.broadcastBeacon(sender: self.triggerButton)
//            }
        }

        if state == .unsupported {
            self.statusLabel.text = "Unsupported Beacon"
        }

        if state == .poweredOn {
            self.statusLabel.text = "Not Broadcast"
        }
    }
}

