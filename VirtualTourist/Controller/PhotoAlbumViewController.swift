//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Ahmed Elgendy on 10/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var annotation: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addNotation()
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.PhotoAlbumCell, for: indexPath) as! PhotoAlbumCollectionCell
        
        cell.imageView.image = UIImage(named: "logo")
        
        return cell
    }
    
}

extension PhotoAlbumViewController: MKMapViewDelegate{
    func addNotation(){
        mapView.addAnnotation(annotation)
        // zoom and move to coordinates
        mapView.centerCoordinate = annotation.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 200000, 200000)
        mapView.region = region
    }
}

// MARK: UI Configuration

extension PhotoAlbumViewController{
    
    func setupUI(){
        setFlowLayout()
        
        // setting collection view delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // diable user interaction
        mapView.isUserInteractionEnabled = false
    }
    
    func setFlowLayout(){
        let space:CGFloat = 3.0
        let dims = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dims, height: dims)
    }
}
