//
//  MapViewController.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/28/21.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    var EditPin: Bool = false
    var gestureStart: Bool = false
    var storedPins: [Pin] = []
    var dataController: DataController!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getDataController()
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            storedPins = result
            displayPins()
        }
    }
    
    func displayPins() {
        for pin:Pin in storedPins {
            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            addPinToMap(coordinate: coordinate)
        }
    }
    
    func getDataController() {
        dataController = DataController(modelName: "virtual_tourist")
        dataController.load()
    }
    
    func addAnnotationToCoreData(coordinate: CLLocationCoordinate2D) {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        try? dataController.viewContext.save()
        storedPins.append(pin)
    }
}

extension MapViewController:  MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let photoViewController = self.storyboard!.instantiateViewController(withIdentifier: "photoViewController") as! PhotoViewController
        photoViewController.coordinate = view.annotation?.coordinate
        photoViewController.dataController = dataController
        self.navigationController!.pushViewController(photoViewController, animated: true)
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
     
    @IBAction func responseLongTapAction(_ sender: Any){
        if gestureStart {
            let gestureRecognizer = sender as! UILongPressGestureRecognizer
            let gestureTouchLocation = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
            addPinToMap(coordinate: coordinate)
            addAnnotationToCoreData(coordinate: coordinate)
            gestureStart = false
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureStart = true
        return true
    }

    func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
