//
//  UserDetailUpdateScreen.swift
//  Health37
//
//  Created by Ramprasad on 14/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class UserDetailUpdateScreen: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CountryListViewDelegate {
    
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
    @IBOutlet var txtLandlineCode: UITextField!
    @IBOutlet var scrollingBar: UIScrollView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var viewChangePassPopup: UIView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var pickerHealth: UIPickerView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var hospitalNameTF: UITextField!
    @IBOutlet weak var landlineTextField: UITextField!
    @IBOutlet weak var landlineView: UIView!
    @IBOutlet var viewSubcategoryBG: UIView!
    @IBOutlet var viewBottomBtns: UIView!
    @IBOutlet var lblHeaderChangePass: UILabel!
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    @IBOutlet var lblNotificationCount: UILabel!
    @IBOutlet var viewNotificationCount: UIView!
    @IBOutlet var txtViewYourSelf: SZTextView!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtCountryCode: UITextField!
    
    //Array
    var isSltedTextF : Bool = true
    var isMobileCountryCode : Bool = false
    var categoryID = String()
    var subcategoryID = String()
    var arrSubCategory = NSMutableArray()
    var strYourSelf = ""
    var strCountryName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            
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
            btnUpdate.setTitle("UPDATE".localized, for: .normal)
            
            hospitalNameTF.placeholder = "Hospital/Clinic Name".localized
            landlineTextField.placeholder = "Landline Number".localized
            
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
        
        if let detail = self.getDataInLocal(fileName : "profile_data") as? NSMutableArray
        {
            if let detailDict = detail[0] as? [String : Any]
            {
                txtThinking.text = detailDict[kUsername] as? String
                txtUserName.text = detailDict[kFullName] as? String
                txtEmail.text = detailDict[kEmailGet] as? String
                txtViewYourSelf.text = detailDict["user_brief"] as? String
                txtClinic.text =  detailDict["parent_cat_name"] as? String
                txtSubClinic.text =  detailDict["subcat_en"] as? String
                txtCountryCode.text =  detailDict["country_code"] as? String
                txtMobileNo.text =  detailDict["phone_number"] as? String
                hospitalNameTF.text =  detailDict["hospital_name"] as? String
                categoryID = detailDict["user_cat_id"] as? String ?? ""
                subcategoryID = detailDict["sub_cat_id"] as? String ?? ""
                let landlineNumber =  detailDict["landline_number"] as? String
                let array = landlineNumber?.components(separatedBy: " ")
                if array?.count ?? 0 > 1
                {
                    txtLandlineCode.text = array?[0]
                    landlineTextField.text = array?[1]
                }else
                {
                    landlineTextField.text = array?[0]
                }
                //https://dev.softprodigyphp.in/Health37//services.php?serviceName=payment&amount=200&currency=USD&token=tok_sfjzr6fh4azezbrki6dy6g2mii&language=en&sub_id=1&is_free_sub_applied=0&user_id=2700&package_months=6
                print("categoryID",categoryID)
                self.hospitalNameTF.frame.size.height = categoryID == "4" ? 40 : 0
                hospitalNameTF.isHidden = !(categoryID == "4")
                self.landlineView.frame.size.height = categoryID == "4" ? 40 : 0
                landlineView.isHidden = !(categoryID == "4")
                
                self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.landlineView.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
                
                if txtSubClinic.text?.count == 0
                {
                    self.viewSubcategoryBG.isHidden = true
                    self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.landlineView.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.userInformationUpdate()
        
        self.navigationController?.isNavigationBarHidden = false
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
        if textField.tag == 99
        {
            isMobileCountryCode = true
            self.view.endEditing(true)
            let MainView = CountryListViewController(nibName: "CountryListViewController",delegate: self)
            self.present(MainView!, animated: true, completion: nil)
            return false
        }
        else if textField.tag == 100
        {
            isMobileCountryCode = false
            self.view.endEditing(true)
            let MainView = CountryListViewController(nibName: "CountryListViewController",delegate: self)
            self.present(MainView!, animated: true, completion: nil)
            return false
        }
        else if textField.tag == 11
        {
            isSltedTextF = true
            reloadPickerMethod()
        }
        else if textField.tag == 12
        {
            isSltedTextF = false
            if UserDefaults.standard.object(forKey: "catID") != nil//"subCatName") != nil
            {
                print("categoryID",categoryID)
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text == "" && string == " ")
        {
            return false
        }
        if (textField == landlineTextField)
        {
            if (string == " ")
            {
                return false
            }
        }
        let newLength = textField.text!.count + string.count - range.length
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
    
    // MARK: - CountryPhoneCodePicker Delegate
    func didSelectCountry(_ country: [AnyHashable : Any]!)
    {
        let cou = country as NSDictionary
        if isMobileCountryCode
        {
            txtCountryCode.text = (cou.object(forKey: "dial_code") as! NSString) as String
            strCountryName = (cou.object(forKey: "name") as! NSString) as String
        }else
        {
            txtLandlineCode.text = (cou.object(forKey: "dial_code") as! NSString) as String
        }
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
        else if (txtMobileNo.text?.count)!  <  kMobileNumerLenghtMin
        {
            isGo = false
            errorMessage = kMobileNumLengthError.localized
        }
        else if (landlineTextField.text?.count)!  >  0 && (landlineTextField.text?.count)!  <  kMobileNumerLenghtMin
        {
            isGo = false
            errorMessage = kLandlineNumLengthError.localized
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
            
            categoryID = (appDelegate.arrAllCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            
            hospitalNameTF.text = ""
            self.hospitalNameTF.frame.size.height = categoryID == "4" ? 40 : 0
            hospitalNameTF.isHidden = !(categoryID == "4")
            landlineTextField.text = ""
            self.landlineView.frame.size.height = categoryID == "4" ? 40 : 0
            landlineView.isHidden = !(categoryID == "4")
            
            UserDefaults.standard.set(txtClinic.text!, forKey: "catName")
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
            self.subcategoryID = (arrSubCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            
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
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
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
                                self.subcategoryID = (self.arrSubCategory.object(at: 0) as! NSDictionary).valueForNullableKey(key: kCatID)
                            }
                            
                            UserDefaults.standard.set(self.subcategoryID, forKey: "catSubID")
                            UserDefaults.standard.set(self.txtSubClinic.text!, forKey: "subCatName")
                            
                            self.reloadPickerMethod()
                            
                            self.viewSubcategoryBG.isHidden = false
                            self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.landlineView.frame.origin.y) + 58, width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
                        }
                        else
                        {
                            UserDefaults.standard.removeObject(forKey: "subCatName")
                            self.viewSubcategoryBG.isHidden = true
                            self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.landlineView.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
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
        dictUser.setValue(self.txtCountryCode.text!, forKey: kCountrycode)
        dictUser.setValue(self.txtMobileNo.text!, forKey: kPhoneNumber)
        dictUser.setValue(self.hospitalNameTF.text!, forKey: "hospital_name")
        dictUser.setValue(self.strCountryName, forKey: "User_country")
        var landlineNumber = String()
        if !(txtLandlineCode.text?.isEmpty ?? false)
        {
            if !(landlineTextField.text?.isEmpty ?? false)
            {
                landlineNumber = "\(txtLandlineCode.text ?? "") \(landlineTextField.text ?? "")"
            }
        }else
        {
            landlineNumber = landlineTextField.text ?? ""
        }
        
        dictUser.setValue(landlineNumber, forKey: "landline_number")
        if UserDefaults.standard.object(forKey: "catName") != nil
        {
            if UserDefaults.standard.object(forKey: "subCatName") == nil
            {
                print("categoryID",categoryID)
                
                self.viewSubcategoryBG.isHidden = true
                self.viewBottomBtns.frame = CGRect.init(x: (self.viewBottomBtns.frame.origin.x), y: (self.landlineView.frame.origin.y) + 58 , width: (self.viewBottomBtns.frame.size.width), height: (self.viewBottomBtns.frame.size.height))
            }
        }
        
        dictUser.setObject(categoryID, forKey: kUserCat as NSCopying)
        dictUser.setObject(subcategoryID, forKey: "sub_cat" as NSCopying)
        return dictUser
    }
    
    @objc func methodUpdateProfileApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodUpdateProfile, Details: self.updateProfileParams()) { (responseData, error) in
            DispatchQueue.main.async {
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
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
                        dic.setValue(self.hospitalNameTF.text ?? "", forKey: "hospital_name")
                        dic.setValue(self.landlineTextField.text ?? "", forKey: "landline_number")
                        dic.setValue(self.strCountryName, forKey: "User_country")
                        dic.setValue(self.txtCountryCode.text!, forKey: kCountrycode)
                        
                        getallApiResultwithGetMethod(strMethodname: kMethodGetProfile, Details: self.getProfileParams()) { (responseData, error) in
                            self.hideActivity()
                            if error == nil
                            {
                                DispatchQueue.main.async {
                                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                                    {
                                        let arrProfileData = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                                        print("self.arrProfileData",arrProfileData)
                                        self.saveDataInLocal(fileName : "profile_data" , data : arrProfileData)
                                    }
                                }
                            }
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserProfileUpdate"), object: nil, userInfo: dic as? [AnyHashable : Any])
                        
                        let alertController = UIAlertController(title: "", message: "User profile updated".localized, preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(yesAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else
                    {
                        self.hideActivity()
                        print("responseData",responseData!)
                    }
                }else
                {
                    self.hideActivity()
                }
            }
        }
    }
    
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
