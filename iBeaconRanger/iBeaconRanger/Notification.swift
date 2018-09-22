//
//  Notification.swift
//  iBeaconRanger
//
//  Created by Yuzhe Tian on 2018/6/7.
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import UIKit
import UserNotifications

class BackgroundNotification: UIResponder{
    
    func sendNotification() {
        struct regionCount: Codable {
            var region: String
            var count: Int
        }
        var statisticInfo = [regionCount]()
        var flag: Bool = false
        let content = UNMutableNotificationContent()
        
        //content.sound = UNNotificationSound.`default`()
        //content.badge = 1
        content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("bubble.wav"))
        content.title = "Statistic Status"
        

        let savedStatisticInfo = Storage.retrieve("statistic.json", from: .documents, as: [regionCount].self)
        for i in 0...iBeaconConfiguration.maximumRegionCount {
            let savedRegion = regionCount(region: "\(i)", count: savedStatisticInfo[i].count)
            if savedRegion.count > 0 {
                flag = true
            }
            statisticInfo.append(savedRegion)
        }
        
        if flag {
            content.body = """
            area01 for \(statisticInfo[1].count) times,
            area02 for \(statisticInfo[2].count) times,
            others for \(statisticInfo[0].count) times.
            """
            
        } else {
        content.body = """
        You have not entered any region yet.
        Please go safari around !
        """
        }
        
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



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
