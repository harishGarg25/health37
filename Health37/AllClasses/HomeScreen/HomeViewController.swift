//
//  HomeViewController.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.


import UIKit


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    ////IBoutlets
    @IBOutlet var txtSearching: UITextField!
    @IBOutlet var tblHome: UITableView!
    @IBOutlet var viewSearchBG: UIView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    @IBOutlet var lblNotificationCount: UILabel!
    @IBOutlet var viewNotificationCount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        viewSearchBG.layer.cornerRadius = 17.0
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateHomeScreenData), name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            txtSearching.placeholder = "Search....".localized
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.titleView = viewHeader
        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        else
        {
            if UserDefaults.standard.object(forKey: "applanguageArabic") != nil && (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
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
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
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
    
    @objc func updateHomeScreenData()
    {
        tblHome.reloadData()
    }
    
    // MARK: - UITextFieldMethod
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.view.endEditing(true)
        let HomeS: HomeSearchScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            HomeS  = HomeSearchScreen(nibName: "HomeSearchScreen_AR",bundle:nil)
        }
        else
        {
            HomeS  = HomeSearchScreen(nibName: "HomeSearchScreen",bundle:nil)
        }
        self.navigationController?.pushViewController(HomeS, animated: true)
    }
    
    // MARK: - UIButtonsMethod
    
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
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if appDelegate.arrAllHomeCategory.count > 0
        {
            return appDelegate.arrAllHomeCategory.count + 2
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier: String = "HomeOptionsTblCell"
        var cell: HomeOptionsTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeOptionsTblCell
        if (cell == nil)
        {
            let nib:Array<Any>!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                nib = Bundle.main.loadNibNamed("HomeOptionsTblCell_AR", owner: nil, options: nil)!
            }
            else
            {
                nib = Bundle.main.loadNibNamed("HomeOptionsTblCell", owner: nil, options: nil)! as [Any]
            }
            cell = nib[0] as? HomeOptionsTblCell
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = UIColor.clear
        }
        
        if appDelegate.arrAllHomeCategory.count > 0
        {
            if indexPath.row == 0
            {
                cell?.lblHomeOptions.text = "Groups"
                cell?.imgOptions.image = UIImage.init(named: "group.png")
                
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    cell?.lblHomeOptions.text = "المجموعات"
                }
            }
            else if indexPath.row == 1
            {
                cell?.lblHomeOptions.text = "Search With Discount"
                cell?.imgOptions.image = UIImage.init(named: "search_icon_main.png")

                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    cell?.lblHomeOptions.text = "البحث بخصم"
                }
            }
            else
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    cell?.lblHomeOptions.text = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as AnyObject).object(forKey: "Cat_ar") as? String
                }
                else
                {
                    cell?.lblHomeOptions.text = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as AnyObject).object(forKey: kCatName) as? String
                }
                
                
                let imgUrl = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "image")
                
                cell?.imgOptions.sd_addActivityIndicator()
                let url = URL.init(string: "\(imgUrl!)")
                cell?.imgOptions.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgOptions.sd_removeActivityIndicator()
                })
            }
        }
        
        cell?.viewCellBG.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        cell?.viewCellBG.layer.borderWidth = 1.0
        cell?.viewCellBG.layer.cornerRadius = 25.0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.view.endEditing(true)
        
        if indexPath.row == 0
        {
            let Group: GroupScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                Group  = GroupScreen(nibName: "GroupScreen_Arabic",bundle:nil)
            }
            else
            {
                Group  = GroupScreen(nibName: "GroupScreen",bundle:nil)
            }
            self.navigationController?.pushViewController(Group, animated: true)
        }
        else if indexPath.row == 1
        {
            let Map: MapViewController!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                Map  = MapViewController(nibName: "MapViewController_AR",bundle:nil)
                Map.strFromHome = "البحث بخصم"
            }
            else
            {
                Map  = MapViewController(nibName: "MapViewController",bundle:nil)
                Map.strFromHome = "Search With Discount"
            }
            Map.categoryName = "Search With Discount"
            self.navigationController?.pushViewController(Map, animated: true)
        }
        else
        {
            let Map: MapViewController!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                Map  = MapViewController(nibName: "MapViewController_AR",bundle:nil)
                Map.strFromHome = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: "Cat_ar") as! String
            }
            else
            {
                Map  = MapViewController(nibName: "MapViewController",bundle:nil)
                Map.strFromHome = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: kCatName) as! String
            }
            Map.categoryName = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as! NSDictionary).object(forKey: kCatName) as! String
            Map.categoryID = (appDelegate.arrAllHomeCategory.object(at: indexPath.row - 2) as! NSDictionary).valueForNullableKey(key: kCatID)
            self.navigationController?.pushViewController(Map, animated: true)
        }
        
    }
    // MARK:- updateProfile API Integration.................
    func getProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        }
        
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
        getallApiResultwithGetMethod(strMethodname: kMethodGetProfile, Details: self.getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        let arrProfileData = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                        print("self.arrProfileData",arrProfileData)
                        
                        UserDefaults.standard.setUserDetail(arrProfileData)

                        let dic = NSMutableDictionary()
                        
                        let imgUrl = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_avatar")
                        let strFullName = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: kFullName) as! String
                        
                        let strSuperKey = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "super_user") as! String
                        
                        if let user_cat_id = (arrProfileData.object(at: 0) as? NSDictionary)?.object(forKey: "user_cat_id") as? String
                        {
                            dic.setObject(user_cat_id, forKey: "user_cat_id" as NSCopying)
                            UserDefaults.standard.set(user_cat_id, forKey: "catID")
                        }
                        
                        if let cat_parent_id = (arrProfileData.object(at: 0) as? NSDictionary)?.object(forKey: "cat_parent_id") as? String
                        {
                            UserDefaults.standard.setParentCategory(cat_parent_id)
                            dic.setObject(cat_parent_id, forKey: "cat_parent_id" as NSCopying)
                        }
                        
                        if let show_subscription = (arrProfileData.object(at: 0) as? NSDictionary)?.object(forKey: "show_subscription") as? Int
                        {
                            UserDefaults.standard.isAppointmentFeatureActive(show_subscription)
                        }
                        
                        
                        if let is_appointment_enable = (arrProfileData.object(at: 0) as? NSDictionary)?.object(forKey: "is_appointment_enable") as? String
                        {
                            UserDefaults.standard.isAppointmentActive(is_appointment_enable)
                            dic.setObject(is_appointment_enable, forKey: "is_appointment_enable" as NSCopying)
                        }
                        
                        if let hospital_name = (arrProfileData.object(at: 0) as? NSDictionary)?.object(forKey: "hospital_name") as? String
                        {
                            UserDefaults.standard.setHospitalName(hospital_name)
                            dic.setObject(hospital_name, forKey: "hospital_name" as NSCopying)
                        }
                                                
                        dic.setObject(imgUrl!, forKey: "profileImage" as NSCopying)
                        dic.setObject(strFullName, forKey: kFullName as NSCopying)
                        dic.setObject(strSuperKey, forKey: "super_user" as NSCopying)
                        
                        UserDefaults.standard.set(strFullName, forKey: kFullName)
                        
                        UserDefaults.standard.set(imgUrl!, forKey: "profileImage")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserUpdateSideMenu"), object: nil, userInfo: dic as? [AnyHashable : Any])
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
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        }
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
