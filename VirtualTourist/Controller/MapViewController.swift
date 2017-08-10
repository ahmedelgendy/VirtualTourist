//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Ahmed Elgendy on 10/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController  {
    
    var isEditButtonEnabled: Bool! = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tapToRemoveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI()
    }
    
    
    @IBAction func edit(_ sender: UIButton) {
        isEditButtonEnabled = !isEditButtonEnabled
        
        if isEditButtonEnabled {
            editButton.title = "Done"
            removeLabel(hidden: false)
        }else{
            editButton.title = "Edit"
            removeLabel(hidden: true)
        }
        
    }
    
    @IBAction func action(gesture:UIGestureRecognizer){
        if !isEditButtonEnabled{
            addPin(gesture)
        }
    }
    
    func addPin(_ gesture:UIGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.began)
        {
            let touchPoint = gesture.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)
        }
    }
    
}


extension MapViewController: MKMapViewDelegate
{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MyIdentifier") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MyIdentifier")
            annotationView?.tintColor = UIColor.green
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if isEditButtonEnabled {
            guard let annotation = view.annotation else { return }
            self.mapView.removeAnnotation(annotation)
        }else{
            navToPhotoAlbum(coordinate: (view.annotation?.coordinate)!)
        }
    }
    
    func navToPhotoAlbum(coordinate: CLLocationCoordinate2D) {
        let photoAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Identifiers.PhotoAlbumViewController) as! PhotoAlbumViewController
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        photoAlbumVC.annotation = annotation
        navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    
}

extension MapViewController{
    func configureUI(){
        title = "Virtual Tourist"
        removeLabel(hidden: true)
    }
    func removeLabel(hidden:Bool){
        tapToRemoveLabel.isHidden = hidden
    }
}
