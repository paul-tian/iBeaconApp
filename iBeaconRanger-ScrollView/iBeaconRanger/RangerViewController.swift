//
//  RangerViewController.swift
//  iBeaconRanger
//
//  Created by Yuzhe Tian on 2018/5/12.
//  Copyright © 2018年 Paul Tian. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class RangerViewController: UIViewController, UIScrollViewDelegate {
    
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
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageURL: URL? {
        didSet {
            imageView.image = nil
        }
    }
    
    func fetchImage() {
        if imageURL == nil {
            imageURL = Bundle.main.url(forResource: "default", withExtension: "jpg")
            // https URL for Internet test according to iOS restriction
            //imageURL = URL(string: "https://backup.hdslb.com/bfs/mainfront/confirm.png")
        }
        
        if lastClosetBeacon != nil {
            let major = currentClosetBeacon!.major.intValue
            switch major {
            case 1: //imageURL = Bundle.main.url(forResource: "area01", withExtension: "jpg")
                imageURL = URL(string: "http://47.101.37.141:8080/ibeacon/area01.jpg")
            case 2: //imageURL = Bundle.main.url(forResource: "area02", withExtension: "jpg")
                imageURL = URL(string: "http://47.101.37.141:8080/ibeacon/area02.jpg")
            case 3: //imageURL = Bundle.main.url(forResource: "area03", withExtension: "jpg")
                imageURL = URL(string: "http://47.101.37.141:8080/ibeacon/area03.jpg")
            default: imageURL = Bundle.main.url(forResource: "default", withExtension: "jpg")
            }
        }
        if let url = imageURL {
            do {
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents {
                    imageView.image = UIImage(data: imageData)
                }
            }
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
