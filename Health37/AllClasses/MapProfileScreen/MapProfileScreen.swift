//
//  MapProfileScreen.swift
//  Health37
//
//  Created by Ramprasad on 25/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import GoogleMaps

class MapProfileScreen: UIViewController,GMSMapViewDelegate {

    @IBOutlet var viewHeader: UIView!
    @IBOutlet var GMap      : GMSMapView!

    var strProfileLat = ""
    var strProfileLong = ""

    @IBOutlet var viewButtonsPopup: UIView!
    @IBOutlet var viewButtonsBG: UIView!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var strSelectCountry = ""
    
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!

    @IBOutlet var lblSaveRemove: UILabel!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnRemove: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            btnSave.setTitle("Save".localized, for: .normal)
            btnRemove.setTitle("Remove".localized, for: .normal)
            lblSaveRemove.text = "Save/ Remove event location".localized
        }
        self.GMap.clear()
        if strProfileLat != ""
        {
            print("LAT: && LONG:",Double(strProfileLat)!, Double(strProfileLong)! )
            viewButtonsBG.layer.cornerRadius = 8.0
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(strProfileLat)!, longitude: Double(strProfileLong)! )
            marker.title = ""
            marker.snippet = ""
            marker.icon = UIImage.init(named: "pin.png")
            marker.map = self.GMap
            let camera = GMSCameraPosition.camera(withLatitude: Double(strProfileLat)!, longitude: Double(strProfileLong)! , zoom: 9.0)
            
            self.GMap.animate(to: camera)
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector(("handleLongPress:")))
            self.GMap.addGestureRecognizer(longPressRecognizer)
        }
        GMap.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.titleView = viewHeader

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "white_back")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }

    }
    
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    ///Open Settings
    @IBAction func methodSettings(_ sender: Any)
    {
        self.view.endEditing(true)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.menuContainerViewController.toggleLeftSideMenuCompletion
                { () -> Void in
            }
        }
        else
        {
            self.menuContainerViewController.toggleRightSideMenuCompletion
                { () -> Void in
            }
        }
    }
    ///TimeLines
    @IBAction func methodTimeline(_ sender: UIButton)
    {
        let Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
        Group.strTabbarClick = "FromTimeLine"
        self.navigationController?.pushViewController(Group, animated: true)
    }
    
    ///AllNotifications
    @IBAction func methodNotification(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
            Group.strTabbarClick = "FromNotification"
            self.navigationController?.pushViewController(Group, animated: true)
        }
    }
    ///AllInboxMessages
    @IBAction func methodInbox(_ sender: UIButton)
    {
        if sender.tag == 2
        {
            let Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
            Group.strTabbarClick = "FromInbox"
            self.navigationController?.pushViewController(Group, animated: true)
        }
    }
    @IBAction func methodSaveRemoveLocation(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - MethodButtons
    @IBAction func methodSaveRemove(_ sender: UIButton)
    {
        viewButtonsPopup.removeFromSuperview()
        if sender.tag == 0
        {
            print("strSelectCountry",strSelectCountry)
            let dic = NSMutableDictionary()
            dic.setObject(strSelectCountry, forKey: "locationName" as NSCopying)
            dic.setObject(strProfileLat, forKey: "user_lat" as NSCopying)
            dic.setObject(strProfileLong, forKey: "user_long" as NSCopying)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateUserLocation"), object: nil, userInfo: dic as? [AnyHashable : Any])
            self.navigationController?.popViewController(animated: true)

        }
        else
        {
           GMap.clear()
        }
    }
    
    @IBAction func MethodViewExit(_ sender: Any)
    {
        self.viewButtonsPopup.removeFromSuperview()
    }

    func handleLongPress(recognizer: UILongPressGestureRecognizer)
    {
        
        if (recognizer.state == UIGestureRecognizerState.began)
        {
            let longPressPoint = recognizer.location(in: self.GMap);
            let coordinate = GMap.projection.coordinate(for: longPressPoint )
            //Now you have Coordinate of map add marker on that location
            let marker = GMSMarker(position: coordinate)
            marker.opacity = 0.6
            //   marker.position = CLLocationCoordinate2D(latitude: Double(userLat!)!, longitude: Double(userLong!)! )
            marker.title = "Current Location"
            marker.icon = UIImage.init(named: "pin.png")
            
            marker.snippet = ""
            marker.map = GMap
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.viewButtonsPopup)
        self.viewButtonsPopup.frame = window.frame

        return true
        }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D)
    {
        
        self.strProfileLat =  "\(coordinate.latitude)"
        self.strProfileLong = "\(coordinate.longitude)"
        print("LAT LONG",  self.strProfileLat, self.strProfileLong)
        
        let marker = GMSMarker(position: coordinate)
        marker.title = "Found You!"
        marker.map = mapView
        marker.icon = UIImage.init(named: "pin.png")
            let num = coordinate.latitude as NSNumber
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 4
            formatter.minimumFractionDigits = 4
            _ = formatter.string(from: num)
            print("long: \(coordinate.longitude)")
            let num1 = coordinate.longitude as NSNumber
            let formatter1 = NumberFormatter()
            formatter1.maximumFractionDigits = 4
            formatter1.minimumFractionDigits = 4
            _ = formatter1.string(from: num1)
        //    self.adressLoLa.text = "\(num),\(num1)"
            
            // Add below code to get address for touch coordinates.
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "en_US"), completionHandler: {(placemarks, error) -> Void in
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                // Location name
                //                if let locationName = placeMark.location {
                ////                    print(locationName)
                //
                //                }
                //                // Street address
                //                if let street = placeMark.thoroughfare {
                //                    print(street)
                //                }
                //                // City
                //                if let city = placeMark.subAdministrativeArea {
                //                    print(city)
                //                }
                //                // Zip code
                //                if let zip = placeMark.isoCountryCode {
                //                    print(zip)
                //                }
                // Country
                if let country = placeMark.country {
                    print("CountyName", country)
                    self.strSelectCountry = "\(country)"
                }
            })
        } else {
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Fallback on earlier versions
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                // Country
                if let country = placeMark.country {
                    print("CountyName", country)
                    self.strSelectCountry = "\(country)"
                }
            })
        }
    }

}


