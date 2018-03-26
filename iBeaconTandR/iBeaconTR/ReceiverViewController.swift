//
//  ReceiverViewController.swift
//  iBeaconTR
//
// list need to update manually and RSSI woun't change when use phone as beacon
//

import UIKit
import CoreLocation
import CoreBluetooth

class ReceiverViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl?
    
    private var beacons: [CLBeacon] = []
    private var location: CLLocationManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshControl!.beginRefreshing()
        self.refreshBeacons(sender: self.refreshControl!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.refreshControl!.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.iOS7BlueColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.location = CLLocationManager()
        self.location!.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            self.location!.requestAlwaysAuthorization()
        }
        
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.iOS7BlueColor()]
        let attributedTitle = NSAttributedString(string: "Receiving Beacon", attributes: attributes)

        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(ReceiverViewController.refreshBeacons), for: UIControlEvents.valueChanged)
        
        self.refreshControl = refreshControl
        self.tableView.addSubview(refreshControl)
    }
    
    deinit {
        self.location = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Status Bar -

extension ReceiverViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
    
// MARK: - Actions -

extension ReceiverViewController {
    @objc 
    private func refreshBeacons(sender: UIRefreshControl) -> Void {
        // This uuid must same as broadcaster.
        let UUID: UUID = iBeaconConfiguration.uuid
        
        let beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID, identifier: "PaulT")
        
        self.location!.startMonitoring(for: beaconRegion)
    }
    
    //MARK: - Other Method
    
    private func notifiBluetoothOff() {
        let OKAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let alert: UIAlertController = UIAlertController(title: "Bluetooth OFF", message: "Please power on your Bluetooth!", preferredStyle: .alert)
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - UITableView DataSource Methods

extension ReceiverViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "CellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: CellIdentifier)
        }
        
        let row: Int = indexPath.row
        let beacon: CLBeacon = self.beacons[row]
        let detailText: String = "Major:" + "\(beacon.major)" + "\tMinor:" + "\(beacon.minor)" + "\tRSSI:" + "\(beacon.rssi)"
        let beaconUUID: String = beacon.proximityUUID.uuidString
        
        cell?.textLabel?.text = detailText
        cell?.detailTextLabel?.text = beaconUUID
        
        return cell!
    }
    
    //MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }    
}
 
//MARK: - CLocationManager Delegate Methods
    
extension ReceiverViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways else {
            print("**** User not authorized ****")
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            return
        }
        
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.beacons = beacons 
        
        //crash Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
        print("\(self.beacons.first!)")
        
        manager.stopRangingBeacons(in: region)
        self.refreshControl?.endRefreshing()
        
        self.tableView.reloadData()
    }
}
