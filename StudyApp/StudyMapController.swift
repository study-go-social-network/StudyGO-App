//
//  StudyMapController.swift
//  Let's Study
//
//  Created by Alexander on 07/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
var userLocationMonitor:CLLocationManager?
var events:[EventObject] = []
class StudyMapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    //    struct StudyEvent{
    //        var userId:String
    //        var title:String
    //        var dueTime:String
    //        var lat:String
    //        var long:String
    //
    //        var userImage:String
    //    }
    
    // var currentUser = User(userName: "Alex", userId: "20001", userImageSrc: "image01")
    
    let myMockEvent = StudyEvent(userId: "Alex", title: "Comp 208 meeting", dueTime: "15:40:00",lat: "53.406566" ,long: "-2.966531", userImage: "image01", holder:User(userName: "Alex", userId: "20001", userImageSrc: "image01"), capacity: 4, joiners: [])
    
    var studyEvents:[StudyEvent] = []
    var annotations:[MKAnnotation] = []
    
    var locationManager = CLLocationManager()
    var timer:Timer!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvent()
        setupUserLocation()
        setMapRegion()
        // loadAnnotation()
        loadEventToMap()
        eventListener()
        instructionView.isHidden = true
        print("salfjadslkfjaslfjslfsljsdkfjsfslkjsldkfjs")
        print(userStatus)
        if userStatus == UserState.onEvent {
            print("salfjadslkfjaslfjslfsljsdkfjsfslkjsldkfjs")
            performSegue(withIdentifier: "joinStudy", sender: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    func setupUserLocation(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10.0
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
        userLocationMonitor = locationManager
    }
    func setMapRegion(){
        if locationManager.location != nil{
            let coordinate = locationManager.location?.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            map.setRegion(region,animated: true)
            
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation){
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "events")
        if annotationView == nil {
            
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "events")
            // annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "events")
            
            annotationView!.canShowCallout = true
        }else{
            annotationView!.annotation = annotation
            annotationView!.canShowCallout = true
            
            
            
        }
        var currentEvent:EventObject!
        print(annotation.title)
        for event in events{
            if annotation.subtitle == event.eventid!.description {
                currentEvent = event
            }
        }
        annotationView?.detailCalloutAccessoryView = DetailCallout(event: currentEvent)
        annotationView!.detailCalloutAccessoryView?.translatesAutoresizingMaskIntoConstraints = false
        //  annotationView!.detailCalloutAccessoryView = annotationView!.leftCalloutAccessoryView
        //  annotationView!.detailCalloutAccessoryView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([(annotationView!.detailCalloutAccessoryView?.widthAnchor.constraint(equalToConstant: 200))!,
                                     (annotationView?.detailCalloutAccessoryView?.heightAnchor.constraint(equalToConstant: 300))!])
        //annotationView!.rightCalloutAccessoryView?.addSubview(UIButton(type: UIButton.ButtonType.system))
        
        
        //        annotationView?.image = UIImage(named: "pin")
        //        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        //        annotationView?.transform = transform
        return annotationView
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension StudyMapController{
    func loadEvent(){
        self.studyEvents.append(myMockEvent)
    }
    func loadAnnotation(){
        for event in studyEvents{
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: Double(event.lat)!, longitude: Double(event.long)!)
            annotation.coordinate = coordinate
            annotation.title = event.title
            
            map.addAnnotation(annotation)
            
        }
    }
    func loadEventToMap(){
        //let connector = DBConnector()
        events = connector.loadEvent()
        for event in events{
            
            if connector.checkValidEvent(eventId: event.eventid!){
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: Double(event.slat)!, longitude: Double(event.slng)!)
                annotation.coordinate = coordinate
                annotation.title = event.title
                annotation.subtitle = event.eventid?.description
                map.addAnnotation(annotation)
                
                annotations.append(annotation)
            }
           
            
        }
    }
    func removeAllAnnotation(){
        map.removeAnnotations(annotations)
        annotations.removeAll()
    }
    
}
extension UIImage{
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        
        return image
    }
    
}
extension StudyMapController{
    //    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    //        if eventToJoin != nil{
    //            let distance = userLocation.location?.distance(from: CLLocation(latitude: Double(eventToJoin!.slat)!, longitude: Double(eventToJoin!.slng)!))
    //            let integer = Int((distance?.description)!)!
    //            distanceLabel.text  = String(integer)
    //        }
    //
    //    }
    func eventListener(){
        let eventTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.handleEventListener), userInfo: nil, repeats: true)
        RunLoop.main.add(eventTimer, forMode:RunLoop.Mode.common)
    }
    @objc private func handleEventListener (){
        if connector.loadEvent().count != events.count {
            print("UUIOOIJK")
            removeAllAnnotation()
            loadEventToMap()
        }
//        removeAllAnnotation()
//        loadEventToMap()
        
        if userStatus == UserState.accepted{
            instructionView.isHidden = false
            
            startInstruction()
        }else{
            instructionView.isHidden = true
        }
    }
    func startInstruction(){
        addCycleTimer()
    }
    fileprivate func addCycleTimer() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoop.Mode.common)
    }
    @objc private func handleTimer (){
        
        if locationManager.location != nil {
            if eventToJoin != nil{
                let distance = locationManager.location?.distance(from: CLLocation(latitude: Double(eventToJoin!.slat)!, longitude: Double(eventToJoin!.slng)!))
                let distanceMeter = Int(distance!)
                
                distanceLabel.text  = distanceMeter.description+" m"
                
                // start the study event
                if distanceMeter < 50 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    connector.addPartnerStartTimeByEventId(eventid: eventToJoin!.eventid!,pstart: dateFormatter.string(from: Date(timeIntervalSinceNow: 1)))
                    eventInprogress = eventToJoin
                    eventToJoin = nil
                    userStatus = UserState.onEvent
                    Saver.saveInformation()
                    timer.invalidate()
                    performSegue(withIdentifier: "joinStudy", sender: nil)
                    
                }
            }
            
            
        }
        //        let distance = locationManager.location?.distance(from: CLLocation(latitude: Double(eventToJoin!.slat)!, longitude: Double(eventToJoin!.slng)!))
        //        distanceLabel.text  = distance?.description
        //        print(distance)
        
        
        //        let currentDate = Date(timeIntervalSinceNow: 1)
        //
        //        //        let currentDate = Date()
        //
        //        let dateFormatter = DateFormatter()
        //
        //
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        //"HH:mm:ss"
        //        let currentTime = Date(timeInterval: dateFormatter.date(from: (eventInprogress?.dueTime)!)!.timeIntervalSinceNow, since: dateFormatter.date(from: (eventInprogress?.dueTime)!)!)
        //
        //        let now = dateFormatter.string(from: currentDate)
        //        let date1 = dateFormatter.date(from: now)!
        //        let date2 = dateFormatter.date(from: (eventInprogress?.dueTime)!)!
        //        let diff = Int(date2.timeIntervalSince(date1))
        //        let hours = diff/3600
        //        let minutes = (diff-hours*3600)/60
        //        let seconds = diff-hours*3600-minutes*60
        //        print(dateFormatter.string(from: currentDate))
        //        print(diff/3600)
        //
        
        
        //        if hours <= 0 {
        //            if minutes <= 0 && seconds <= 0 {
        //
        //
        //                timer?.invalidate()
        //                userStatus = UserState.free
        //                self.dismiss(animated: true, completion: nil)
        //
        //            }
        //        }
    }
}
