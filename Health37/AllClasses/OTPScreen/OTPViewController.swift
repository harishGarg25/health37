//
//  OTPViewController.swift
//  Health37
//
//  Created by RamPrasad-IOS on 10/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit


class OTPViewController: UIViewController, UITextFieldDelegate {
    ///All IBoutlets
    @IBOutlet var txtOTP1: UITextField!
    @IBOutlet var viewOTP1BG: UIView!
    var strFromForgot = ""
    @IBOutlet var btnVerify: UIButton!
    @IBOutlet var btnResendOtp: UIButton!
    
    @IBOutlet var toolBar: UIToolbar!
    
    var dicUserInfo = NSMutableDictionary()
    
    @IBOutlet var lblHeaderTitle: UILabel!
    @IBOutlet var lblOTPSendMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("dicUserInfo",dicUserInfo)
        txtOTP1.keyboardType = .numberPad
        txtOTP1.inputAccessoryView = toolBar
        
        self.appDelegate.checkLocationGetPermission()
        
        self.viewsCornerRadius()
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            lblHeaderTitle.text = "Otp".localized
            lblOTPSendMsg.text = "SMS Verification code has been sent to your registered mobile number".localized
            txtOTP1.placeholder = "ENTER VERIFICATION CODE".localized
            
            btnVerify.setTitle("VERIFY".localized, for: .normal)
            btnResendOtp.setTitle("RESEND OTP".localized, for: .normal)
            
        }
        
    }
    
    ///CornerRadius
    func viewsCornerRadius()
    {
        btnVerify.layer.cornerRadius = 23.0
        btnVerify.layer.borderWidth = 1.0
        btnVerify.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        viewOTP1BG.layer.cornerRadius = 23.0
        viewOTP1BG.layer.borderWidth = 1.0
        viewOTP1BG.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        
        //  self.navigationBarWithBackButton(strTitle: "Add an item", leftbuttonImageName: "Back")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Check Login Validation................
    func CheckValidation() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtOTP1.text == ""
        {
            isGo = false
            errorMessage = kEnterOTPNumberError.localized
        }
        else if (txtOTP1.text!.count < 6)
        {
            isGo = false
            errorMessage = kEnterOTPLengthError.localized
        }
        
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage.localized)
        }
        
        return isGo
    }
    
    // MARK: - UIButtionsMethod
    ///method Go Back
    func CheckUserParams() -> NSMutableDictionary
    {
        let strCountyCode = dicUserInfo.object(forKey: kCountrycode)as! String
        let strMobileNumbe = dicUserInfo.object(forKey: kPhoneNumber)as! String
        let strEmail = dicUserInfo.object(forKey: kEmail) as! String
        let dictUser = NSMutableDictionary()
        dictUser.setObject(strCountyCode, forKey: kCountrycode as NSCopying)
        dictUser.setObject(1, forKey: kResend as NSCopying)
        dictUser.setObject(strMobileNumbe,forKey:kPhoneNumber as NSCopying)
        dictUser.setObject(strEmail,forKey: kEmail as NSCopying)
        return dictUser
        
        
    }
    @IBAction func methodResendOTP(_ sender: Any)
    {
        showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodCheckUser, Details: CheckUserParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    print("Result : \(responseData!)")
                    self.hideActivity()
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
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
    
    @IBAction override func methodBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    ///Method KeyPad Done
    @IBAction func btnKeyPadDone(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    ////Method Verify
    @IBAction func methodVerify(_ sender: Any)
    {
        if CheckValidation()
        {
            DispatchQueue.main.async
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        
                        self.performSelector(inBackground: #selector(self.methodSignUPUser), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
            }
        }
    }
    
    // MARK: - TextFieldMethod
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text == "" && string == " ")
        {            return false
        }
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        if (textField == txtOTP1)
        {
            return newLength > 6 ? false : true
        }
        return true
    }
    
    @objc func methodSignUPUser()
    {
        if self.dicUserInfo.object(forKey: kSocialId) == nil
        {
            dicUserInfo.setObject("", forKey: "social_id" as NSCopying)
            dicUserInfo.setObject("", forKey: "social_type" as NSCopying)
        }
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dicUserInfo.setObject("ar", forKey: kDefaultLanguage as NSCopying)
        }
        else
        {
            dicUserInfo.setObject("en", forKey: kDefaultLanguage as NSCopying)
        }
        let otp = txtOTP1.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        dicUserInfo.setObject(otp!, forKey: kPin as NSCopying)
        var StrToken = "simulator"
        if UserDefaults.standard.object(forKey: kDeviceToken) != nil {
            
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        dicUserInfo.setObject(StrToken, forKey: kDeviceToken as NSCopying)
        dicUserInfo.setObject(kDeviceName, forKey: kDeviceType as NSCopying)
        
        if self.appDelegate.currentLocation != nil
        {
            let strLat = "\(appDelegate.currentLocation.coordinate.latitude)"
            let  strLan = "\(appDelegate.currentLocation.coordinate.longitude)"
            
            dicUserInfo.setObject(strLat, forKey: kLatitude as NSCopying)
            dicUserInfo.setObject(strLan, forKey: kLongitude as NSCopying)
        }
        else
        {
            dicUserInfo.setObject("0.00", forKey: kLatitude as NSCopying)
            dicUserInfo.setObject("0.00", forKey: kLongitude as NSCopying)
        }
        
        getallApiResultwithGetMethod(strMethodname: kMethodSignUp, Details: self.dicUserInfo) { (responseData, error) in
            print("dicUserInfo",self.dicUserInfo)
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                        
                        print("Result : \(responseData!)")
                        
                        // self.appDelegate.saveCurrentUser(dictResult: responseData?.object(forKey: kUserSavedDetails) as! NSDictionary)
                        //  self.appDelegate.health37UserInfo = self.appDelegate.getloginUser()
                        
                        let arrUserDtals =  responseData?.object(forKey: kUserSavedDetails) as! NSArray
                        let userID = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kUserID)
                        let userFullName = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kFullName)
                        let userName = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kUsername)
                        let userEmailID = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kEmailGet)
                        
                        UserDefaults.standard.set(userFullName, forKey: kFullName)
                        UserDefaults.standard.set(userName, forKey: kUsername)
                        UserDefaults.standard.set(userEmailID, forKey: kEmailGet)
                        
                        UserDefaults.standard.set("Yes", forKey: kLoginCheck)
                        UserDefaults.standard.set(userID, forKey: kUserID)
                        
                        //self.appDelegate.performSelector(inBackground: #selector(self.appDelegate.methodAddDeviceAPI), with: nil)
                        self.appDelegate.methodAddDeviceAPI()
                        self.appDelegate.ShowMainviewController()
                        
                    }
                    else
                    {
                        print("Result : \(responseData!)")
                        
                        self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
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
