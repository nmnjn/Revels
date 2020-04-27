//
//  MapViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 04/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class MapViewController: UIViewController{
    
    let bottomSheetVC = BottomSheetViewController()
    let mapKitView: MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isRotateEnabled = true
        map.isPitchEnabled = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsPointsOfInterest = true
        map.showsBuildings = true
        return map
    }()
    
    let locationManager = CLLocationManager()
    var selectedAnnotation: MKAnnotation? = nil      //For deselcting selected one when close button is clicked
    var annotationArray = [MKPointAnnotation]()     //For removing rendered annotations
    var polyline = MKPolyline()
    var currentPolylineOverlay = [MKPolyline]()     //For removing rendered polyline
    var tagArray = [String:String]()                //For glyph image
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        
        setupView()
        checkLocationServices()
        mapKitView.delegate = self
        bottomSheetVC.setDelegate(vc: self)
        showInfoOptions()
    }
    
    @objc func showInfoOptions(){
        if !UserDefaults.standard.bool(forKey: "firstMap"){
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Welcome to the Maps Tab", message: "• Filter the locations according to your needs.\n\n• Tap on a location bubble to access the directions within the app.\n\n• Alternately, you can navigate to a location through the maps application by tapping on the navigation button.\n\n• Tap on a top-right location button twice to start compass view.", preferredStyle: .actionSheet)
                
                let okayAction = UIAlertAction(title: "Continue", style: .cancel, handler: { (_) in
                    
                })
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
        
        UserDefaults.standard.set(true, forKey: "firstMap")
        UserDefaults.standard.synchronize()
    }
    
    //MARK:ViewSetup
    func setupView(){
        mapKitView.layoutMargins.bottom = (view.frame.height * 0.1)
        view.addSubview(mapKitView)
        _ = mapKitView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        let leftMargin: CGFloat = 0
//        let topMargin: CGFloat = view.safeAreaInsets.top
//        let mapWidth: CGFloat = view.frame.size.width
//        let mapHeight: CGFloat = view.frame.size.height
//        mapKitView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        let buttonItem = MKUserTrackingButton(mapView: mapKitView)
//        buttonItem.frame = CGRect(origin: CGPoint(x:view.frame.width - 65, y: 80), size: CGSize(width: 40, height: 40))
        buttonItem.layer.cornerRadius = 7
        buttonItem.backgroundColor = UIColor.CustomColors.Black.background
        mapKitView.addSubview(buttonItem)
        _ = buttonItem.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 40, heightConstant: 40)
        mapKitView.showsCompass = false
        bottomSheetVC.attach(to: self)
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
        // location is turned off on user's phone
            showDisabledAlert()
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
                mapKitView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                centreViewOnUserLocation()
                break
            case .denied:
                showDisabledAlert()
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                showDisabledAlert()
                break
            case .authorizedAlways:
                mapKitView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                centreViewOnUserLocation()
                break
            @unknown default:
                locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func showDisabledAlert(){
        // open app settings
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Location Permission Denied", message: "Please allow location access to use the directions feature.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Dimiss", style: .destructive, handler: nil)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
                 UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertController.addAction(defaultAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }

    func centreViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
            mapKitView.setRegion(region, animated: true)
        }
    }
}

//Extensions
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        //Renders polyline
        if let roverlay = overlay as? MKPolyline{
            let renderer = MKPolylineRenderer(overlay: roverlay)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        //Renders map
        else{
           return MKOverlayRenderer(overlay: overlay)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        let markerAnnotation  = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
       
        
        if let name = annotation.title{
            if let imgURL = tagArray[name ?? ""]{
                if let url = URL(string: imgURL){
                    SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                        DispatchQueue.main.async {
                            markerAnnotation.glyphImage = image
                        }
                    }
                }
            }
        }
    
        markerAnnotation.glyphTintColor = .black
        markerAnnotation.animatesWhenAdded = true
        annotationView = markerAnnotation
        
        guard let annotView = annotationView else { return annotationView }

        annotView.displayPriority = .required
        annotView.canShowCallout = true
        annotView.annotation = annotation

        return annotView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        guard let title = annotation.title else { return }
        selectedAnnotation = annotation
        let latitude = annotation.coordinate.latitude - CLLocationDegrees(0.001)
        let longitude = annotation.coordinate.longitude
        let crd: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: crd, span: span)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 0.5)
        bottomSheetVC.loadLocationInfoView(title: title ?? "")
        if currentPolylineOverlay.count != 0{
           mapKitView.removeOverlays(currentPolylineOverlay)
           currentPolylineOverlay.removeAll()
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        removeDirection()
        bottomSheetVC.hideLocationInfoView()
    }
}

//MARK:handlemapDelegate

protocol HandleMapDelegate
{
    func zoomToPlace(name:String, location:CLLocationCoordinate2D)
    func addAnnotation(poi: poi)
    func removeAnnotations()
    func showDirection(to: CLLocationCoordinate2D)
    func removeDirection()
    func showNavigation(to:String, coordinates:CLLocationCoordinate2D)
    func setupTagDictionary(poi: poi)
}

extension MapViewController: HandleMapDelegate{
    
    func zoomToPlace(name:String, location: CLLocationCoordinate2D) {
        //Remove current overlays and annotation
        if currentPolylineOverlay.count != 0
               {
                   mapKitView.removeOverlays(currentPolylineOverlay)
                   currentPolylineOverlay.removeAll()
               }

        let latitude = location.latitude - CLLocationDegrees(0.001)
        let longitude = location.longitude
        let crd:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: crd, span: span)

        var annotation:MKAnnotation?
        for i in annotationArray
        {
            if i.title == name
            {
                annotation = i
            }
        }
        
        selectedAnnotation = annotation
        mapKitView.selectAnnotation(annotation!, animated: true)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 1 )
    }
        
    func removeAnnotations() {
        mapKitView.removeAnnotations(annotationArray)
        annotationArray.removeAll()
    }
    
    func removeExistingOverlay(){
        if currentPolylineOverlay.count != 0{
              mapKitView.removeOverlays(currentPolylineOverlay)
              currentPolylineOverlay.removeAll()
        }
    }
    
    func showDirection(to:CLLocationCoordinate2D) {
        removeExistingOverlay()
        guard let sC = (locationManager.location?.coordinate) else {
            showDisabledAlert()
            return
        }
        
        let dC = to
        let sP = MKPlacemark(coordinate: sC)
        let dP = MKPlacemark(coordinate: dC)

        let sI = MKMapItem(placemark: sP)
        let dI = MKMapItem(placemark: dP)

        let directionRequest = MKDirections.Request()
        directionRequest.source = sI
        directionRequest.destination = dI
        directionRequest.transportType = .walking

        let direction = MKDirections(request: directionRequest)

        direction.calculate(completionHandler: {
            res,err in
            guard let res = res else {
                if let err = err {
                    print(err)
                }
                return
        }

        let route  = res.routes[0]
        self.polyline = route.polyline
        self.currentPolylineOverlay.append(self.polyline)
        self.mapKitView.addOverlay(self.polyline, level: .aboveLabels)
        let rekt = route.polyline.boundingMapRect
        self.mapKitView.setRegion(MKCoordinateRegion(rekt), animated: true)
        })
    }
    
    func addAnnotation(poi: poi) {
          let annotation = MKPointAnnotation()
        annotation.title = poi.locationName
        annotation.coordinate = poi.locationCoordinates
          annotationArray.append(annotation)
          mapKitView.addAnnotation(annotation)
          let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 13.347488, longitude: 74.793315), latitudinalMeters: 1000, longitudinalMeters: 1000)
          mapKitView.setRegion(region, animated: true)
      }

    func removeDirection() {
        if currentPolylineOverlay.count != 0{
            mapKitView.removeOverlays(currentPolylineOverlay)
            currentPolylineOverlay.removeAll()
        }
        mapKitView.deselectAnnotation(selectedAnnotation, animated: true)
    }
    
    func showNavigation(to:String,coordinates:CLLocationCoordinate2D) {
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = to
        mapItem.openInMaps(launchOptions: options)
    }
    
    func setupTagDictionary(poi: poi) {
        tagArray[poi.locationName] = poi.tagImageUrl
    }
}


extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
            }, completion: nil)
    }
}
