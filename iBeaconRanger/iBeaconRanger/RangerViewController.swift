//
//  RangerViewController.swift
//  iBeaconRanger
//

import UIKit
import CoreLocation
import CoreBluetooth

class RangerViewController: UIViewController, UITableViewDataSource {
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(
        proximityUUID: iBeaconConfiguration.uuid,
        identifier: iBeaconConfiguration.identifier
    )
    var peripheralManager: CBPeripheralManager?
    var currentClosetBeacon: CLBeacon?
    var lastClosetBeacon: CLBeacon?
    var flag01 = false
    var flag02 = false
    private var items = [Item]()
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var jsonURL: URL?
    
    func fetchJson() {
        if lastClosetBeacon != nil {
            let major = currentClosetBeacon!.major.intValue
            switch major {
            case 1:
                jsonURL = URL(string: "http://www.example.com/area01.json")
            case 2:
                jsonURL = URL(string: "http://www.example.com/area02.json")
            case 3:
                jsonURL = URL(string: "http://www.example.com/area03.json")
            default:
                jsonURL = URL(string: "http://www.example.com/default.json")
            }
        } else {
            jsonURL = URL(string: "http://www.example.com/default.json")
        }
        
        guard let downloadURL = jsonURL else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something wrong !!!")
                return
            }
            do {
                let decoder = JSONDecoder()
                let downloadedItems = try decoder.decode(Items.self, from: data)
                self.items = downloadedItems.items
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch {
                print("something wrong after downloaded !!!")
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
    }
    
    deinit {
        self.peripheralManager = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchJson()
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
