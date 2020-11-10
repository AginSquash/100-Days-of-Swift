//
//  ViewController.swift
//  Project22
//
//  Created by Vlad Vrublevsky on 11.11.2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("auth always new")
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("auth always new 1")
                    startScanning()
                }
            }
        }
    }
    
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
        //locationManager?.startRangingBeacons(in: beaconRegion)
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print(beacons)
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
                    case .unknown:
                        self.view.backgroundColor = UIColor.gray
                        self.distanceReading.text = "UNKNOWN"

                    case .far:
                        self.view.backgroundColor = UIColor.blue
                        self.distanceReading.text = "FAR"

                    case .near:
                        self.view.backgroundColor = UIColor.orange
                        self.distanceReading.text = "NEAR"

                    case .immediate:
                        self.view.backgroundColor = UIColor.red
                        self.distanceReading.text = "RIGHT HERE"
                        
                    @unknown default:
                        self.view.backgroundColor = .black
                        self.distanceReading.text = "WHOA!"
            }
        }
    }
}

