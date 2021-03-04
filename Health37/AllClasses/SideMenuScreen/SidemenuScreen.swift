//
//  SidemenuScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
//import AFNetworking
class SidemenuScreen: UIViewController , UITableViewDelegate , UITableViewDataSource , UIAlertViewDelegate {
   
    //IBOutlets
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var tbl_menu:  UITableView!

     ///NSArray For Title & Images
    var arr_img  = NSMutableArray()
    var arr_tittle = NSMutableArray()
    var userType = String()

    @IBOutlet var btnOk: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var viewLogoutPopupBG: UIView!
    @IBOutlet var viewLogoutPopup: UIView!
    @IBOutlet var lblPopupTitle: UILabel!
    @IBOutlet var lblSureLogout: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewLogoutPopupBG.layer.cornerRadius = 2.0
        tbl_menu.tableFooterView = UIView.init(frame: CGRect.zero)
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userProfileUpdate(noti:)), name: NSNotification.Name(rawValue: "UserUpdateSideMenu"), object: nil)
        
        self.updateUserDetails()
        self.updateHomeScreenData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateHomeScreenData), name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)

   }
    
    @objc func updateHomeScreenData()
    {
        self.arr_img =  ["homeW.png","timelineW.png","profile.png","addFriend.png","contact.png", "logout.png"]
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.arr_tittle = ["الصفحة الرئيسية", "الجدول الزمني", "الملف الشخصي", "أصدقاء / اضافة اصدقاء", "اتصل بنا", "الخروج"]
            if UserDefaults.standard.getAppointmentFeatureActive == "1"
            {
                if userType != "-111"
                {
                    if UserDefaults.standard.getAppointmentStatus == "1"
                    {
                        self.arr_tittle.insert("المواعيد", at: 3)
                        self.arr_img.insert("appointment-book.png", at: 3)
                        self.arr_tittle.insert("إدارة الخصم (اختياري)", at: 4)
                        self.arr_img.insert("coupon.png", at: 4)
                    }else
                    {
                        self.arr_tittle.insert("تمكين المواعيد", at: 3)
                        self.arr_img.insert("appointment-book.png", at: 3)
                    }
                }
                else
                {
                    self.arr_tittle.insert("مواعيدي", at: 3)
                    self.arr_img.insert("appointment-book.png", at: 3)
                }
                self.arr_tittle.insert("الاشتراك", at: 5)
                self.arr_img.insert("subscription.png", at: 5)
            }
            lblSureLogout.text = "Are you sure, you want to Logout?".localized
            btnOk.setTitle("OK".localized, for: .normal)
            btnCancel.setTitle("CANCEL".localized, for: .normal)
        }
        else
        {
            self.arr_tittle = ["Home", "Timeline", "Profile", "Friends / Add Friends", "Contact Us", "Logout"]
            if UserDefaults.standard.getAppointmentFeatureActive == "1"
            {
                if userType != "-111"
                {
                    if UserDefaults.standard.getAppointmentStatus == "1"
                    {
                        self.arr_tittle.insert("Appointments", at: 3)
                        self.arr_img.insert("appointment-book.png", at: 3)
                        self.arr_tittle.insert("Manage Discount (elective)", at: 4)
                        self.arr_img.insert("coupon.png", at: 4)
                    }else
                    {
                        self.arr_img.insert("appointment-book.png", at: 3)
                        self.arr_tittle.insert("Enable Appointment Feature", at: 3)
                    }
                }else
                {
                    self.arr_tittle.insert("My Appointments", at: 3)
                    self.arr_img.insert("appointment-book.png", at: 3)
                }
                self.arr_tittle.insert("Subscription", at: 5)
                self.arr_img.insert("subscription.png", at: 5)
            }
        }
        tbl_menu.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func userProfileUpdate(noti: Notification)
    {
        let dicData = noti.userInfo! as NSDictionary
     
       // lbl_userName.text = dicData.object(forKey: kFullName)as? String
        let imgUrl = dicData.object(forKey: "profileImage")as? String
        self.imgUser.sd_addActivityIndicator()
        let url = URL.init(string: "\(imgUrl!)")
        print("imgUrl&&&URL", imgUrl!)
        self.imgUser.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            self.imgUser.sd_removeActivityIndicator()
        })

        print("DicData", dicData)
        if let catID = dicData.object(forKey: "user_cat_id") as? String
        {
            userType  = catID
            UserDefaults.standard.setUserType(userType != "-111" ? "doctor" : "patient")
        }
        if dicData.object(forKey: "super_user") as? String == "0"
        {
            lbl_userName.text  = dicData.object(forKey: kFullName) as? String
        }
        else
        {
            let strWorkingPost = dicData.object(forKey: kFullName) as? String
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "super_user_ic_badge.png")
            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
            let attachmentStr = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
            myString.append(attachmentStr)
            lbl_userName.attributedText = myString
        }
        self.updateHomeScreenData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {

    }
    
    func updateUserDetails()
    {
        if UserDefaults.standard.object(forKey: kFullName) as? String != ""
        {
            lbl_userName.text = UserDefaults.standard.object(forKey: kFullName) as? String
        }
         if UserDefaults.standard.object(forKey: "super_user") as? String != ""
         {
            if UserDefaults.standard.object(forKey: "super_user") as? String == "1"
            {
                let strUserName = UserDefaults.standard.object(forKey: kFullName) as? String
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "super_user_ic_badge.png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attachmentStr = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strUserName!) as String)
                myString.append(attachmentStr)
                lbl_userName.attributedText = myString
            }
         }
        if UserDefaults.standard.object(forKey: "profileImage") != nil
        {
            let imgUrl = UserDefaults.standard.object(forKey: "profileImage")
            self.imgUser.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
            print("imgUrl&&&URL", imgUrl!)
            self.imgUser.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.imgUser.sd_removeActivityIndicator()
            })
        }
    }
    
   // MARK : UIButtonsMethod
    @IBAction func methodCancelOK(_ sender: UIButton)
    {
        self.viewLogoutPopup.removeFromSuperview()
        if sender.tag == 1
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodLogoutUser), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
        
    }
    @IBAction func methodSideMenuClose(_ sender: Any)
    {
        self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
        })
        
    }
    ///method Edit Profile
    @IBAction func methodEditProfile(_ sender: Any)
    {
//        let demoController = ProfileViewController(nibName: "ProfileViewController",bundle: nil)
//        var navigationController = UINavigationController()
//        navigationController = self.menuContainerViewController.centerViewController as! UINavigationController
//
//        let controllers:NSArray = NSArray().adding(demoController) as NSArray
//        navigationController.viewControllers = controllers as! [UIViewController]
//        self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
//        })
    }

   // MARK : UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr_tittle.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cellIdentifier:String = "CustomFields"
        var cell : SideMenuCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SideMenuCell
        if (cell == nil)
        {
            let nib:Array<Any>!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                nib = Bundle.main.loadNibNamed("SideMenuCell_AR", owner: nil, options: nil)!
            }
            else
            {
                nib = Bundle.main.loadNibNamed("SideMenuCell", owner: nil, options: nil)! as [Any]
            }

            cell = nib[0] as? SideMenuCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
            
        }
        cell?.lbl_Name.text = (arr_tittle.object(at: indexPath.row)) as? String
        cell?.img_icon.image = UIImage(named: arr_img.object(at: indexPath.row) as! String)

        return cell!

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let demoController: HomeViewController!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                demoController  = HomeViewController(nibName: "HomeViewController_Arabic",bundle:nil)
            }
            else
            {
                demoController  = HomeViewController(nibName: "HomeViewController",bundle:nil)
            }

            var navigationController = UINavigationController()
            navigationController = self.menuContainerViewController.centerViewController as! UINavigationController

            let controllers:NSArray = NSArray().adding(demoController) as NSArray
            navigationController.viewControllers = controllers as! [UIViewController]
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in

            })
        }
        else if indexPath.row == 1
        {
            let demoController: TimelineScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                demoController  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
            }
            else
            {
                demoController  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
            }
            demoController.strFromHome = "FromSideMenu"
            demoController.strTabbarClick = "FromTimeLine"
            var navigationController = UINavigationController()
            navigationController = self.menuContainerViewController.centerViewController as! UINavigationController

            let controllers:NSArray = NSArray().adding(demoController) as NSArray
            navigationController.viewControllers = controllers as! [UIViewController]
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in

            })
        }else if indexPath.row == 2
        {
            let demoController: ProfileVC!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                demoController  = ProfileVC(nibName: "ProfileVC_AR",bundle:nil)
            } //ProfileVC_Arabic
            else
            {
                demoController  = ProfileVC(nibName: "ProfileVC",bundle:nil)
            }

            var navigationController = UINavigationController()
            navigationController = self.menuContainerViewController.centerViewController as! UINavigationController

            let controllers:NSArray = NSArray().adding(demoController) as NSArray
            navigationController.viewControllers = controllers as! [UIViewController]
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in

            })
        }
        else if (self.arr_img[indexPath.row] as? String ?? "") == "subscription.png"
        {
            let controller = SubscriptionDetailScreen.instantiate(fromAppStoryboard: .Appointment)
            self.navigationController?.pushViewController(controller, animated:true)
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
        }
        else if (self.arr_img[indexPath.row] as? String ?? "") == "addFriend.png"
        {
            let demoController: AddFriendsScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                demoController  = AddFriendsScreen(nibName: "AddFriends_Arabic",bundle:nil)
            }
            else
            {
                demoController  = AddFriendsScreen(nibName: "AddFriendsScreen",bundle:nil)
            }

            var navigationController = UINavigationController()
            navigationController = self.menuContainerViewController.centerViewController as! UINavigationController

            let controllers:NSArray = NSArray().adding(demoController) as NSArray
            navigationController.viewControllers = controllers as! [UIViewController]
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
        }else if (self.arr_img[indexPath.row] as? String ?? "") == "appointment-book.png"
        {
            
            if UserDefaults.standard.cat_parent_id == "4"
            {
                if UserDefaults.standard.getAppointmentStatus == "1"
                {
                    let controller = DoctorListTableViewController.instantiate(fromAppStoryboard: .Appointment)
                    controller.hospitalID = ""
                    self.navigationController?.pushViewController(controller, animated:true)
                }else
                {
                    let controller = PriceSelectionViewController.instantiate(fromAppStoryboard: .Appointment)
                    self.navigationController?.pushViewController(controller, animated:true)
                }
            }else
            {
                if userType != "-111"
                {
                    if UserDefaults.standard.getAppointmentStatus == "1"
                    {
                        let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
                        self.navigationController?.pushViewController(controller, animated:true)
                    }else
                    {
                        let controller = SlotDetailViewController.instantiate(fromAppStoryboard: .Appointment)
                        self.navigationController?.pushViewController(controller, animated:true)
                    }
                }else
                {
                    let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
                    self.navigationController?.pushViewController(controller, animated:true)
                }
            }
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
        }else if (self.arr_img[indexPath.row] as? String ?? "") == "coupon.png"
        {
            let controller = ManageCouponViewController.instantiate(fromAppStoryboard: .Appointment)
            self.navigationController?.pushViewController(controller, animated:true)
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
        }else if (self.arr_img[indexPath.row] as? String ?? "") == "contact.png"
        {
            
            let demoController: ContactUsScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                demoController  = ContactUsScreen(nibName: "ContactUs_Arabic",bundle:nil)
            }
            else
            {
                demoController  = ContactUsScreen(nibName: "ContactUsScreen",bundle:nil)
            }

            var navigationController = UINavigationController()
            navigationController = self.menuContainerViewController.centerViewController as! UINavigationController

            let controllers:NSArray = NSArray().adding(demoController) as NSArray
            navigationController.viewControllers = controllers as! [UIViewController]
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
        }else if indexPath.row == self.arr_tittle.count - 1
        {
            let window = UIApplication.shared.keyWindow!
            window.addSubview(viewLogoutPopup)
            viewLogoutPopup.frame = window.frame
        }
    }


    // MARK:- CheckUser API Integration................
    func logoutUserParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        var StrToken = "simulator"
        
        if UserDefaults.standard.object(forKey: kDeviceToken) != nil {
            
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        
        dictUser.setObject(StrToken, forKey: kDeviceToken as NSCopying)

        return dictUser
    }
    @objc func methodLogoutUser()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodLogout, Details: logoutUserParams()) { (responseData, error) in
            print("logoutUserParams()",self.logoutUserParams())
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    print("Result : \(responseData!)")
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        let alertController = UIAlertController(title: "", message: "Logout Successfully.".localized as String?, preferredStyle: .alert)
                        // Initialize Actions
                        let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                            
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        alertController.addAction(yesAction)
                        
                        // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)

                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                        
                        print("Result : \(responseData!)")
                        
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

}
