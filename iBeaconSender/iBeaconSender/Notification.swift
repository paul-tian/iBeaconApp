//
//  File.swift
//  iBeaconSender
//
//  Created by Yuzhe Tian on 2018/5/12.
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import UIKit
import UserNotifications

class BackgroundNotification: UIResponder{
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "iOS Background Restriction"
        content.body = """
        Devices cannot act as iBeacon in background.
        Click here to reopen the app.
        """
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double.intervalTime(), repeats: false)
        let requestIdentifier = "PaulT.backgroundNotification"
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
    }
}


extension Double {
    static func intervalTime() -> Double {
        return  0.1
    }
}
