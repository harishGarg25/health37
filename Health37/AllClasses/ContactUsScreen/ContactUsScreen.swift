//
//  ContactUsScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ContactUsScreen: UIViewController, UITextViewDelegate {

    //IBoutlets
    @IBOutlet var viewTxtBG: UIView!
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var txtDescription: SZTextView!
    @IBOutlet var viewHeader: UIView!

    @IBOutlet var viewPopup: UIView!
    @IBOutlet var viewPopupBG: UIView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblNameTitle: UILabel!
    @IBOutlet var lblEmailTitle: UILabel!
    @IBOutlet var lblDescriptionTitle: UILabel!
    
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!

    @IBOutlet var lblHeaderTitle: UILabel!
    
    @IBOutlet var btnOk: UIButton!
    
    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTxtBG.layer.cornerRadius = 10.0
        viewPopupBG.layer.cornerRadius = 2.0
         btnSubmit.layer.cornerRadius = 22.0
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            btnOk.setTitle("Ok".localized, for: .normal)
           // btnSubmit.setTitle("SUBMIT".localized, for: .normal)
            
            txtDescription.placeholderString = "Enter Description here".localized
            lblNameTitle.text = "اسم:"
            lblEmailTitle.text = "البريد الإلكتروني:"
            lblDescriptionTitle.text = "Description".localized
            lblHeaderTitle.text = "CONTACT US".localized
        }

//        if appDelegate.health37UserInfo.strFull_name != ""
//        {
//            lblCompanyName.text = appDelegate.health37UserInfo.strFull_name
//        }
//        else
//        {
            lblCompanyName.text = UserDefaults.standard.object(forKey: kFullName) as? String
  //      }
        if UserDefaults.standard.object(forKey: kEmailGet) as? String != ""
        {
            lblEmail.text = UserDefaults.standard.object(forKey: kEmailGet) as? String
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

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.titleView = viewHeader
//        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
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

//        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
//        {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
//        }
//        else
//        {
//            self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "menu")
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
//        }
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextViewMethods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func CheckValidationUser() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtDescription.text == ""
        {
            isGo = false
            errorMessage = kEnterDescription.localized
        }
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage.localized)
        }
        
        return isGo
    }

    // MARK: - UIButtonsMethod
    ///Settings Screen
    @IBAction func methodPopupOK(_ sender: Any)
    {
        self.viewPopup.removeFromSuperview()
        self.appDelegate.ShowMainviewController()
    }
    
    ///TimeLines
    @IBAction func methodTimeline(_ sender: UIButton)
    {
        self.view.endEditing(true)
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
    @IBAction func methodSubmit(_ sender: Any)
    {
         self.view.endEditing(true)
        if CheckValidationUser()
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodUpdateContactsApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }

    }
    @IBAction func methodNotification(_ sender: UIButton)
    {
        self.view.endEditing(true)
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
        self.view.endEditing(true)
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
    // MARK:- updateProfile API Integration.................
    func updateContactParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(self.lblCompanyName.text!, forKey: kName as NSCopying)
        dictUser.setObject(self.lblEmail.text!, forKey: kEmail as NSCopying)
        dictUser.setObject(self.txtDescription.text!, forKey: "text" as NSCopying)
        return dictUser
    }
    
    @objc func methodUpdateContactsApi()
    {
        
        getallApiResultwithGetMethod(strMethodname: kMethodUpdateContact, Details: self.updateContactParams()) { (responseData, error) in
            print("updateContactParams",self.updateContactParams())
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)
                    let window = UIApplication.shared.keyWindow!

                    window.addSubview(self.viewPopup)
                    self.viewPopup.frame = window.frame
                }
                else
                {
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
                self.hideActivity()
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
