//
//  ViewController.swift
//  Project16
//
//  Created by Vlad Vrublevsky on 02.10.2020.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapViewAlert))
    }

    @objc func changeMapViewAlert() {
        let ac = UIAlertController(title: "Selecte view type", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: changeMapView))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeMapView))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeMapView))
        
        present(ac, animated: true, completion: nil)
    }
    
    func changeMapView(_ ac: UIAlertAction) {
        switch ac.title {
        case "Satellite":
            self.mapView.mapType = .satellite
        case "Hybrid":
            self.mapView.mapType = .hybrid
        case "Standard":
            self.mapView.mapType = .standard
        default:
            self.mapView.mapType = .standard
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        annotationView?.pinTintColor = .cyan
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: "\(placeInfo)\n Open in new page?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                if let vc = self.storyboard?.instantiateViewController(identifier: "WebView") as? WebVew {
                    vc.url = URL(string: "https://developer.apple.com/documentation/webkit/wkwebview/")!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
              } ))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
}

