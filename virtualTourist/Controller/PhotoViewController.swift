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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMapPin()
    }
    
    @IBAction func createNewCollection(_ sender: Any) {
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

//extension PhotoViewController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoAlbumCollectionViewCell
//        cell.initWithPhoto(savedImages[indexPath.row])
//        return cell
//    }
//    
//}
