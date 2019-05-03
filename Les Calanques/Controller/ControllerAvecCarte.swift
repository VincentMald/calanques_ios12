//
//  ControllerAvecCarte.swift
//  Les Calanques
//
//  Created by Vincent Maldonado on 02/05/2019.
//  Copyright © 2019 Vincent Maldonado. All rights reserved.
//

import UIKit
import MapKit

class ControllerAvecCarte: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var calanques: [Calanque] = CallanqueCollection().all()
    var locationManager = CLLocationManager()
    var userPosition: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        addAnnotations()
        NotificationCenter.default.addObserver(self, selector: #selector(notifDetail), name: Notification.Name("detail"), object: nil)
        if calanques.count > 5 {
            let premiere = calanques[5].coordonnee
            setupMap(coordonnee: premiere)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let maPosition = locations.last {
                userPosition = maPosition
            }
        }
    }
    
    func setupMap(coordonnee: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        let region = MKCoordinateRegion(center: coordonnee, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func notifDetail(notification:Notification){
        if let calanque = notification.object as? Calanque {
            print("j'ai une calanque")
            toDetail(calanque: calanque)
        }
    }
    
    func toDetail(calanque: Calanque){
        performSegue(withIdentifier: "detail", sender: calanque)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            if let controller = segue.destination as? DetailController {
                controller.calanqueRecue = sender as? Calanque 
            }
        }
    }
    
    func addAnnotations(){
        for calanque in calanques {
            
            //Annotations de bases
            //let annotation = MKPointAnnotation()
            //annotation.coordinate = calanque.coordonnee
            //annotation.title = calanque.nom
            //mapView.addAnnotation(annotation)
            
            //Annotations custom
            let annotation = MonAnnotation(calanque)
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "reuseId"
        
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        
        if let anno = annotation as? MonAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            if annotationView == nil{
                //Override
                //annotationView = MonAnnotationView(annotation: anno, reuseIdentifier: reuseIdentifier)
                
                annotationView = MonAnnotationView(controller: self, annotation: anno, reuseIdentifier: reuseIdentifier)
                
                //annotationView = MKAnnotationView(annotation: anno, reuseIdentifier: reuseIdentifier)
                //annotationView?.image = UIImage(named: "placeholder")
                //annotationView?.canShowCallout = true
                return annotationView
            } else {
                return annotationView
            }
        }
        return nil
    }
    
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0: mapView.mapType = MKMapType.standard
        case 1: mapView.mapType = .satellite
        case 2: mapView.mapType = .hybrid
        default: break
        }
    }
    
    @IBAction func getPosition(_ sender: Any) {
        if userPosition != nil {
            setupMap(coordonnee: userPosition!.coordinate)
        }
    }
    
}
