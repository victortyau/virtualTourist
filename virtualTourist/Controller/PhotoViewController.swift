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
            //self.apiPhotos = photos
            DispatchQueue.main.async {
                self.apiPhotos = photos
                for apiPhoto in self.apiPhotos {
                    //print(apiPhoto.id)
                    let url = URL(string: "https://farm\(apiPhoto.farm).staticflickr.com/\(apiPhoto.server)/\(apiPhoto.id)_\(apiPhoto.secret)_q.jpg")!
                    //print(url)
                    let data = try? Data(contentsOf: url)
                    print(data)
                    self.imageCells.append(UIImage(data: data!)!)
                }
                print(self.imageCells[0])
                self.fillingOutImageCells()
                self.collectionView.reloadData()
                self.fillingOutImageCells()
            }
        }
    }
    
    func fillingOutImageCells(){
       
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
        print(photo)
        cell.villainImageView.image = photo
        return cell
    }
}
