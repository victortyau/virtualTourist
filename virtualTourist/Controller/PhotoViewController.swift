//
//  PhotoViewController.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/28/21.
//

import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController, UICollectionViewDataSource {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinate: CLLocationCoordinate2D!
    var dataController: DataController!
    var photos:[Pic] = []
    var apiPhotos:[Photo] = []
    var imageCells: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMapPin()
        fetchData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        collectionView.reloadData()
//    }
    
    @IBAction func createNewCollection(_ sender: Any) {
        
    }
    
    func fetchData() {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        let fetchRequest:NSFetchRequest<Pic> = Pic.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            photos = result
        }
        
        if photos.count == 0 {
            fetchDataApi()
        }
        
        print(apiPhotos.count)
    }
    
    func fetchDataApi() {
        ServiceClient.searchPhoto(lat: String(format: "%f",coordinate.latitude), long: String(format: "%f",coordinate.longitude)) {
            photos, error in
            
            DispatchQueue.main.async {
                self.apiPhotos = photos
                self.fillingOutImageCells()
            }
        }
    }
    
    func fillingOutImageCells(){
        for apiPhoto in apiPhotos {
            let url = URL(string: "https://farm\(apiPhoto.farm).staticflickr.com/\(apiPhoto.server)/\(apiPhoto.id)_\(apiPhoto.secret)_q.jpg")!
            let data = try? Data(contentsOf: url)
            self.imageCells.append(UIImage(data: data!)!)
        }
        collectionView.reloadData()
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

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid_cell", for: indexPath) as! GridCellController
        let photo = self.imageCells[(indexPath as NSIndexPath).row]
        cell.villainImageView.image = photo
        return cell
    }
}
