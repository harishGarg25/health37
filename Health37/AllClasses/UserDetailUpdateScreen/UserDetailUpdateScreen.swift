//
//  UserDetailUpdateScreen.swift
//  Health37
//
//  Created by Ramprasad on 14/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class UserDetailUpdateScreen: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtThinking: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtClinic: UITextField!
    @IBOutlet var txtSubClinic: UITextField!
    @IBOutlet var btnUpdate: UIButton!
    @IBOutlet var btnChangePassword: UIButton!
    
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPass: UITextField!
    @IBOutlet var scrollingBar: UIScrollView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet var viewChangePassPopup: UIView!
    @IBOutlet var btnSubmit: UIButton!
    ///IBoutlets PickerView
    @IBOutlet var pickerHealth: UIPickerView!
    @IBOutlet var viewHeader: UIView!

    //Array
    var isSltedTextF : Bool = true
    
    var categoryID = String()
    var subcategoryID = String()

    var  arrSubCategory = NSMutableArray()
    
    @IBOutlet var viewSubcategoryBG: UIView!

    @IBOutlet var viewBottomBtns: UIView!
    
    @IBOutlet var lblHeaderChangePass: UILabel!
    
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!

    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!

    
    @IBOutlet var txtViewYourSelf: SZTextView!
    var strYourSelf = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        print("CatID",categoryID)
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true

        btnUpdate.layer.cornerRadius = 20.0
        btnUpdate.layer.borderWidth = 1.0
        btnUpdate.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor

        btnChangePassword.layer.cornerRadius = 20.0
        btnChangePassword.layer.borderWidth = 1.0
        btnChangePassword.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor

        txtClinic.inputAccessoryView = toolBar
        txtClinic.inputView = pickerHealth
        txtSubClinic.inputAccessoryView = toolBar
        txtSubClinic.inputView = pickerHealth
        pickerHealth.backgroundColor = UIColor.white
        UserDefaults.standard.setValue(strYourSelf, forKey: "user_brief")
        
        self.userInformationUpdate()
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
           // lblHeaderChangePass.text = "CHANGE PASSWORD".localized

            txtUserName.placeholder = "Name".localized
            txtThinking.placeholder = "Cross Thing".localized
            
            txtEmail.placeholder = "Email".localized
            txtClinic.placeholder = "السمعيات".localized
            txtSubClinic.placeholder = "عضلات قلبية".localized
            
            txtViewYourSelf.placeholderString = "Write something about yourself...".localized
            txtPassword.placeholder = "Old Password".localized
            txtNewPassword.placeholder = "New Password".localized
            txtConfirmPass.placeholder = "Confirm Password".localized

            btnCancel.setTitle("CANCEL".localized, for: .normal)
            btnSubmit.setTitle("SUBMIT".localized, for: .normal)
            
           // btnChangePassword.setTitle("CHANGE PASSWORD".localized, for: .normal)
            btnUpdate.setTitle("UPDATE".localized, for: .normal)
            
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

    
    func userInformationUpdate()
    {
        txtThinking.text = UserDefaults.standard.object(forKey: kUsername) as? String
        txtUserName.text = UserDefaults.standard.object(forKey: kFullName) as? String

        txtEmail.text = UserDefaults.standard.object(forKey: kEmailGet) as? String
        txtViewYourSelf.text = UserDefaults.standard.object(forKey: "user_brief") as? String

        txtClinic.text =  UserDefaults.standard.object(forKey:"catName") as? String
        txtSubClinic.text =  UserDefaults.standard.object(forKey:"subCatName") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {

        if UserDefaults.standard.object(forKey: "catName") != nil
        {
            if UserDefaults.standard.object(forKey: "subCatName") == nil
            {
                self.categoryID = UserDefaults.standard.object(forKey:"catID")  as! String
                print("categoryID",categoryID)
                
                self.viewSubcategoryBG.isHidden = true
                self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.txtClinic.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
            }
            else
            {
            }
        }

        self.navigationController?.isNavigationBarHidden = false
//        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)

       // self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "back-white")
        self.navigationItem.titleView = viewHeader
        
        self.navigationItem.hidesBackButton = true

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "white_back")
            }
        }
    }
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - UITextfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField.tag == 11
        {
            isSltedTextF = true

            reloadPickerMethod()
        }
        else if textField.tag == 12
        {
            isSltedTextF = false
            if UserDefaults.standard.object(forKey: "catID") != nil//"subCatName") != nil
            {
                self.categoryID = UserDefaults.standard.object(forKey:"catID")  as! String
                print("categoryID",categoryID)
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
            }

          //  reloadPickerMethod()

        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text == "" && string == " ")
        {            return false
        }
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        if (textField == txtPassword) || (textField == txtNewPassword) || (textField == txtConfirmPass)
        {
            return newLength > kPasswordLength ? false : true
        }
        
        return true
    }
    // MARK: - UITextViewMethods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (textView.text == "" && text == " ") ||  (textView.text == "" && text == "/n")//(textView.text == "" && text == " ")
        {
            return false
        }
        return true
    }

    func reloadPickerMethod() {
        
        pickerHealth.selectedRow(inComponent: 0)
        pickerHealth.selectRow(0, inComponent: 0, animated: false)
        pickerHealth.reloadAllComponents()
    }

    // MARK:- Check Login Validation................
    func CheckValidation() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtPassword.text == ""
        {
            isGo = false
            errorMessage = kEnterPasswordError.localized
        }
        else if txtNewPassword.text == ""
        {
            isGo = false
            errorMessage = kEnterNewPassError.localized
        }
        else if (txtNewPassword.text!.count < kPasswordLengthMin)
        {
            isGo = false
            errorMessage = kPasswordAcceptableLengthError.localized
        }
        else if txtConfirmPass.text == ""
        {
            isGo = false
            errorMessage = kEnterConfirmPasswordError.localized
        }
        else if txtNewPassword.text != txtConfirmPass.text
        {
            isGo = false
            errorMessage = kPasswordsMatchingError.localized
        }

        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
    }
    
    func CheckValidationUser() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtUserName.text == ""
        {
            isGo = false
            errorMessage = kEnterFullnameError.localized
        }
        else if txtThinking.text == ""
        {
            isGo = false
            errorMessage = kEnterUsernameError.localized
        }

        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
    }

    // MARK: - UIButtonsMethod
    ////Method Open Settings
    @IBAction func methodSetting(_ sender: Any)
    {
        self.menuContainerViewController.toggleRightSideMenuCompletion
            { () -> Void in
        }
    }

    @IBAction override func methodBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func methodUpdateProfile(_ sender: Any)
    {
          self.view.endEditing(true)
        if CheckValidationUser()
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodUpdateProfileApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
            }
        }
    }
    @IBAction func methodChangePassword(_ sender: Any)
    {
        txtPassword.text = ""
        txtConfirmPass.text = ""
        txtNewPassword.text = ""

          self.view.endEditing(true)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(viewChangePassPopup)
        
        
        viewChangePassPopup.frame = window.frame
    }
    @IBAction func methodCancelSubmit(_ sender: UIButton)
    {
          self.view.endEditing(true)
        if sender.tag == 2
        {
            if CheckValidation()
            {
                if appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.methodChangePasswordAPI), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
                }
            }
        }
        else if sender.tag == 0
        {
            viewChangePassPopup.removeFromSuperview()
        }
    }
    
    @IBAction func methodTimeLine(_ sender: Any)
    {
        let Timel: TimelineScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Timel  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
        }
        else
        {
            Timel  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
        }
        Timel.strTabbarClick = "FromTimeLine"
        self.navigationController?.pushViewController(Timel, animated: true)
    }
    @IBAction func methodNotification(_ sender: Any)
    {
        let Timel: TimelineScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Timel  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
        }
        else
        {
            Timel  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
        }
        Timel.strTabbarClick = "FromNotification"
        self.navigationController?.pushViewController(Timel, animated: true)
    }
    @IBAction func methodInbox(_ sender: Any)
    {
        let Timel: TimelineScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Timel  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
        }
        else
        {
            Timel  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
        }
        Timel.strTabbarClick = "FromInbox"
        self.navigationController?.pushViewController(Timel, animated: true)
    }

    //All Health Related Picker done
    @IBAction func methodPickerDone(_ sender: Any)
    {
        self.view.endEditing(true)

        let temp = pickerHealth.selectedRow(inComponent: 0)
        if isSltedTextF == true
        {
            isSltedTextF = false
            print("Category", appDelegate.arrAllCategory)
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtClinic.text = (appDelegate.arrAllCategory.object(at: temp) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtClinic.text = (appDelegate.arrAllCategory.object(at: temp) as AnyObject).object(forKey: kCatName) as? String
            }
            
            UserDefaults.standard.set(txtClinic.text!, forKey: "catName")

            categoryID = (appDelegate.arrAllCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            UserDefaults.standard.set(categoryID, forKey: "catID")

            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
        }
        else if isSltedTextF == false
        {
            isSltedTextF = true
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtSubClinic.text = (arrSubCategory.object(at: temp) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtSubClinic.text = (arrSubCategory.object(at: temp) as AnyObject).object(forKey: kCatName) as? String
            }
            self.categoryID = (arrSubCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            
           // UserDefaults.standard.set(categoryID, forKey: "catID")

            UserDefaults.standard.set(txtSubClinic.text!, forKey: "subCatName")
        }
        
    }
    //Picker Cancel
    @IBAction func methodPickerCancel(_ sender: Any)
    {
        self.view.endEditing(true)
    }

    // MARK: - PikcerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if isSltedTextF == true
        {
            if appDelegate.arrAllCategory.count > 0
            {
                return appDelegate.arrAllCategory.count
            }
            return 0
        }
        else
        {
            if arrSubCategory.count > 0
            {
                return arrSubCategory.count
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if isSltedTextF == true
        {
            if appDelegate.arrAllCategory.count > 0
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    return  (appDelegate.arrAllCategory.object(at: row) as AnyObject).object(forKey: "Cat_ar") as? String
                }
                else
                {
                    return  (appDelegate.arrAllCategory.object(at: row) as AnyObject).object(forKey: kCatName) as? String
                }
            }
            return nil
        }
        else
        {
            if arrSubCategory.count > 0
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    return  (arrSubCategory.object(at: row) as AnyObject).object(forKey: "Cat_ar") as? String
                }
                else
                {
                    return  (arrSubCategory.object(at: row) as AnyObject).object(forKey: kCatName) as? String
                }
            }
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    }

    // MARK:- CheckUser API Integration................
    func changePassParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(txtPassword.text!, forKey: kCurrentPassword as NSCopying)
        dictUser.setObject(txtNewPassword.text!, forKey: kNewPassword as NSCopying)

        return dictUser
    }

 @objc func methodChangePasswordAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodChangePassword, Details: changePassParams()) { (responseData, error) in
            
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("Result : \(responseData!)")
                        self.viewChangePassPopup.removeFromSuperview()
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            self.onShowAlertController(title: "Error" , message: "يتم تحديث كلمة المرور.")
                        }
                        else
                        {
                          //  self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                        }
                        
                    }
                    else
                    {
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

    // MARK:- Get Child Category API Integration.................
    func childCategoryParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(categoryID, forKey: kParentID as NSCopying)
        return dictUser
    }
    
    @objc func methodGetCategoryApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetChildCategory, Details: self.childCategoryParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()

            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)
                    self.arrSubCategory = (responseData?.object(forKey: "cat_data")as!NSArray).mutableCopy() as! NSMutableArray
                    
                    if self.arrSubCategory.count > 0
                    {
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            self.txtSubClinic.text = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: "Cat_ar") as? String
                        }
                        else
                        {
                            self.txtSubClinic.text = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: kCatName) as? String
                        }
                        if self.isSltedTextF == false
                        {
                            self.categoryID = (self.arrSubCategory.object(at: 0) as! NSDictionary).valueForNullableKey(key: kCatID)
                            self.subcategoryID = (self.arrSubCategory.object(at: 0) as! NSDictionary).valueForNullableKey(key: kCatID)

                        }
                        
                 UserDefaults.standard.set(self.subcategoryID, forKey: "catSubID")

                 UserDefaults.standard.set(self.txtSubClinic.text!, forKey: "subCatName")
                        
                        self.reloadPickerMethod()
                        
                        self.viewSubcategoryBG.isHidden = false
                               self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.viewSubcategoryBG.frame.origin.y) + 58, width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
                    }
                    else
                    {
                        UserDefaults.standard.removeObject(forKey: "subCatName")
                        self.viewSubcategoryBG.isHidden = true
                          self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.txtClinic.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
                    }
                }
                else
                {
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
                }
            }
        }
    }

    // MARK:- updateProfile API Integration.................
    func updateProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(self.txtUserName.text!, forKey: kName as NSCopying)
        dictUser.setObject(self.txtEmail.text!, forKey: kEmail as NSCopying)
        dictUser.setObject(self.txtThinking.text!, forKey: kUsername as NSCopying)
        dictUser.setObject(self.txtViewYourSelf.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: kUserBrief as NSCopying)
        
        if UserDefaults.standard.object(forKey: "catName") != nil
        {
            if UserDefaults.standard.object(forKey: "subCatName") == nil
            {
                self.categoryID = UserDefaults.standard.object(forKey:"catID")  as! String
                print("categoryID",categoryID)
                
                self.viewSubcategoryBG.isHidden = true
                self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.txtClinic.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
            }
            else
            {
                
                if UserDefaults.standard.object(forKey: "catSubID") != nil
                {
                  //  categoryID = UserDefaults.standard.object(forKey:"catSubID")  as! String
                }
                
           //UserDefaults.standard.set(self.subcategoryID, forKey: "catSubID")

                //  self.categoryID = UserDefaults.standard.object(forKey:"catID")  as! String
                //   print("categoryID",categoryID)
            }
        }
        
     //   UserDefaults.standard.set(categoryID, forKey: "catID")
        dictUser.setObject(categoryID, forKey: kUserCat as NSCopying)

        return dictUser
    }
    
    @objc func methodUpdateProfileApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodUpdateProfile, Details: self.updateProfileParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()

            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    let dicData = responseData?.object(forKey: "REQUEST") as! NSDictionary
                    print("dicData",dicData)
                    let userFullName = dicData.valueForNullableKey(key: kName)
                    let userName = dicData.valueForNullableKey(key: kUsername)
                    self.txtViewYourSelf.text = dicData.valueForNullableKey(key: "user_brief")
                    
                    UserDefaults.standard.set(userFullName, forKey: kFullName)
                    UserDefaults.standard.set(userName, forKey: kUsername)
                    UserDefaults.standard.set(dicData.valueForNullableKey(key: "user_brief"), forKey: "user_brief")
                    
                    let dic = NSMutableDictionary()
                    dic.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                    dic.setObject(self.txtUserName.text!, forKey: kName as NSCopying)
                    dic.setObject(self.txtEmail.text!, forKey: kEmail as NSCopying)
                    dic.setObject(self.txtThinking.text!, forKey: kUsername as NSCopying)
                    dic.setObject(self.txtViewYourSelf.text!, forKey: kUserBrief as NSCopying)
                    dic.setObject(self.categoryID, forKey: kUserCat as NSCopying)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserProfileUpdate"), object: nil, userInfo: dic as? [AnyHashable : Any])
                    

                    let alertController = UIAlertController(title: "", message: "User profile updated".localized, preferredStyle: .alert)
                    // Initialize Actions
                    let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(yesAction)
                    

                    // Present Alert Controller
                    self.present(alertController, animated: true, completion: nil)
                    


                }
                else
                {
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
                }            }
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