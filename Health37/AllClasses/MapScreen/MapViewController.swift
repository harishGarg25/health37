//
//  MapViewController.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class customGMSMarker: GMSMarker
{
    var dicSelectedFarmer = NSDictionary()
    var tagMarker: Int! = 0
    
}

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var viewSearchBtnBG: UIView!
    @IBOutlet var viewTxtFBG: UIView!
    @IBOutlet var viewUserInfo: UIView!
    @IBOutlet  var viewBottomButtons: UIView!
    @IBOutlet var lblHeaderTitle: UILabel!
    @IBOutlet var GMap      : GMSMapView!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnSearchText: UIButton!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewHeaderTitle: UIView!
    @IBOutlet var collectionOptions: UICollectionView!
    @IBOutlet var btnSearchHere: UIButton!
    @IBOutlet var lblNotificationCount: UILabel!
    @IBOutlet var viewNotificationCount: UIView!
    
    var arrClinics = NSMutableArray()
    var arrUserLocation = [[String: Any]]()
    var arrMarkers = NSMutableArray()
    var categoryID = String()
    var categoryName = String()
    var catID = String()
    var strProfileLat = ""
    var strProfileLong = ""
    var strFromHome = ""
    var pageNumber = 0
    var radius : Int = 0
    var latitude : Double = 0
    var longitude : Double = 0
    var strCollection = ""
    var arrResultPredicate = NSMutableArray()
    var arrSearching = NSMutableArray()
    var strLatitude = ""
    var strLontitude = ""
    var isApiIdle = true
    var isTappedInfoWindow = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.currentLocationShowing()
        
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true
        
        viewTxtFBG.layer.cornerRadius = 17.0
        btnSearchHere.layer.cornerRadius = 20.0
        btnSearchHere.layer.borderWidth = 1.0
        btnSearchHere.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        GMap.delegate = self;
        let nib = UINib(nibName: "OptionsCollectionCell", bundle: nil)
        collectionOptions.register(nib,forCellWithReuseIdentifier: "OptionsCollectionCell")
        
        GMap.isMyLocationEnabled = true
        
        lblHeaderTitle.text = strFromHome
        
        collectionOptions.isHidden = false
        viewHeaderTitle.isHidden = false
        
        if categoryName != "Search With Discount"
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtSearch.placeholder = "Search....".localized
            }
            
            DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.catID = "-1"
                    self.performSelector(inBackground: #selector(self.methodGetSubCategoryApi), with: nil)
                    self.performSelector(inBackground: #selector(self.methodGetLocationsApi), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
            }
        }
        else
        {
            GMap.frame.origin.y = GMap.frame.origin.y - 90
            GMap.frame.size.height = GMap.frame.size.height + 90
            collectionOptions.frame.size.height = 0
            collectionOptions.isHidden = true
            viewHeaderTitle.frame.size.height = 0
            btnSearchHere.isHidden = true
            txtSearch.placeholder = "Enter discount %...".localized
            self.viewSearchBtnBG.isHidden = true
            txtSearch.keyboardType = .numberPad
            //txtSearch.text = "E86CK5JBY4"
            self.showActivity(text: "")
            methodSearchFriendWithCouponApi()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotifications), name: NSNotification.Name(rawValue: "updateNoficationCounts"), object: nil)
    }
    
    
    @objc func updateNotifications()
    {
        if appDelegate.strNotificationTotal != ""
        {
            self.lblNotificationCount.text = "\(appDelegate.strNotificationTotal)"
            self.viewNotificationCount.isHidden = false
        }
        else
        {
            self.viewNotificationCount.isHidden = true
        }
    }
    
    
    func currentLocationShowing()
    {
        self.appDelegate.checkLocationGetPermission()
        if self.appDelegate.currentLocation != nil
        {
            print("Lat",appDelegate.currentLocation.coordinate.latitude)
            //            let marker = GMSMarker()
            //            marker.position = CLLocationCoordinate2D(latitude: Double(appDelegate.currentLocation.coordinate.latitude), longitude: Double(appDelegate.currentLocation.coordinate.longitude) )
            //
            //            marker.title = ""
            //            marker.snippet = ""
            //            //        marker.icon = UIImage.init(named: "pin.png")
            //            marker.icon = UIImage.init(named: "")
            //            marker.map = self.GMap
            let camera = GMSCameraPosition.camera(withLatitude: Double(appDelegate.currentLocation.coordinate.latitude), longitude: Double(appDelegate.currentLocation.coordinate.longitude) , zoom: 9.0)
            
            self.GMap.animate(to: camera)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.appDelegate.checkLocationGetPermission()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back-white"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back-white"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back-white"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "back-white")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        
        self.navigationItem.titleView = viewHeader
    }
    @objc func textDidChanged(_ noti: Notification)
    {
        if categoryName != "Search With Discount"
        {
            let textFiled = noti.object as! UITextField
            let strKeyword = textFiled.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            var searchPredicate = NSPredicate()
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                searchPredicate = NSPredicate(format: "SELF.Cat_ar contains[cd] %@", strKeyword)
            }
            else
            {
                searchPredicate = NSPredicate(format: "SELF.cat_name contains[cd] %@", strKeyword)
            }
            
            let  usersDataFromResponse = (arrResultPredicate as NSArray).filtered(using: searchPredicate)
            
            print("usersDataFromResponse", usersDataFromResponse)
            if strKeyword != ""
            {
                self.arrClinics = ((usersDataFromResponse) as NSArray).mutableCopy() as! NSMutableArray
            }
            else
            {
                self.arrClinics = arrResultPredicate
            }
            if (UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar") ||             ((UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice") &&  self.arrClinics.count > 0
            {
                self.arrClinics = (self.arrClinics.reversed()as NSArray).mutableCopy() as! NSMutableArray
                self.collectionOptions.reloadData()
                
                let indexITem = IndexPath.init(row:(self.arrClinics.count - 1) , section: 0)
                
                self.collectionOptions.scrollToItem(at: indexITem, at: .right, animated: true)
            }
            else
            {
                self.collectionOptions.reloadData()
            }
        }
    }
    ///sideMenu
    @objc override func methodSideMenu(_ sender : UIButton)
    {
        self.view.endEditing(true)
        if (UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar") ||             ((UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice")
        {
            self.navigationController?.popViewController(animated: true)
            
        }
        else
        {
            self.menuContainerViewController.toggleLeftSideMenuCompletion
            { () -> Void in
            }
        }
    }
    ///SettingsScreenOpen
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
    func nearByUserLocation()
    {
        var tag = 0
        var bounds = GMSCoordinateBounds()
        GMap.clear()
        arrMarkers.removeAllObjects()
        
        var set = Set<String>()
        let arraySet: [[String: Any]] = arrUserLocation.compactMap {
            guard let name = $0["user_id"] as? String else { return nil }
            return set.insert(name).inserted ? $0 : nil
        }
        
        arrUserLocation = arraySet
        
        if self.arrUserLocation.count > 0
        {
            if self.appDelegate.currentLocation != nil
            {
                for obj in self.arrUserLocation //for i in 0..<self.arrUserLocation.count
                {
                    let dicObj = obj as NSDictionary
                    // print("dicObj---------",dicObj)
                    
                    let userLat = (dicObj.object(forKey: "user_lat") as? String) ?? "0.0"
                    let userLong = (dicObj.object(forKey: "user_lon") as? String) ?? "0.0"
                    
                    let marker = customGMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(userLat)!, longitude: Double(userLong)!)
                    
                    let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
                    infoView.backgroundColor = Color.theme
                    let label: UILabel = UILabel()
                    label.textColor = UIColor.white
                    label.textAlignment = .center
                    label.font = UIFont.init(name: "Lato-Semibold", size: 14.0)
                    label.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
                    label.text = "-\((dicObj.object(forKey: "discount_amount") as? String) ?? "N/M")"
                    infoView.addSubview(label)
                    
                    marker.icon = UIImage.init(named: "pin.png")
//                    marker.iconView = infoView
                    marker.map = self.GMap
                    marker.dicSelectedFarmer = obj as NSDictionary
                    marker.tagMarker = tag
                    
                    arrMarkers.add(marker)
                    tag += 1
                    bounds = bounds.includingCoordinate(marker.position)
                    // let camera = GMSCameraPosition.camera(withLatitude: Double(userLat)!, longitude: Double(userLong)! , zoom: 12.0)
                    
                    //self.GMap.animate(to: camera)
                }
                GMSCameraUpdate.fit(bounds, withPadding: 30.0)
            }
        }
        else
        {
            if self.appDelegate.currentLocation != nil
            {
                let strLat = "\(appDelegate.currentLocation.coordinate.latitude)"
                let  strLan = "\(appDelegate.currentLocation.coordinate.longitude)"
                
                let marker = customGMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(strLat)!, longitude: Double(strLan)! )
                marker.title = ""
                marker.snippet = ""
                marker.icon = UIImage.init(named: "")
                
                //                let camera = GMSCameraPosition.camera(withLatitude: Double(strLat)!, longitude: Double(strLan)! , zoom: 12.0)
                //
                //                self.GMap.animate(to: camera)
            }
        }
    }
    
    func addAnnotation()
    {
        var tag = 0
        arrMarkers.removeAllObjects()
        for obj in arrUserLocation
        {
            print("arrFarmer---------",arrUserLocation)
            let dicObj = obj as NSDictionary
            // print("dicObj---------",dicObj)
            
            let strLat = dicObj.object(forKey: "latitude") as? String
            let strLng = dicObj.object(forKey: "longitude") as? String
            
            let marker = customGMSMarker()
            
            marker.position = CLLocationCoordinate2D(latitude:Double(strLat!)! , longitude: Double(strLng!)!)
            marker.title = ""
            marker.snippet = ""
            marker.map = GMap
            marker.icon = UIImage.init(named: "red-pin.png")
            marker.dicSelectedFarmer = obj as NSDictionary
            marker.tagMarker = tag
            arrMarkers.add(marker)
            tag += 1
        }
        
        //   self.clView.reloadData()
        self.focusMapToShowAllMarkers()
    }
    
    //touchesEnded
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func focusMapToShowAllMarkers()
    {
        if self.appDelegate.currentLocation != nil
        {
            let gCrcl = GMSCircle()
            gCrcl.radius = 100000
            gCrcl.position =  CLLocationCoordinate2D(latitude: self.appDelegate.currentLocation.coordinate.latitude, longitude: self.appDelegate.currentLocation.coordinate.longitude)
        }
    }
    
    // MARK: - UIButtonsMethod
    @IBAction func methodSearchHere(_ sender: Any)
    {
        GMap.clear()
        var centerMapCoordinate:CLLocationCoordinate2D!
        
        let latitude = self.GMap.camera.target.latitude
        let longitude = self.GMap.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
        
        print("latitude", latitude, longitude )
        // print("centerMapCoordinate", centerMapCoordinate)
        
        strLatitude = "\(self.GMap.camera.target.latitude)"
        strLontitude = "\(self.GMap.camera.target.longitude)"
        print("strLatitude", strLatitude, strLontitude )
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(strLatitude)!, longitude: Double(strLontitude)! , zoom: 6.0)
        
        self.GMap.animate(to: camera)
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodGetLocationsApi), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
    }
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = centerMapCoordinate
        marker.map = self.GMap
    }
    @IBAction func methodSearchingOptions(_ sender: UIButton)
    {
        if categoryName != "Search With Discount"
        {
            self.viewSearchBtnBG.isHidden = false
        }else
        {
            if self.viewSearchBtnBG.isHidden == false
            {
                if txtSearch.text?.count ?? 0 != 0
                {
                    self.view.endEditing(true)
                    methodSearchFriendWithCouponApi()
                }
                else
                {
                    self.onShowAlertController(title: "Alert" , message: "Please enter discount.".localized)
                }
            }else
            {
                self.viewSearchBtnBG.isHidden = false
            }
        }
    }
    @IBAction func methodSearchingClose(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.arrClinics = arrResultPredicate
        txtSearch.text = ""
        
        if (UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar") || ((UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice") &&  self.arrClinics.count > 0
        {
            self.arrClinics = (self.arrClinics.reversed()as NSArray).mutableCopy() as! NSMutableArray
        }
        
        collectionOptions.reloadData()
        
        self.viewSearchBtnBG.isHidden = true
    }
    
    //    @IBAction func methodSettings(_ sender: Any)
    //    {
    //        self.menuContainerViewController.toggleRightSideMenuCompletion
    //            { () -> Void in
    //        }
    //    }
    ///TimeLines
    @IBAction func methodTimeline(_ sender: UIButton)
    {
        let Group: TimelineScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Group  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
        }
        else
        {
            Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
        }
        Group.strTabbarClick = "FromTimeLine"
        self.navigationController?.pushViewController(Group, animated: true)
    }
    
    ///AllNotifications
    @IBAction func methodNotification(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let Group: TimelineScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                Group  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
            }
            else
            {
                Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
            }
            Group.strTabbarClick = "FromNotification"
            self.navigationController?.pushViewController(Group, animated: true)
        }
    }
    ///AllInboxMessages
    @IBAction func methodInbox(_ sender: UIButton)
    {
        if sender.tag == 2
        {
            let Group: TimelineScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                Group  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
            }
            else
            {
                Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
            }
            Group.strTabbarClick = "FromInbox"
            self.navigationController?.pushViewController(Group, animated: true)
        }
    }
    @IBAction func methodClinicOptionSelect(_ sender: UIButton)
    {
        self.catID = (self.arrClinics.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kCatID)
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodGetLocationsApi), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
        
        self.view.endEditing(true)
        pageNumber = sender.tag
        
        print("pageNumber : %d",pageNumber)
        self.collectionOptions.reloadData()
        let indexToScrollTo = IndexPath(item: pageNumber, section: 0)
        self.collectionOptions.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: true)
        
    }
    // MARK: - ScrollingCollectionDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
        
        if scrollView.tag == 101
        {
            pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
            print("pageNumber",pageNumber)
            //collectionAllOptions.reloadData()
            //  self.setHeaderButtonImg()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UITextFieldMethod
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    //MARK:- CollectionView Delegates.......
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if  self.arrClinics.count > 0
        {
            return arrClinics.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionCell", for: indexPath as IndexPath) as! OptionsCollectionCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("OptionsCollectionCell", owner: nil, options: nil)! as [Any]
            cell = (nib[0] as? OptionsCollectionCell)!
            cell.backgroundColor = (UIColor.clear)
        }
        cell.sepratorBottom.isHidden = true
        cell.btnAll.isSelected = false
        if indexPath.item == pageNumber
        {
            cell.sepratorBottom.isHidden = false
            cell.btnAll.isSelected = true
        }
        cell.btnAll.tag = indexPath.row
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            cell.btnAll.setTitle((arrClinics.object(at: indexPath.row) as! NSDictionary).object(forKey: "Cat_ar")as? String, for: .normal)
        }
        else
        {
            cell.btnAll.setTitle((arrClinics.object(at: indexPath.row) as! NSDictionary).object(forKey: kCatName)as? String, for: .normal)
        }
        cell.btnAll.setTitle( cell.btnAll.titleLabel?.text?.uppercased(), for: UIControlState.normal)
        
        cell.btnAll.addTarget(self, action: #selector(methodClinicOptionSelect), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            return CGSize(width: collectionView.frame.size.width/4, height: 50)
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width/3, height: 50)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        let dicData = (marker as! customGMSMarker).dicSelectedFarmer
        let OtherUser  = OtherUserProfileScreen(nibName: "OtherUserProfileScreen",bundle:nil)
        OtherUser.strOtherFriendID = dicData.valueForNullableKey(key: kUserID)
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if categoryName == "Search With Discount"
        {
            debugPrint(position.target.latitude)
            debugPrint(position.target.longitude)
            debugPrint(self.GMap.getRadius()/1000)
            debugPrint(mapView.getRadius()/1000)
            latitude = position.target.latitude
            longitude = position.target.longitude
            radius = Int((mapView.getRadius()/500))
            radius = radius > 1000 ? 1000 : radius
            
            if isApiIdle && isTappedInfoWindow == false
            {
                isApiIdle = false
                methodSearchFriendWithCouponApi()
            }
            isTappedInfoWindow = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        
        isTappedInfoWindow = true
        
        print("----------------------",(marker as! customGMSMarker).tagMarker!)
        let dicData = (marker as! customGMSMarker).dicSelectedFarmer
        print("dicdata----------",dicData)
        
        let pinView = mapPinView.init(nibName: "mapPinView", bundle: nil)
        
        pinView.imageProfile = "\(dicData.object(forKey: "user_image")!)"
        pinView.imagePath = "\(dicData.object(forKey: "User_cover")!)"
        pinView.name = "\(dicData.object(forKey: "user_fullname")!)"
        pinView.discount = "\(dicData.object(forKey: "discount_amount") ?? "")"
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            pinView.address = "\(dicData.object(forKey: "Cat_ar")!)"
        }
        else
        {
            pinView.address = "\(dicData.object(forKey: "Cat_en")!)"
        }
        
        return pinView.view
    }
    
    func getNotificationCounts() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        return dictUser
    }
    
    // MARK:- updateProfile API Integration.................
    func SearchAllUserParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        //        if txtSearch.text != ""
        //        {
        //            dictUser.setObject(txtSearch.text ?? "", forKey: "discount_amount" as NSCopying)
        //        }
        dictUser.setObject(latitude , forKey: "latitude" as NSCopying)
        dictUser.setObject(longitude , forKey: "longitude" as NSCopying)
        dictUser.setObject(radius , forKey: "radius" as NSCopying)
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: "language" as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: "language" as NSCopying)
        }
        
        return dictUser
    }
    
    @objc func methodSearchFriendWithCouponApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetCouponLocation, Details: self.SearchAllUserParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                self.isApiIdle = true
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        if let messgae : String = responseData?["message"] as? String, messgae == "No Coupon code Present."
                        {
                            self.showAlert(message: messgae.localized)
                        }else
                        {
                            print("responseData",responseData!)
                            if let UserLocation : NSDictionary = responseData
                            {
                                if let UserLocation : [[String:Any]] = UserLocation.object(forKey: "location_data") as? [[String:Any]]
                                {
                                    self.arrUserLocation = UserLocation
                                }
                                if self.arrUserLocation.count > 0
                                {
                                    self.nearByUserLocation()
                                }else
                                {
                                    self.GMap.clear()
                                }
                            }
                            else
                            {
                                self.GMap.clear()
                            }
                        }
                    }
                    else
                    {
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
        }
    }
    
    // MARK:- Get Child Category API Integration.................
    func childCategoryParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(categoryID, forKey: kParentID as NSCopying)
        dictUser.setObject("1", forKey: "all_needed" as NSCopying)
        
        return dictUser
    }
    
    @objc func methodGetSubCategoryApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetChildCategory, Details: self.childCategoryParams()) { (responseData, error) in
            DispatchQueue.main.async
            {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.arrResultPredicate = (responseData?.object(forKey: "cat_data") as!NSArray).mutableCopy() as! NSMutableArray
                        
                        self.arrClinics =  self.arrResultPredicate
                        
                        if  self.arrClinics.count > 0
                        {
                            self.collectionOptions.isHidden = false
                            self.btnSearch.isHidden = false
                            
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                                {
                                    self.collectionOptions.reloadData()
                                }
                                else
                                {
                                    self.arrClinics = (self.arrResultPredicate.reversed()as NSArray).mutableCopy() as! NSMutableArray
                                    
                                    self.pageNumber = self.arrClinics.count - 1
                                    self.collectionOptions.reloadData()
                                    let indexITem = IndexPath.init(row:(self.arrClinics.count - 1) , section: 0)
                                    
                                    self.collectionOptions.scrollToItem(at: indexITem, at: .right, animated: true)
                                }
                            }
                            else
                            {
                                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                                {
                                    self.arrClinics = (self.arrResultPredicate.reversed()as NSArray).mutableCopy() as! NSMutableArray
                                    self.pageNumber = self.arrClinics.count
                                    self.collectionOptions.reloadData()
                                    let indexITem = IndexPath.init(row:(self.arrClinics.count - 1) , section: 0)
                                    
                                    self.collectionOptions.scrollToItem(at: indexITem, at: .left, animated: true)
                                    
                                }
                                else
                                {
                                    self.collectionOptions.reloadData()
                                }
                            }
                        }
                        else
                        {
                            self.collectionOptions.isHidden = true
                            self.btnSearch.isHidden = true
                        }
                        
                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        
                        print("responseData",responseData!)
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }            }
        }
    }
    
    // MARK:- Get Child Category API Integration.................
    func getLocationParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(categoryID, forKey: kMasterCatID as NSCopying)
        dictUser.setObject(catID, forKey: kCatID as NSCopying)
        
        if self.appDelegate.currentLocation != nil
        {
            print("strLatitude", strLatitude, strLontitude )
            
            if strLontitude != ""
            {
                dictUser.setObject(strLatitude, forKey: "lat" as NSCopying)
                dictUser.setObject(strLontitude, forKey: "lon" as NSCopying)
            }
            else
            {
                let strLat = "\(appDelegate.currentLocation.coordinate.latitude)"
                let  strLan = "\(appDelegate.currentLocation.coordinate.longitude)"
                
                dictUser.setObject(strLat, forKey: "lat" as NSCopying)
                dictUser.setObject(strLan, forKey: "lon" as NSCopying)
            }
        }
        else
        {
            dictUser.setObject("0.0", forKey: "lat" as NSCopying)
            dictUser.setObject("0", forKey: "lon" as NSCopying)
        }
        
        return dictUser
    }
    
    @objc func methodGetLocationsApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetLocation, Details: self.getLocationParams()) { (responseData, error) in
            DispatchQueue.main.async
            {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        if let UserLocation : [[String:Any]] = responseData?.object(forKey: "user_data") as? [[String:Any]]
                        {
                            self.arrUserLocation = UserLocation
                        }
                        if self.arrUserLocation.count > 0
                        {
                            self.nearByUserLocation()
                        }
                        else
                        {
                            self.GMap.clear()
                        }
                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    
                }
            }
        }
    }
    
    
    // MARK:- Get NotificationCount Integration.................
    @objc func methodNotificationCount()
    {
        //let dictParameters = NSDictionary()
        getallApiResultwithGetMethod(strMethodname: kMethodNotificationCount, Details: getNotificationCounts()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        if responseData?.valueForNullableKey(key: "new") != "" && (responseData?.valueForNullableKey(key: "new") as! NSString).intValue > 0
                        {
                            self.lblNotificationCount.text = responseData?.valueForNullableKey(key: "new")
                            self.viewNotificationCount.isHidden = false
                        }
                        else
                        {
                            self.viewNotificationCount.isHidden = true
                        }
                    }
                    else
                    {
                        self.viewNotificationCount.isHidden = true
                    }
                }
            }
        }
    }
    
}

extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
    }
}
