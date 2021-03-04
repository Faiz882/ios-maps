//
//  ViewController.swift
//  MapList
//
//  Created by Usama Ali on 28/01/2021.
//

import UIKit
import MapKit
import AVKit
import AVFoundation



class ViewController: UIViewController, UISearchBarDelegate
{
    var selectedLoc : CLLocationCoordinate2D?
    @IBOutlet weak var customeMapView: MKMapView!
    @IBOutlet weak var searchBtnUI: UIButton!
    let addCredit: ImageViewController = ImageViewController(nibName: "ImageViewController", bundle: nil)
    let locationManager = CLLocationManager()
//    var mapView: GMSMapView?
    
    var placesArray : [Places] = []
    var resultsArray: [Places] = []
    
    var avPlayer : AVPlayer?
    let playerViewController = AVPlayerViewController()
    var dismissBtn = UIButton()
    var playPauseBtn = UIButton()
    var shareBtn = UIButton()
    
    
    let loc1 : Places = Places.init(Title: "Johar Town", subTitle: "Lahore", Location: CLLocationCoordinate2D.init(latitude: 31.4697, longitude: 74.2728), image: UIImage(named: "foodd")!, video: "", isImage: true)
    let loc2 : Places = Places.init(Title: "Wapda Town", subTitle: "Lahore", Location: CLLocationCoordinate2D.init(latitude: 32.4697, longitude: 75.2728), image: UIImage(named: "foodd")!, video: "", isImage: false)
    let loc3 : Places = Places.init(Title: "DHA Phase 6", subTitle: "Lahore", Location: CLLocationCoordinate2D.init(latitude: 33.4697, longitude: 76.2728), image: UIImage(named: "foodd")!, video: "", isImage: true)
    let loc4 : Places = Places.init(Title: "Paragon City", subTitle: "Lahore", Location: CLLocationCoordinate2D.init(latitude: 34.4697, longitude: 77.2728), image: UIImage(named: "foodd")!, video: "", isImage: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customeMapView.delegate = self
        
        
        placesArray.append(loc1)
        placesArray.append(loc2)
        placesArray.append(loc3)
        placesArray.append(loc4)
        
        for index in 0...placesArray.count-1 {
            let annotation = MKPointAnnotation()  // <-- new instance here
            annotation.coordinate = placesArray[index].Location
            annotation.title = placesArray[index].Title
            customeMapView.addAnnotation(annotation)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        // 1- Init bottomSheetVC
        let bottomSheetVC = ScrollableBottomSheetViewController()

        // 2- Add bottomSheetVC as a child view
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: height/2, width: width, height: height)
    }
    
//    @IBAction func searchLocationBtn(_ sender: Any)
//    {
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.present(searchController, animated: true, completion: nil)
//    }
    
    
    @objc func updateLocation(notification:NSNotification){
        
        if let data = notification.userInfo?["data"] as? DataModel {
          // do something with your image
            
            //openAddCreditView(modal: data)
            
            locateWithLongitude(loc1.Location.longitude, andLatitude: loc1.Location.latitude, andTitle: loc1.Title)
          }
        
    }
    
    func openAddCreditView(modal:Places,index : Int){
        // self.backView.isHidden = false
        if modal.isImage {
        addCredit.data = modal
        self.addChild(addCredit)
        self.view.addSubview(addCredit.view)
        addCredit.didMove(toParent: self)
        addCredit.view.frame = CGRect(x: 12.5, y: view.frame.height/2-100, width: 350, height: 220)
        }
        else {
            playVideos(index : index)
        }
    }
    
    
//    func playVideo(){
//        let videoURL = URL(string:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
//        let player = AVPlayer(url: videoURL!)
//        player.rate = 1
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRect(x: 12.5, y: view.frame.height/2-100, width: 350, height: 220)
//        self.view.layer.addSublayer(playerLayer)
////        player.play()
//    }
    
    
    func playVideos(index : Int){
        let videoPath = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        guard let url = URL(string: videoPath) else { return }
        let player = AVPlayer(url: url)
    
        
        player.rate = 1 //auto play
        let playerFrame = CGRect(x: 12.5, y: view.frame.height/2-100, width: 350, height: 220)
      
        playerViewController.player = player
        playerViewController.view.frame = playerFrame
        playPauseBtn = UIButton(frame: CGRect(x: 12.5, y: view.frame.height/2-100, width: 350, height: 220))
        playPauseBtn.addTarget(self, action: #selector(playPauseAction(sender:)), for: .touchDown)
        dismissBtn = UIButton(frame: CGRect(x: 12.5, y: view.frame.height/2-100, width: 50, height: 50))
        dismissBtn.setImage(UIImage(named: "cancelBtn"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissPlayerAction(sender:)), for: .touchDown)
        shareBtn = UIButton(frame: CGRect(x: 350 - 84, y: view.frame.height/2-100, width: 84, height: 50))
        shareBtn.setTitle("SHARE ", for: .normal)
        shareBtn.contentHorizontalAlignment = .center
        shareBtn.contentVerticalAlignment = .center
        shareBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        shareBtn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareBtn.semanticContentAttribute = .forceRightToLeft
        shareBtn.tag = index
        shareBtn.tintColor = UIColor.white
        shareBtn.addTarget(self, action: #selector(shareBtnAction(sender:)), for: .touchDown)
        playerViewController.showsPlaybackControls = false
        addChild(playerViewController)
        view.addSubview(playerViewController.view)
        view.addSubview(playPauseBtn.self)
        view.addSubview(dismissBtn.self)
        view.addSubview(shareBtn.self)
        playerViewController.didMove(toParent: self)
    }
    
    @objc func playPauseAction(sender : UIButton) {
        if playerViewController.player?.rate == 0 {
            
            playerViewController.player?.play()
        }
        else {
            playerViewController.player?.pause()
        }
    }
    
    @objc func dismissPlayerAction(sender : UIButton) {
        self.playerViewController.player  = nil
        playerViewController.view.removeFromSuperview()
        dismissBtn.removeFromSuperview()
        playPauseBtn.removeFromSuperview()
        shareBtn.removeFromSuperview()
        
       }
        
    @objc func shareBtnAction(sender : UIButton) {
        let coordinate = placesArray[sender.tag].Location
        let image = placesArray[sender.tag].image
        let ss = "http://maps.apple.com/?ll=\(coordinate.latitude ?? 0.0),\(coordinate.longitude ?? 0.0)"
        let vCardURL = ViewController.vCardURL(from: coordinate, with: "Test")
        let activityViewController = UIActivityViewController(activityItems: [image,ss], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
       }
}

extension ViewController:MKMapViewDelegate
{
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String)
    {
        
        print("Title: \(title)")
        print("Latitude: \(lat)")
        print("Longitude: \(lon)")

        let marker = MKPointAnnotation()
        marker.title = title
        marker.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        customeMapView.centerToLocation(initialLocation)
        customeMapView.addAnnotation(marker)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        let reuseIdentifier = "MyIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.tintColor = .green                // do whatever customization you want
            annotationView?.canShowCallout = false            // but turn off callout
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // do something
        print(view.annotation?.coordinate)
        selectedLoc = view.annotation?.coordinate
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(self, action: #selector(accesTap(cord:sender:)), for: .touchUpInside)
        view.rightCalloutAccessoryView = rightButton
        let index = placesArray.enumerated().filter({ $0.element.Title == view.annotation?.title }).map({ $0.offset })
        rightButton.tag = index.first ?? 0
        
        
    }
    
    
    @objc func accesTap(cord: CLLocationCoordinate2D,sender:UIButton){
        
        self.openAddCreditView(modal: placesArray[sender.tag], index: sender.tag)
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension ViewController{
    static func vCardURL(from coordinate: CLLocationCoordinate2D, with name: String?) -> URL {
        let vCardFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("vCard.loc.vcf")
        
        let vCardString = [
            "BEGIN:VCARD",
            "VERSION:4.0",
            "FN:\(name ?? "Shared Location")",
            "item1.URL;type=pref:http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)",
            "item1.X-ABLabel:map url",
            "END:VCARD"
            ].joined(separator: "\n")
        
        do {
            try vCardString.write(toFile: vCardFileURL.path, atomically: true, encoding: .utf8)
        } catch let error {
            print("Error, \(error.localizedDescription), saving vCard: \(vCardString) to file path: \(vCardFileURL.path).")
        }
        
        return vCardFileURL
    }
}
