//
//  LoginSignupScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FHSTwitterEngine
import GoogleSignIn

class LoginSignupScreen: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CountryListViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIWebViewDelegate, FHSTwitterEngineAccessTokenDelegate, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    @IBOutlet var lblSeprator_AR: UILabel!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnForgotPass: UIButton!
    @IBOutlet var btnPickerDone: UIBarButtonItem!
    @IBOutlet var btnPickerCancel: UIBarButtonItem!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var sepratorSignIn: UILabel!
    @IBOutlet var sepratorSignUp: UILabel!
    @IBOutlet var btnSignInClick: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var viewSignInBG: UIView!
    @IBOutlet var txtCardiac: UITextField!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblTermsCondition: UILabel!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtEmailSignup: UITextField!
    @IBOutlet var txtPasswordSignup: UITextField!
    @IBOutlet var txtTherapyType: UITextField!
    @IBOutlet var btnSignUpClick: UIButton!
    @IBOutlet var viewSignUPBG: UIView!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var txtCountryCodeLandline: UITextField!
    @IBOutlet var hospitalNameTF: UITextField!
    @IBOutlet weak var landlineTextField: UITextField!
    @IBOutlet weak var landlineView: UIView!
    @IBOutlet var scrollingBar: UIScrollView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var btnTermsConditions: UIButton!
    @IBOutlet var viewSubcategoryBG: UIView!
    @IBOutlet var btnEnglish: UIButton!
    @IBOutlet var btnArebic: UIButton!
    @IBOutlet var lblHeaderForgot: UILabel!
    @IBOutlet var lblTitleEnterEmail: UILabel!
    @IBOutlet var btnCancelForgot: UIButton!
    @IBOutlet var btnSubmitForgot: UIButton!
    @IBOutlet var btnChooseLanguage: UIButton!
    @IBOutlet var pickerHealth: UIPickerView!
    @IBOutlet var viewLanguageBG: UIView!
    @IBOutlet var txtEmailForgotPass: UITextField!
    @IBOutlet var viewForgotPasswordBG: UIView!
    @IBOutlet var imgBackGround: UIImageView!
    @IBOutlet var viewTxtEmailBG: UIView!
    
    var strLanguageSlt = NSString()
    var isSltedTextF : Bool = false
    var isMobileCountryCode : Bool = false
    var categoryID = String()
    var subCategoryID = String()
    var dictSocialDetails = NSMutableDictionary()
    var  arrSubCategory = NSMutableArray()
    var strCountryName = ""
    var strSocialType = ""
    var strTextValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategoryData), name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
        
        strLanguageSlt = "en"
        viewTxtEmailBG.layer.cornerRadius = 22.0
        viewTxtEmailBG.layer.borderWidth = 1.0
        viewTxtEmailBG.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        btnChooseLanguage.layer.cornerRadius = 4.0
        btnChooseLanguage.layer.borderWidth = 1.0
        btnChooseLanguage.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        txtMobileNo.keyboardType = .numberPad
        txtMobileNo.inputAccessoryView = toolBar
        
        txtTherapyType.inputAccessoryView = toolBar
        txtTherapyType.inputView = pickerHealth
        
        txtCardiac.inputAccessoryView = toolBar
        txtCardiac.inputView = pickerHealth
        
        pickerHealth.backgroundColor = UIColor.white
        btnSignInClick.layer.cornerRadius = 20.0
        btnSignUpClick.layer.cornerRadius = 20.0
        btnSignInClick.layer.borderWidth = 1.0
        btnSignInClick.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        btnSignUpClick.layer.borderWidth = 1.0
        btnSignUpClick.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        DispatchQueue.main.async
        {
            self.viewSignUPBG.frame = CGRect.init(x: 0, y: 202, width: self.scrollingBar.frame.size.width, height: 597)
            self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 590)
        }
        
        self.imgBackGround.layer.masksToBounds = true
        self.viewSubcategoryBG.isHidden = true
        self.btnTermsConditions.frame = CGRect.init(x: (self.btnTermsConditions.frame.origin.x), y: (self.landlineView.frame.origin.y) + 56, width: (self.btnTermsConditions.frame.size.width), height: (self.btnTermsConditions.frame.size.height))
        
        self.lblTermsCondition.frame = CGRect.init(x: (self.btnTermsConditions.frame.origin.x), y: (self.landlineView.frame.origin.y) + 56, width: (self.btnTermsConditions.frame.size.width), height: (self.btnTermsConditions.frame.size.height))
        
        self.btnSignUpClick.frame = CGRect.init(x: (self.btnSignUpClick.frame.origin.x), y: (self.btnTermsConditions.frame.origin.y) + 42, width: (self.btnSignUpClick.frame.size.width), height: (self.btnSignUpClick.frame.size.height))
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            lblEmail.text = "Email".localized
            lblHeaderForgot.text = "FORGOT PASSWORD?".localized
            lblTitleEnterEmail.text = "Enter Your Email Address to retrieve Your Password.".localized
            
            lblPassword.text = "Password".localized
            txtName.placeholder = "Name".localized
            txtEmail.placeholder = "Email".localized
            txtPassword.placeholder = "Write here...".localized
            txtEmail.placeholder = "Write here...".localized
            hospitalNameTF.placeholder = "Hospital/Clinic Name".localized
            landlineTextField.placeholder = "Landline Number".localized
            
            txtUserName.placeholder = "User Name".localized
            txtPasswordSignup.placeholder = "Password".localized
            
            txtEmailSignup.placeholder = "Email".localized
            txtTherapyType.placeholder = "Category".localized
            
            txtMobileNo.placeholder = "Mobile No.".localized
            txtCardiac.placeholder = "Sub category".localized
            txtEmailForgotPass.placeholder = "Email".localized
            
            btnForgotPass.setTitle("Forgot Password".localized, for: .normal)
            btnSignIn.setTitle("SIGN IN".localized, for: .normal)
            btnSignUp.setTitle("SIGN UP".localized, for: .normal)
            //  btnChooseLanguage.setTitle("English".localized, for: .normal)
            btnSignUpClick.setTitle("SIGN UP".localized, for: .normal)
            btnSignInClick.setTitle("SIGN IN".localized, for: .normal)
            btnSubmitForgot.setTitle("SUBMIT".localized, for: .normal)
            btnCancelForgot.setTitle("CANCEL".localized, for: .normal)
            
            sepratorSignIn.isHidden = true
            sepratorSignUp.isHidden = true
            
            
            let longString10 = "By signing up, You agree with".localized
            let longestWord2 = "Terms and Conditions".localized
            
            let longString11  = NSString.init(format: "%@ %@", longString10, longestWord2 ) as String
            let longestWordRange1 = (longString11 as NSString).range(of: longestWord2)
            
            let attributedString1 = NSMutableAttributedString(string: longString11, attributes: [NSAttributedStringKey.font : UIFont.init(name: "Lato-Regular", size: 13.0)!])
            
            attributedString1.setAttributes([NSAttributedStringKey.font : UIFont.init(name: "Lato-Semibold", size: 13.0)!, NSAttributedStringKey.foregroundColor : UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0)], range: longestWordRange1)
            lblTermsCondition.attributedText = attributedString1
            
        }
        else
        {
            UserDefaults.standard.set("en", forKey: "applanguage")
            
            UserDefaults.standard.synchronize()
            
            let longString10 = "By signing up, You agree with"
            let longestWord2 = "Terms and Conditions"
            
            let longString11  = NSString.init(format: "%@ %@", longString10, longestWord2 ) as String
            let longestWordRange1 = (longString11 as NSString).range(of: longestWord2)
            
            let attributedString1 = NSMutableAttributedString(string: longString11, attributes: [NSAttributedStringKey.font : UIFont.init(name: "Lato-Regular", size: 13.0)!])
            
            attributedString1.setAttributes([NSAttributedStringKey.font : UIFont.init(name: "Lato-Semibold", size: 13.0)!, NSAttributedStringKey.foregroundColor : UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0)], range: longestWordRange1)
            lblTermsCondition.attributedText = attributedString1
        }
    }
    @IBAction func barButtonItemClicked(_ sender: Any)
    {
        
    }
    
    func updateCategory()
    {
        if appDelegate.arrAllCategory.count > 0
        {
            
        }
    }
    
    func socialSignUpDetailsFill()
    {
        if self.dictSocialDetails.count > 0
        {
            
            self.viewSignInBG.isHidden = true
            self.viewSignUPBG.isHidden = false
            self.self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 690)
            
            self.txtEmailSignup.text = dictSocialDetails.object(forKey: kEmail) as? String
            self.txtUserName.text = dictSocialDetails.object(forKey: kFullName) as? String
            
            if CheckValidationSignup() {
                
                if appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.methodCheckUser), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK:- Check Login Validation................
    func CheckValidationLogin() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtEmail.text == ""
        {
            isGo = false
            errorMessage = kEnterEmailError.localized
        }
        else if self.isValidEmail(testStr: txtEmail.text!) == false
        {
            isGo = false
            errorMessage = kEnterVaildEmailError.localized
        }
        else if txtPassword.text == ""
        {
            isGo = false
            errorMessage = kEnterPasswordError.localized
        }
        else if (txtPassword.text!.count < kPasswordLengthMin)
        {
            isGo = false
            errorMessage = kPasswordAcceptableLengthError.localized
        }
        
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
    }
    
    // MARK:- Check Signup Validation................
    func CheckValidationSignup() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtName.text == ""
        {
            isGo = false
            errorMessage = kEnterNameError.localized
        }
        else if txtUserName.text == ""
        {
            isGo = false
            errorMessage = kEnterUsernameError.localized
        }
        else if txtEmailSignup.text == ""
        {
            isGo = false
            errorMessage = kEnterEmailError.localized
        }
        else if self.isValidEmail(testStr: txtEmailSignup.text!) == false
        {
            isGo = false
            errorMessage = kEnterVaildEmailError.localized
        }
        else if txtCountryCode.text?.isEmpty == true
        {
            isGo = false
            errorMessage = kSelectCountryCodeError.localized
        }
        else if txtMobileNo.text == ""
        {
            isGo = false
            errorMessage = kMobileNumError.localized
            
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
        else if txtPasswordSignup.text == ""
        {
            isGo = false
            errorMessage = kEnterPasswordError.localized
        }
        else if (txtPasswordSignup.text?.count)! < kPasswordLengthMin
        {
            isGo = false
            errorMessage = kPasswordAcceptableLengthError.localized
        }
        
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
    }
    
    // MARK:- Check Forgot Email Validation................
    
    func CheckValidationForgot() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtEmailForgotPass.text == ""
        {
            isGo = false
            errorMessage = kEnterEmailError.localized
        }
        
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
        
    }
    @objc func updateCategoryData()
    {
        if appDelegate.arrAllCategory.count > 0
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtTherapyType.text = (appDelegate.arrAllCategory.object(at: 0) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtTherapyType.text = (appDelegate.arrAllCategory.object(at: 0) as AnyObject).object(forKey: kCatName) as? String
            }
            
            categoryID = (appDelegate.arrAllCategory.object(at: 0) as! NSDictionary).valueForNullableKey(key: kCatID)
            hospitalNameTF.text = ""
            self.hospitalNameTF.frame.size.height = categoryID == "4" ? 40 : 0
            hospitalNameTF.isHidden = !(categoryID == "4")
            landlineTextField.text = ""
            self.landlineView.frame.size.height = categoryID == "4" ? 40 : 0
            landlineView.isHidden = !(categoryID == "4")
            
            UserDefaults.standard.set(txtTherapyType.text!, forKey: "catName")
            UserDefaults.standard.set(categoryID, forKey: "catID")
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
        }
        
    }
    // MARK: - UITextfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
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
            pickerHealth.selectRow(0, inComponent: 0, animated: false)
            pickerHealth.reloadAllComponents()
        }
        else if textField.tag == 12
        {
            isSltedTextF = false
            pickerHealth.selectRow(0, inComponent: 0, animated: false)
            pickerHealth.reloadAllComponents()
        }
        else if textField.tag == 100
        {
            strTextValue = "fromMobileNo"
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text == "" && string == " ")
        {            return false
        }
        if (textField == landlineTextField)
        {
            if (string == " ")
            {
                return false
            }
        }
        let newLength = textField.text!.count + string.count - range.length
        
        if (textField == txtName) || (textField == txtUserName)
        {
            return newLength > kFullNameLength ? false : true
        }
        if (textField == txtEmailSignup) 
        {
            return newLength > kEmailLength ? false : true
        }
        if (textField == txtMobileNo)
        {
            return newLength > kPhoneLength ? false : true
        }
        if (textField == txtPassword) || (textField == txtPasswordSignup)
        {
            return newLength > kPasswordLength ? false : true
        }
        
        return true
    }
    
    // MARK: - UIButtonsMethod
    //method Signin & Signup
    
    @IBAction func btnRemovelanguageClick(_ sender: UIButton)
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        self.view.endEditing(true)
    }
    @IBAction func methodKeyPadDone(_ sender: Any)
    {
        self.view.endEditing(true)
        
    }
    @IBAction func methodClosePopup(_ sender: Any)
    {        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        self.view.endEditing(true)
    }
    
    @IBAction func methodTermsAndCon(_ sender: Any)
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        let webV = WebViewScreen(nibName: "WebViewScreen",bundle: nil)
        webV.strWebURLFrom = "TermsAndCondFromLogin"
        self.navigationController?.pushViewController(webV, animated: true)
    }
    @IBAction func methodSignInandSignUp(_ sender: UIButton)
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        
        self.view.endEditing(true)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if sender.tag == 0
            {
                viewSignInBG.isHidden = true
                viewSignUPBG.isHidden = false
                
                lblSeprator_AR.frame = CGRect.init(x: btnSignUp.frame.origin.x, y: lblSeprator_AR.frame.origin.y, width: btnSignUp.frame.size.width, height: 2)
                
                self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 690)
            }
            else
            {
                viewSignInBG.isHidden = false
                viewSignUPBG.isHidden = true
                
                lblSeprator_AR.frame = CGRect.init(x: btnSignIn.frame.origin.x, y: lblSeprator_AR.frame.origin.y, width: btnSignUp.frame.size.width, height: 2)
                
                
                self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 590)
            }
        }
        else
        {
            if sender.tag == 0
            {
                viewSignInBG.isHidden = false
                viewSignUPBG.isHidden = true
                self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 590)
            }
            else
            {
                viewSignInBG.isHidden = true
                viewSignUPBG.isHidden = false
                self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 690)
            }
        }
    }
    
    
    @IBAction func methodEnglishArebic(_ sender: UIButton)
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        
        if sender.tag == 0
        {
            UserDefaults.standard.set("en", forKey: "applanguage")
            
            strLanguageSlt = "en"
            btnChooseLanguage.setTitle("English", for: .normal)
        }
        else
        {
            UserDefaults.standard.set("ar", forKey: "applanguage")
            
            strLanguageSlt = "ar"
            btnChooseLanguage.setTitle("عربى", for: .normal)
            //            sepratorSignIn.isHidden = true
            //            sepratorSignUp.isHidden = true
            //            viewSignUPBG.isHidden = true
        }
        
        UserDefaults.standard.synchronize()
        
        let demoController: LoginSignupScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            demoController = LoginSignupScreen(nibName: "LoginSignupView_Arabic",bundle: nil)
        }
        else
        {
            demoController = LoginSignupScreen(nibName: "LoginSignupScreen",bundle: nil)
        }
        
        self.navigationController?.pushViewController(demoController, animated: true)
    }
    @IBAction func methodLanguageSlt(_ sender: UIButton)
    {
        if btnChooseLanguage.isSelected == false
        {
            viewLanguageBG.isHidden = false
        }
        else
        {
            viewLanguageBG.isHidden = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    //Google Login
    @IBAction func methodGoogleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = kGoogleClientID
        
        GIDSignIn.sharedInstance().signOut()
        // appDelegate.strUrlAuthanticateType = "GOOGLE"
        GIDSignIn.sharedInstance().signIn()
        
    }
    //Mark : - Google SignUP
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //myActivityIndicator.stopAnimating()
    }
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if user != nil {
            print("Google data -----%@",user)
            
            self.dictSocialDetails = NSMutableDictionary()
            
            self.appDelegate.strUrlAuthanticateType = "GOOGLE"
            
            self.strSocialType = "google"
            
            var emailString    = ""
            var usernameString = ""
            var socialIdString = ""
            var profileUrl : URL!
            emailString = (user.profile.email as String!) as String
            usernameString = (user.profile.name as String!) as String
            socialIdString = (user.userID as String!) as String
            
            if user.profile.hasImage
            {
                profileUrl = user.profile.imageURL(withDimension: 100)
            }
            
            // print("URL",profileUrl)
            self.dictSocialDetails.setValue(emailString, forKey: (kEmail as NSCopying) as! String)
            self.dictSocialDetails.setValue(usernameString, forKey: (kFullName as NSCopying) as! String)
            self.dictSocialDetails.setValue(socialIdString, forKey: (kSocialId as NSCopying) as! String)
            self.dictSocialDetails.setValue(strSocialType, forKey: (kSocialType as NSCopying) as! String)
            self.dictSocialDetails.setValue(kDeviceName, forKey: (kDeviceType as NSCopying) as! String)
            self.dictSocialDetails.setValue(profileUrl, forKey: (kProfilePic as NSCopying) as! String)
            // print("dicFBdetails",self.dictSocialDetails)
            var StrToken = "simulator"
            
            if UserDefaults.standard.object(forKey: kDeviceToken) != nil
            {
                StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
            }
            
            self.dictSocialDetails.setValue(StrToken, forKey: (kDeviceToken as NSCopying) as! String)
            
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                
                self.performSelector(inBackground: #selector(self.methodCheckSocialUserApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage)
            }
            
            GIDSignIn.sharedInstance().delegate = nil
            GIDSignIn.sharedInstance().uiDelegate = nil
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //FB Login
    @IBAction func methodFB(_ sender: Any)
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        let fbLogin : FBSDKLoginManager = FBSDKLoginManager()
        fbLogin.logOut()
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        self.appDelegate.strUrlAuthanticateType = "FACEBOOK"
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self, handler:
                                { (result, error) -> Void in
                                    print("result && Error",result,error)
                                    if (error == nil)
                                    {
                                        let fbloginresult : FBSDKLoginManagerLoginResult = result!
                                        
                                        if(fbloginresult.isCancelled)
                                        {
                                        }
                                        else if(fbloginresult.grantedPermissions.contains(kEmail))
                                        {
                                            self.UserFaceBookDataFatch()
                                        }
                                    }
                                    else
                                    {
                                        print("FBError")
                                    }
                                })
    }
    
    //MARK:FBUserExitInfo
    func UserFaceBookDataFatch()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,friends{id, name,first_name, last_name, picture}"]).start(completionHandler:{ (connection, result, error) -> Void in
                if (error == nil)
                {
                    let dic = result as! NSDictionary
                    self.dictSocialDetails = NSMutableDictionary()
                    self.appDelegate.strUrlAuthanticateType = "FACEBOOK"
                    self.strSocialType = "facebook"
                    var strEmail = ""
                    var strSocialID = ""
                    var profileUrl : URL!
                    var strFirstName = ""
                    var strLastName = ""
                    
                    print("DicPrint-------%@",dic)
                    
                    strSocialID = dic.object(forKey: "id")! as! String
                    if dic.object(forKey: kEmail) != nil
                    {
                        strEmail = dic.object(forKey: kEmail)! as! String
                    }
                    if dic.object(forKey: kFirstName) != nil
                    {
                        strFirstName = dic.object(forKey: kFirstName)! as! String
                    }
                    if dic.object(forKey: kLastName) != nil
                    {
                        strLastName = dic.object(forKey: kLastName)! as! String
                    }
                    if dic.object(forKey: "picture") != nil && (dic.object(forKey: "picture") as! NSDictionary).object(forKey: "data") != nil && ((dic.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") != nil
                    {
                        profileUrl =  URL(string:((dic.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as! String)
                    }
                    
                    self.dictSocialDetails.setValue(strSocialID, forKey: (kSocialId as NSCopying) as! String)
                    self.dictSocialDetails.setValue(strEmail, forKey: (kEmail as NSCopying) as! String)
                    self.dictSocialDetails.setValue(self.strSocialType, forKey: (kSocialType as NSCopying) as! String)
                    self.dictSocialDetails.setValue(strFirstName, forKey: (kFullName as NSCopying) as! String)
                    self.dictSocialDetails.setValue(kDeviceName, forKey: (kDeviceType as NSCopying) as! String)
                    self.dictSocialDetails.setValue(profileUrl, forKey: (kProfilePic as NSCopying) as! String)
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.methodCheckSocialUserApi), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
                }
                else
                {
                    print("FBFrnd error")
                    //  MBProgressHUD.hideAllHUDs(for:  self.view, animated: true)
                }
            })
        }
    }
    
    //Twitter Login
    @IBAction func methodTwitter(_ sender: Any)
    {
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        FHSTwitterEngine.shared().clearAccessToken()
        FHSTwitterEngine.shared().permanentlySetConsumerKey(kTwitterConsumerKey, andSecret: kTwitterConsumerSecret)
        
        FHSTwitterEngine.shared().delegate = self
        FHSTwitterEngine.shared().loadAccessToken()
        
        self.oauthAction()
    }
    // MARK: - FHSTwitterEngine
    func storeAccessToken(_ accessToken: String!) {
        UserDefaults.standard.set(accessToken, forKey: "TwitterAccesstoken")
    }
    
    func loadAccessToken() -> String? {
        if let outputStr = UserDefaults.standard.object(forKey: "TwitterAccesstoken") as? String{
            return outputStr
        }
        return nil
    }
    
    func oauthAction() {
        
        let loginController = FHSTwitterEngine .shared() .loginController { (success) -> Void in
            
            self.dictSocialDetails = NSMutableDictionary()
            
            let strEmail = ""
            var strSocialID = ""
            var strName = ""
            let profileUrl : URL! = nil
            
            self.strSocialType = "twitter"
            
            strSocialID = (FHSTwitterEngine.shared().authenticatedID as NSString!) as String
            strName = (FHSTwitterEngine.shared().authenticatedUsername as NSString!) as String
            
            self.dictSocialDetails.setValue(strSocialID, forKey: (kSocialId as NSCopying) as! String)
            self.dictSocialDetails.setValue(strEmail, forKey: (kEmail as NSCopying) as! String)
            
            self.dictSocialDetails.setValue(strName, forKey: (kFullName as NSCopying) as! String)
            
            self.dictSocialDetails.setValue(self.strSocialType, forKey: (kSocialType as NSCopying) as! String)
            
            self.dictSocialDetails.setValue(profileUrl, forKey: ("profile_Url" as NSCopying) as! String)
            
            
            if self.appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodCheckSocialUserApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
            
            
        } as UIViewController
        self .present(loginController, animated: true, completion: nil)
    }
    
    //Login with Email id
    @IBAction func methodSignIn(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if CheckValidationLogin() {
            
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                
                self.performSelector(inBackground: #selector(self.methodUserLoginAPI), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
        
    }
    
    //Forgot password Popup
    @IBAction func methodForgotPass(_ sender: Any)
    {        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        self.view.endEditing(true)
        self.view.addSubview(self.viewForgotPasswordBG)
        self.viewForgotPasswordBG.frame = self.view.frame
    }
    //New user Signup
    @IBAction func methodSignUp(_ sender: Any)
    {
        self.view.endEditing(true)
        viewLanguageBG.isHidden = true
        btnChooseLanguage.isSelected = false
        if CheckValidationSignup() {
            
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodCheckUser), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
    }
    //All Health Related Picker done
    @IBAction func methodPickerDone(_ sender: Any)
    {
        let temp = pickerHealth.selectedRow(inComponent: 0)
        
        if strTextValue == "fromMobileNo"
        {
            self.view.endEditing(true)
            strTextValue = ""
        }
        else if isSltedTextF == true
        {
            isSltedTextF = false
            
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtTherapyType.text = (appDelegate.arrAllCategory.object(at: temp) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtTherapyType.text = (appDelegate.arrAllCategory.object(at: temp) as AnyObject).object(forKey: kCatName) as? String
            }
            
            categoryID = (appDelegate.arrAllCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            hospitalNameTF.text = ""
            self.hospitalNameTF.frame.size.height = categoryID == "4" ? 40 : 0
            hospitalNameTF.isHidden = !(categoryID == "4")
            landlineTextField.text = ""
            self.landlineView.frame.size.height = categoryID == "4" ? 40 : 0
            landlineView.isHidden = !(categoryID == "4")
            UserDefaults.standard.set(txtTherapyType.text!, forKey: "catName")
            UserDefaults.standard.set(categoryID, forKey: "catID")
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
        }
        else if isSltedTextF == false
        {
            isSltedTextF = true
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtCardiac.text = (arrSubCategory.object(at: temp) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtCardiac.text = (arrSubCategory.object(at: temp) as AnyObject).object(forKey: kCatName) as? String
            }
            self.subCategoryID = (arrSubCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            
            UserDefaults.standard.set(categoryID, forKey: "catID")
            UserDefaults.standard.set(txtCardiac.text!, forKey: "subCatName")
        }
        
        print("self.categoryID",self.categoryID)
        self.view.endEditing(true)
    }
    
    //Picker Cancel
    @IBAction func methodPickerCancel(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func methodSubmitandCancelPass(_ sender: UIButton)
    {
        if sender.tag == 11
        {
            if CheckValidationForgot()
            {
                
                if appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    
                    self.performSelector(inBackground: #selector(self.methodForgotPassAPI), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
            }
        }
        else
        {
            self.viewForgotPasswordBG.removeFromSuperview()
        }
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
            txtCountryCodeLandline.text = (cou.object(forKey: "dial_code") as! NSString) as String
        }
    }
    // MARK:- CheckUser API Integration................
    func CheckUserParams() -> NSMutableDictionary
    {
        
        let dictUser = NSMutableDictionary()
        dictUser.setObject(self.txtCountryCode.text!, forKey: kCountrycode as NSCopying)
        dictUser.setObject(self.txtMobileNo.text!, forKey: kPhoneNumber as NSCopying)
        dictUser.setObject(self.txtEmailSignup.text!, forKey: kEmail as NSCopying)
        return dictUser
        
    }
    
    @objc func methodCheckUser()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodCheckUser, Details: CheckUserParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    print("Result : \(responseData!)")
                    self.hideActivity()
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as? String == "1"
                    {
                        let dicUserInfo = NSMutableDictionary()
                        dicUserInfo.setValue(self.txtName.text!, forKey: kName)
                        dicUserInfo.setValue(self.txtUserName.text!, forKey: kUsername)
                        dicUserInfo.setValue(self.txtEmailSignup.text!, forKey: kEmail)
                        dicUserInfo.setValue(self.txtCountryCode.text!, forKey: kCountrycode)
                        dicUserInfo.setValue(self.txtMobileNo.text!, forKey: kPhoneNumber)
                        dicUserInfo.setValue(self.txtPasswordSignup.text!, forKey: "password")
                        dicUserInfo.setValue(self.categoryID, forKey: "user_cat")
                        dicUserInfo.setValue(self.strCountryName, forKey: "User_country")
                        dicUserInfo.setValue(self.hospitalNameTF.text ?? "", forKey: "hospital_name")
                        dicUserInfo.setValue(self.subCategoryID, forKey: "sub_cat_id")
                        
                        UserDefaults.standard.set(self.categoryID, forKey: "catID")
                        UserDefaults.standard.set(self.txtTherapyType.text!, forKey: "catName")
                        UserDefaults.standard.set(self.txtCardiac.text!, forKey: "subCatName")
                        
                        var landlineNumber = String()
                        if !(self.txtCountryCodeLandline.text?.isEmpty ?? false)
                        {
                            if !(self.landlineTextField.text?.isEmpty ?? false)
                            {
                                landlineNumber = "\(self.txtCountryCodeLandline.text ?? "") \(self.landlineTextField.text ?? "")"
                            }
                        }else
                        {
                            landlineNumber = self.landlineTextField.text ?? ""
                        }
                        dicUserInfo.setValue(landlineNumber, forKey: "landline_number")

                        if self.dictSocialDetails.object(forKey: kSocialId) != nil
                        {
                            dicUserInfo.setValue(self.dictSocialDetails.object(forKey: kSocialId)!, forKey: kSocialId)
                            dicUserInfo.setValue(self.dictSocialDetails.object(forKey: kSocialType)!, forKey: kSocialType)
                        }
                        
                        let demoController: OTPViewController!
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            demoController = OTPViewController(nibName: "OTPView_Arabic",bundle: nil)
                        }
                        else
                        {
                            demoController = OTPViewController(nibName: "OTPViewController",bundle: nil)
                        }
                        demoController.dicUserInfo = dicUserInfo
                        debugPrint(dicUserInfo)
                        self.navigationController?.pushViewController(demoController, animated: true)
                        // }
                    }
                    else
                    {
                        self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message") as? String ?? "Please provide valid information.")
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
    
    // MARK:- LoginUser API Integration................
    func LoginUserParams() -> NSMutableDictionary
    {
        
        let dictUser = NSMutableDictionary()
        dictUser.setObject(self.txtEmail.text!, forKey: kEmail as NSCopying)
        dictUser.setObject(self.txtPassword.text!, forKey: kPassword as NSCopying)
        dictUser.setObject(strLanguageSlt, forKey: kDefaultLanguage as NSCopying)
        var StrToken = "simulator"
        
        if UserDefaults.standard.object(forKey: kDeviceToken) != nil {
            
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        dictUser.setObject(StrToken, forKey: kDeviceToken as NSCopying)
        dictUser.setObject(kDeviceName, forKey: kDeviceType as NSCopying)
        
        return dictUser
    }
    @objc func methodUserLoginAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodLoginUser, Details: LoginUserParams()) { (responseData, error) in
            
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("Result : \(responseData!)")
                        
                        let arrUserDtals =  responseData?.object(forKey: kUserSavedDetails) as! NSArray
                        let userID = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kUserID)
                        
                        let userFullName = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kFullName)
                        let userName = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kUsername)
                        let userEmailID = (arrUserDtals.object(at: 0) as! NSDictionary).valueForNullableKey(key: kEmailGet)
                        
                        UserDefaults.standard.set("Yes", forKey: kLoginCheck)
                        UserDefaults.standard.set(userID, forKey: kUserID)
                        UserDefaults.standard.set(userFullName, forKey: kFullName)
                        UserDefaults.standard.set(userName, forKey: kUsername)
                        UserDefaults.standard.set(userEmailID, forKey: kEmailGet)
                        
                        self.appDelegate.methodAddDeviceAPI()
                        self.appDelegate.ShowMainviewController()
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
    
    // MARK:- ForgotPassword API Integration................
    func ForgotParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(self.txtEmailForgotPass.text!, forKey: kEmail as NSCopying)
        return dictUser
    }
    @objc func methodForgotPassAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodForgotPass, Details: ForgotParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        // self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                        let alertController = UIAlertController(title: "", message: responseData?.object(forKey: "message")! as! String?, preferredStyle: .alert)
                        // Initialize Actions
                        let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                            
                            self.viewForgotPasswordBG.removeFromSuperview()
                        }
                        alertController.addAction(yesAction)
                        
                        // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
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
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    self.arrSubCategory = (responseData?.object(forKey: "cat_data")as!NSArray).mutableCopy() as! NSMutableArray
                    
                    print("self.arrSubCategory",self.arrSubCategory)
                    if self.arrSubCategory.count > 0
                    {
                        self.viewSubcategoryBG.isHidden = false
                        
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            self.txtCardiac.text = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: "Cat_ar") as? String
                        }
                        else
                        {
                            self.txtCardiac.text = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: kCatName) as? String
                        }
                        
                        self.subCategoryID = (self.arrSubCategory.object(at: 0) as! NSDictionary).valueForNullableKey(key: kCatID)
                        
                        self.btnTermsConditions.frame = CGRect.init(x: (self.btnTermsConditions.frame.origin.x), y: (self.landlineView.frame.origin.y) + 68, width: (self.btnTermsConditions.frame.size.width), height: (self.btnTermsConditions.frame.size.height))
                        
                        self.lblTermsCondition.frame = CGRect.init(x: (self.btnTermsConditions.frame.origin.x), y: (self.landlineView.frame.origin.y) + 68, width: (self.btnTermsConditions.frame.size.width), height: (self.btnTermsConditions.frame.size.height))
                        
                        self.btnSignUpClick.frame = CGRect.init(x: (self.btnSignUpClick.frame.origin.x), y: (self.btnTermsConditions.frame.origin.y) + 42, width: (self.btnSignUpClick.frame.size.width), height: (self.btnSignUpClick.frame.size.height))
                    }
                    else
                    {
                        self.viewSubcategoryBG.isHidden = true
                        
                        self.btnTermsConditions.frame = CGRect.init(x: (self.btnTermsConditions.frame.origin.x), y: (self.landlineView.frame.origin.y) + 56, width: (self.btnTermsConditions.frame.size.width), height: (self.btnTermsConditions.frame.size.height))
                        
                        self.lblTermsCondition.frame = CGRect.init(x: (self.btnTermsConditions.frame.origin.x), y: (self.landlineView.frame.origin.y) + 56, width: (self.btnTermsConditions.frame.size.width), height: (self.btnTermsConditions.frame.size.height))
                        
                        self.btnSignUpClick.frame = CGRect.init(x: (self.btnSignUpClick.frame.origin.x), y: (self.btnTermsConditions.frame.origin.y) + 42, width: (self.btnSignUpClick.frame.size.width), height: (self.btnSignUpClick.frame.size.height))
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
    
    // MARK:- Get Child Category API Integration.................
    func CheckSocialUserParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(dictSocialDetails.object(forKey: kSocialId)!, forKey: kSocialId as NSCopying)
        dictUser.setObject(dictSocialDetails.object(forKey: kSocialType)!, forKey: kSocialType as NSCopying)
        dictUser.setObject(dictSocialDetails.object(forKey: kEmail )!, forKey: "email" as NSCopying)
        
        return dictUser
    }
    
    @objc func methodCheckSocialUserApi()
    {
        getAllApiResults(Details:  self.CheckSocialUserParams() , srtMethod: kMethodCheckSocialUser) { (responseData, error) in
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)
                    
                    let dicUserDtals =  responseData?.object(forKey: "request_data") as! NSDictionary
                    //                    print("dicUserDtals",dicUserDtals)
                    
                    let userID = dicUserDtals.valueForNullableKey(key: "User_id")
                    let userFullName = dicUserDtals.valueForNullableKey(key: "User_fullname")
                    let userName = dicUserDtals.valueForNullableKey(key: "User_name")
                    let userEmailID = dicUserDtals.valueForNullableKey(key: "User_email")
                    
                    UserDefaults.standard.set("Yes", forKey: kLoginCheck)
                    UserDefaults.standard.set(userID, forKey: kUserID)
                    UserDefaults.standard.set(userFullName, forKey: kFullName)
                    UserDefaults.standard.set(userName, forKey: kUsername)
                    UserDefaults.standard.set(userEmailID, forKey: kEmailGet)
                    
                    self.appDelegate.methodAddDeviceAPI()
                    
                    self.appDelegate.ShowMainviewController()
                    
                }
                else
                {
                    print("response_Else",responseData!)
                    self.socialSignUpDetailsFill()
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
            }
        }
    }
    
}

