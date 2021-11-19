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
    
    var currentIndicator: UIActivityIndicatorView!
    var coordinate: CLLocationCoordinate2D!
    var photos:[Pic] = []
    var apiPhotos:[Photo] = []
    var pin: Pin!
    var pic: Pic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(currentIndicator)
        currentIndicator.bringSubviewToFront(self.view)
        currentIndicator.center = self.view.center
        collectionView.allowsMultipleSelection = true
        collectionButton.isEnabled = false
        showMapPin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
        
    @IBAction func createNewCollection(_ sender: Any) {
        removeAllPicture()
        fetchDataApi()
    }
    
    func fetchData() {
       
        fetchPin()
        
        fetchPics()
        
        collectionButton.isEnabled = true
    }
    
    func fetchPin() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude = %@ && longitude = %@ ", argumentArray: [coordinate.latitude, coordinate.longitude])
        fetchRequest.predicate = predicate
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            pin = result.first
        }
    }
    
    func fetchPics() {
        let fetchRequest1:NSFetchRequest<Pic> = Pic.fetchRequest()
        let predicate1 = NSPredicate(format: "pin == %@", pin)
        fetchRequest1.predicate = predicate1

        if let result = try? DataController.shared.viewContext.fetch(fetchRequest1) {
            photos = result
            
            if self.photos.count == 0 {
                fetchDataApi()
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func fetchDataApi() {
        ServiceClient.searchPhoto(lat: String(format: "%f",coordinate.latitude), long: String(format: "%f",coordinate.longitude),  page: String(format: "%d" ,Int.random(in: 1...20))) {
            photos, error in
            
            if photos.count > 0 {
                
                self.apiPhotos = photos
                var count = 0
                for apiPhoto in self.apiPhotos {
                    
                    let url = URL(string: "https://farm\(apiPhoto.farm).staticflickr.com/\(apiPhoto.server)/\(apiPhoto.id)_\(apiPhoto.secret)_q.jpg")!
                    
                    let pic = Pic(context: DataController.shared.viewContext)
                    pic.index = Int16(count)
                    pic.url = url
                    pic.pin = self.pin
                    self.photos.append(pic)
                    try? DataController.shared.viewContext.save()
                    count += 1
                    
                }
                
                self.collectionView.reloadData()
            }
        }
    }
    
    func removeAllPicture() {
        for photo in photos {
            DataController.shared.viewContext.delete(photo)
            try? DataController.shared.viewContext.save()
        }
        photos.removeAll()
        collectionView.reloadData()
    }
    
    func displayActivityIndicator(currentIndicator: UIActivityIndicatorView) {
        currentIndicator.isHidden = false
        currentIndicator.startAnimating()
    }
       
    func hideActivityIndicator(currentIndicator: UIActivityIndicatorView) {
        currentIndicator.stopAnimating()
        currentIndicator.isHidden = true
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid_cell", for: indexPath) as! GridCellController
        let photo = self.photos[(indexPath as NSIndexPath).row]
        cell.activityIndicator.startAnimating()
        
        if photo.data != nil {
            cell.villainImageView.image = UIImage(data: photo.data! as Data)
            cell.activityIndicator.stopAnimating()
        } else {
            if let url = photo.url {
                let data = try? Data(contentsOf: url)
                photo.data = data
                try? DataController.shared.viewContext.save()
                
                cell.villainImageView.image = UIImage(data: data! as Data)
                
                cell.activityIndicator.stopAnimating()
            } else {
                print("empty error")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        removePictureCell(at: indexPath)
        colorCell(cell: cell!, alpha: 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        colorCell(cell: cell!, alpha: 1.0)
    }
    
    func colorCell(cell: UICollectionViewCell, alpha: Double){
        DispatchQueue.main.async {
            cell.contentView.alpha = alpha
        }
    }
    
    func removePictureCell(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        DataController.shared.viewContext.delete(photo)
        try? DataController.shared.viewContext.save()
        collectionView.deleteItems(at: [indexPath])
        photos.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
