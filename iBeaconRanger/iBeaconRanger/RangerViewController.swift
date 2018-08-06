//
//  RangerViewController.swift
//  iBeaconRanger
//
//  Created by Paul Tian
//  Copyright © 2018年 Paul Tian. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import UserNotifications

class RangerViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(
        proximityUUID: iBeaconConfiguration.uuid,
        identifier: iBeaconConfiguration.identifier
    )
    
    var lastClosetBeacon: CLBeacon?
    var currentClosetBeacon: CLBeacon?
    
    var peripheralManager: CBPeripheralManager?

    var flag01 = false
    var flag02 = false
    var jsonURL: URL?
    
    private var items = [Item]()
    
    struct regionCount: Codable {
        var region: String
        var count: Int
    }
    
    var statisticInfo = [regionCount]()
    
    func fetchJson() {        
        if lastClosetBeacon != nil, lastClosetBeacon!.accuracy < iBeaconConfiguration.minimumAccuracy {
            let major = lastClosetBeacon!.major.intValue
            switch major {
            case 1:
                jsonURL = URL(string: "http://www.example.com/path/to/area01.json")
            case 2:
                jsonURL = URL(string: "http://www.example.com/path/to/area02.json")
            default:
                jsonURL = URL(string: "http://www.example.com/path/to/default.json")
            }
        } else {
            jsonURL = URL(string: "http://www.example.com/path/to/default.json")
        }
        
        guard let downloadURL = jsonURL else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Something wrong while downloading !")
                return
            }
            do {
                let decoder = JSONDecoder()
                let downloadedItems = try decoder.decode(Items.self, from: data)
                self.items = downloadedItems.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Something wrong after downloaded !")
            }
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.iOSWhiteColor()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
//        for i in 0...2 {
//            let newRegion = regionCount(region: "\(i)", count: 0)
//            statisticInfo.append(newRegion)
//        } // this func is used to reset region data when developing
        
        // use to check if save file already exists
        if Storage.fileExists("statistic.json", in: .documents) {
            let savedStatisticInfo = Storage.retrieve("statistic.json", from: .documents, as: [regionCount].self)
            print(savedStatisticInfo)
            
            // restore from saved data
            for i in 0...iBeaconConfiguration.maximumRegionCount {
                let savedRegion = regionCount(region: "\(i)", count: savedStatisticInfo[i].count)
                statisticInfo.append(savedRegion)
            }
            
        } else { // else ready for new region
            for i in 0...iBeaconConfiguration.maximumRegionCount {
                let newRegion = regionCount(region: "\(i)", count: 0)
                statisticInfo.append(newRegion)
            }
        }
        
    }
    
    deinit {
        self.peripheralManager = nil
        jsonURL = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        // Request permission to display alerts and play sounds.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if granted {
                // Enable or disable features based on authorization.
                print("Notification Authorization Granted.")
            }
        }
        
         tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
            as? ItemCell else { return UITableViewCell() }
        
        cell.itemLabel.text = "Name:" + items[indexPath.row].name
        cell.priceLabel.text = "Price:" + items[indexPath.row].price
        
        if let imageURL = URL(string: items[indexPath.row].image) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.itemImage.image = image
                    }
                }
            }
        }
        return cell
    }
    
    
}

