//
//  ProfileVC.swift
//  Health37
//
//  Created by Aarti on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import SDWebImage
import Photos

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    ////All IBoutlets
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var btnUserPicSlt: UIButton!
    
    @IBOutlet var btnUserDetailsEdit: UIButton!
    @IBOutlet var lblYourSelfText: UILabel!
    var imagePicker = UIImagePickerController()
    @IBOutlet var viewHeader: UIView!
    
    @IBOutlet var viewFollowersBG: UIView!
    @IBOutlet var lblEmailID: UILabel!
    @IBOutlet var imgBackground: UIImageView!
    
    @IBOutlet var viewCountryBG: UIView!
    var selectedButton : Int! = 0
    //MARK:- UIViewController Life Cycle Method
    var dictParamsProfile = NSDictionary()
    
    var dictSltLocation = NSDictionary()
    
    var imgDataProfile = Data()
    
    var  arrProfileData = NSMutableArray()
    
    var strLat = ""
    var strLong = ""
    @IBOutlet var viewYourSelfBG: UIView!
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    
    @IBOutlet var lblFollowersTitle: UILabel!
    @IBOutlet var lblFollowingTitle: UILabel!
    @IBOutlet var btnNewPost: UIButton!
    
    @IBOutlet var verticalHeight: NSLayoutConstraint!
    @IBOutlet var hightValue: NSLayoutConstraint!
    @IBOutlet var viewTopOutlet: NSLayoutConstraint!
    @IBOutlet var scrollingBar: UIScrollView!
    
    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true
        
        self.imagePicker.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.layer.masksToBounds = true
        
        self.profileImageView.layer.cornerRadius = 50
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userProfileUpdate(noti:)), name: NSNotification.Name(rawValue: "UserProfileUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userUpdateLocation(noti:)), name: NSNotification.Name(rawValue: "UpdateUserLocation"), object: nil)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            lblFollowingTitle.text = "اتابع".localized//"اسألني"
            lblFollowersTitle.text = "متابعون".localized
            btnNewPost.setTitle("منشور جديد".localized, for: .normal)
            
        }
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        profileImageView.layer.masksToBounds = true
        
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
    
    func getUserProfileInfo()
    {
        DispatchQueue.main.async
        {
            if self.appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
    }
    func userInformationUpdate()
    {
        if arrProfileData.count > 0
        {
            
            let imgUrl = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_avatar")
            self.profileImageView.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
            self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.profileImageView.sd_removeActivityIndicator()
            })
            
            let imgUrlCover = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_cover")
            self.imgBackground.sd_addActivityIndicator()
            let urlCover = URL.init(string: "\(imgUrlCover!)")
            self.imgBackground.sd_setImage(with: urlCover, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, urlCover) in
                self.imgBackground.sd_removeActivityIndicator()
            })
            if dictSltLocation.object(forKey: "locationName") as? String == ""
            {
                getUserCountryName()
            }
            else
            {
                if dictSltLocation.count > 0
                {
                    self.countryNameLabel.text = dictSltLocation.object(forKey: "locationName") as? String
                }
                else
                {
                    self.countryNameLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "User_country") as? String
                }
            }
            
            followersLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "followers")
            
            followingLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "follow")
            
            //  userNameLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: kFullName) as? String
            
            if (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "super_user") as? String == "0"
            {
                userNameLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: kFullName) as? String
            }
            else
            {
                let strWorkingPost = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: kFullName) as? String
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "super_user_ic_badge.png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attachmentStr = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                myString.append(attachmentStr)
                userNameLabel.attributedText = myString
            }
            
            if  (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_brief") != ""
            {
                viewYourSelfBG.isHidden = false
                lblYourSelfText.text = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_brief")
            }
            else
            {
                viewFollowersBG.frame.origin.y = viewCountryBG.frame.origin.y + viewCountryBG.frame.size.height + 5
                viewYourSelfBG.isHidden = true
            }
            
            lblEmailID.text = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_email") as? String
            
            var strCountry : String!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                professionLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_cat_name_ar") as? String
            }
            else
            {
                professionLabel.text = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_cat_name") as? String
            }
            
        }
        else
        {
            lblYourSelfText.text = ""
            viewYourSelfBG.isHidden = true
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    func getUserCountryName()
    {
        if dictSltLocation.object(forKey: "locationName") as? String == ""
        {
            strLat = (self.dictSltLocation.object(forKey: "user_lat") as? String)!
            strLong = (self.dictSltLocation.object(forKey: "user_long") as? String)!
        }
        else
        {
            strLat = (self.arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_lat")
            strLong = (self.arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_lon")
        }
        
        if strLat != ""
        {
            
            // Add below code to get address for touch coordinates.
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: Double(strLat)!, longitude: Double(strLong)!)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                // Country
                if let country = placeMark.country {
                    print("CountyName", country)
                    
                    let imgFlagSet = UIImageView()
                    let imgFlags = (self.arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_flag")
                    
                    imgFlagSet.sd_addActivityIndicator()
                    let urlFlag = URL.init(string: "\(imgFlags!)")
                    imgFlagSet.sd_setImage(with: urlFlag , placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        imgFlagSet.sd_removeActivityIndicator()
                    })
                    
                    let attachment = NSTextAttachment()
                    
                    attachment.image = imgFlagSet.image
                    attachment.bounds = CGRect(x: 0, y: -4, width: 26, height: 18)
                    let attachmentStr = NSAttributedString(attachment: attachment)
                    let myString = NSMutableAttributedString(string: NSString.init(format: "%@   ", country) as String)
                    myString.append(attachmentStr)
                    
                    self.countryNameLabel.attributedText = myString
                    
                }
            })
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.titleView = viewHeader
        //        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                //                btnEditAR.isHidden = false
                //                btnEditPicAR.isHidden = false
                //                btnEditCoverAR.isHidden = false
                //
                //                editButton.isHidden = true
                //                btnUserPicSlt.isHidden = true
                //                btnUserDetailsEdit.isHidden = true
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
                
            }
            else
            {
                //  UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "menu")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        
        if arrProfileData.count == 0
        {
            getUserProfileInfo()
        }
        
        
    }
    ///sideMenu
    @objc override func methodSideMenu(_ sender : UIButton)
    {
        self.view.endEditing(true)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.menuContainerViewController.toggleRightSideMenuCompletion
            { () -> Void in
            }
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
    
    
    @objc func userProfileUpdate(noti: Notification)
    {
        arrProfileData.removeAllObjects()
        
    }
    
    @objc func userUpdateLocation(noti: Notification)
    {
        self.dictSltLocation = noti.userInfo! as NSDictionary
        
        print("CountryName", dictSltLocation)
        
        if dictSltLocation.object(forKey: "locationName") as? String == ""
        {
            self.getUserCountryName()
        }
        else
        {
            self.countryNameLabel.text = self.dictSltLocation.object(forKey: "locationName") as? String
        }
        print("CName", countryNameLabel.text)
        
        strLat = (self.dictSltLocation.object(forKey: "user_lat") as? String)!
        strLong = (self.dictSltLocation.object(forKey: "user_long") as? String)!
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.updateUserProfileAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
        
    }
    
    // MARK: - UIButtonsMethod
    @IBAction func methodSetting(_ sender: Any)
    {
        self.menuContainerViewController.toggleRightSideMenuCompletion
        { () -> Void in
        }
    }
    
    ///Open SideMenu
    @IBAction func methodNewPost(_ sender: Any)
    {
        let Post: PostVC!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Post  = PostVC(nibName: "PostVC_Arabic",bundle:nil)
        }
        else
        {
            Post  = PostVC(nibName: "PostVC",bundle:nil)
        }
        
        self.navigationController?.pushViewController(Post, animated: true)
    }
    @IBAction func methodFollowerFollowing(_ sender: UIButton)
    {
        let Follow: FollowerFollowingScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Follow  = FollowerFollowingScreen(nibName: "FollowerFollowing_Arabic",bundle:nil)
        }
        else
        {
            Follow  = FollowerFollowingScreen(nibName: "FollowerFollowingScreen",bundle:nil)
        }
        
        Follow.strOtherUserID = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        if sender.tag == 0
        {
            self.navigationController?.pushViewController(Follow, animated: true)
        }
        else
        {
            Follow.strFromFollowing = "FromFollowing"
            self.navigationController?.pushViewController(Follow, animated: true)
        }
    }
    @IBAction func methodUserLocationUpdate(_ sender: Any)
    {
        if self.arrProfileData.count > 0
        {
            let UserD: MapProfileScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                UserD  = MapProfileScreen(nibName: "MapProfileArabic",bundle:nil)
            }
            else
            {
                UserD  = MapProfileScreen(nibName: "MapProfileScreen",bundle:nil)
            }
            
            UserD.strProfileLat = (self.arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_lat")
            UserD.strProfileLong = (self.arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_lon")
            
            self.navigationController?.pushViewController(UserD, animated: true)
        }
    }
    @IBAction func methodUserUpdate(_ sender: Any)
    {
        if arrProfileData.count > 0
        {
            let UserD: UserDetailUpdateScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                UserD  = UserDetailUpdateScreen(nibName: "UserDetailUpdate_Arabic",bundle:nil)
            }
            else
            {
                UserD  = UserDetailUpdateScreen(nibName: "UserDetailUpdateScreen",bundle:nil)
            }
            UserD.strYourSelf = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_brief")
            UserD.categoryID = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "user_cat_id")
            
            self.navigationController?.pushViewController(UserD, animated: true)
        }
    }
    ///Edit Profile
    @IBAction func methodChoosePicture(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "Chose image".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { _ in
            self.appDelegate.checkCameraPermission(completionHandler: { (checkBool) in
                if checkBool == true
                {
                    self.openCamera()
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery".localized, style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel".localized, style: .cancel, handler: nil))
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
        if sender.tag == 0
        {
            selectedButton = 0
        }
        else
        {
            selectedButton = 1
        }
    }
    //MARK:- User Defind Methods............
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            //            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //            imagePicker.allowsEditing = true
            //            self.present(imagePicker, animated: true, completion: nil)
            let pickerImage = UIImagePickerController()
            
            pickerImage.sourceType = UIImagePickerControllerSourceType.camera
            pickerImage.delegate = self
            pickerImage.allowsEditing = true
            pickerImage.cameraCaptureMode = .photo
            pickerImage.modalPresentationStyle = .fullScreen
            
            self .present(pickerImage, animated: true, completion: nil)
            
        }
        else
        {
            let alert  = UIAlertController(title: "Warning".localized, message: "You don't have camera".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        //        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //        imagePicker.allowsEditing = true
        //        self.present(imagePicker, animated: true, completion: nil)
        let pickerImage = UIImagePickerController()
        pickerImage.delegate = self;
        pickerImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerImage.allowsEditing = true
        
        self.present(pickerImage, animated: true, completion: nil)
        
    }
    
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
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - UIImagePicker Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        
        var image: UIImage!
        // fetch the selected image
        
        if picker.allowsEditing
        {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        } else
        {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        
        if selectedButton == 0
        {
            imgBackground.image = image
            imgDataProfile = UIImageJPEGRepresentation(image!, 0.4)! as Data
        }
        else
        {
            profileImageView.image = image
            imgDataProfile = UIImageJPEGRepresentation(image!, 0.4)! as Data
        }
        
        
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.updateUserProfileAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
        
        //imageData = UIImageJPEGRepresentation(image, 0.7) as NSData!
    }
    // MARK:- updateProfile API Integration.................
    func updateProfileParams() -> NSMutableDictionary
    {
        //        // dic.setObject(self.txtClinic.text!, forKey: "subClinic" as NSCopying)
        
        let dictUser = NSMutableDictionary()
        
        let userName = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: kUsername) as? String
        let userCatID = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_cat_id") as! String
        let userEmailID = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_email") as! String
        let userFullName = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "full_name") as! String
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(userName!, forKey: kName as NSCopying)
        dictUser.setObject(userEmailID, forKey: kEmail as NSCopying)
        dictUser.setObject(userFullName, forKey: kUsername as NSCopying)
        
        dictUser.setObject(userCatID, forKey: kUserCat as NSCopying)
        dictUser.setObject("", forKey: kUserBrief as NSCopying)
        
        dictUser.setObject(strLat, forKey: "user_lat" as NSCopying)
        dictUser.setObject(strLong, forKey: "user_lon" as NSCopying)
        
        dictUser.setValue(countryNameLabel.text!, forKey: "User_country")
        
        return dictUser
    }
    
    // MARK:- CheckUserAPI Integration
    @objc func updateUserProfileAPI()
    {
        var strProfileKey = ""
        
        if selectedButton == 0
        {
            strProfileKey = "cover"
        }
        else
        {
            strProfileKey = "avatar"
        }
        print("IMgData1", imgDataProfile)
        getallApiResultwithimagePostMethod(strMethodname: kMethodUpdateProfile, imgData: imgDataProfile, strImgKey: strProfileKey, Details: self.updateProfileParams()) { (responseData, error) in
            
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
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
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
            }
        }
    }
    // MARK:- updateProfile API Integration.................
    func getProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        let userID = UserDefaults.standard.object(forKey: kUserID)
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(userID!, forKey: "other_id" as NSCopying)
        
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
    
    // MARK:- CheckUserAPI Integration
    @objc func updateGetProfileAPI()
    {
        var strProfileKey = ""
        
        if selectedButton == 0
        {
            strProfileKey = "cover"
        }
        else
        {
            strProfileKey = "avatar"
        }
        getallApiResultwithimagePostMethod(strMethodname: kMethodGetProfile, imgData: imgDataProfile, strImgKey: strProfileKey, Details: getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.arrProfileData = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                        
                        print("self.arrProfileData",self.arrProfileData)
                        self.saveDataInLocal(fileName : "profile_data" , data : self.arrProfileData)
                        
                        let imgUrl = (self.arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_avatar")
                        let strFullName = (self.arrProfileData.object(at: 0) as! NSDictionary).object(forKey: kFullName) as! String
                        
                        let strSuperKey = (self.arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "super_user") as! String
                        
                        let dic = NSMutableDictionary()
                        dic.setObject(imgUrl!, forKey: "profileImage" as NSCopying)
                        dic.setObject(strFullName, forKey: kFullName as NSCopying)
                        dic.setObject(strSuperKey, forKey: "super_user" as NSCopying)
                        if let user_cat_id = (self.arrProfileData.object(at: 0) as? NSDictionary)?.object(forKey: "user_cat_id") as? String
                        {
                            dic.setObject(user_cat_id, forKey: "user_cat_id" as NSCopying)
                        }
                        
                        UserDefaults.standard.set(strFullName, forKey: kFullName)
                        
                        UserDefaults.standard.set(imgUrl!, forKey: "profileImage")
                        UserDefaults.standard.set(strSuperKey, forKey: "super_user")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserUpdateSideMenu"), object: nil, userInfo: dic as? [AnyHashable : Any])
                        
                        self.userInformationUpdate()
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
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
            }
        }
    }
    
    func getNotificationCounts() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        return dictUser
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
