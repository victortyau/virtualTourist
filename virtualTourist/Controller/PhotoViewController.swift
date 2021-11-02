//
//  PhotoViewController.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/28/21.
//

import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var coordinate: CLLocationCoordinate2D!
    var dataController: DataController!
    var photos:[Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMapPin()
        fetchData()
    }
    
    @IBAction func createNewCollection(_ sender: Any) {
    }
    
    func fetchData() {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            photos = result
        }
        
        if photos.count == 0 {
            fetchDataApi()
        }
        
    }
    
    func fetchDataApi() {
        ServiceClient.searchPhoto(lat: String(format: "%f",coordinate.latitude), long: String(format: "%f",coordinate.longitude)) {
            photos, error in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension PhotoViewController:  MKMapViewDelegate {
    func showMapPin(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
}
