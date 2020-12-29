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

class AddUserScreen: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CountryListViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIWebViewDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var pickerHealth: UIPickerView!
    @IBOutlet var txtMainCategoryType: UITextField!
    @IBOutlet var txtSubCategoryType: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var experienceTF: UITextField!
    @IBOutlet weak var addPhotoLable: UILabel!
    @IBOutlet weak var limitLable: UILabel!
    
    var isSltedTextF : Bool = false
    var categoryID = String()
    var isEdit : Bool = false
    var userDetail = [String : Any]()
    var subCategoryID = String()
    var doctorID = String()
    var strCountryName = ""
    var strSocialType = ""
    var strTextValue = ""
    var arrSubCategory = NSMutableArray()
    var dictSocialDetails = NSMutableDictionary()
    var arrAllCategory = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var imgDataProfile = Data()
    var appointmentDetail: AppointmentDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let allCategory = appDelegate.arrAllCategory.mutableCopy() as? NSMutableArray
        {
            if allCategory.count > 0
            {
                allCategory.removeObject(at: 0)
                arrAllCategory = allCategory
            }
        }
        
        self.title = "Add New Doctor".localized
        
        if isEdit
        {
            self.title = "Edit Doctor Detail".localized
            btnSignIn.setTitle("Update", for: .normal)
            txtName.text = (userDetail["full_name"] as? String ?? "")?.capitalized
            txtEmail.text = (userDetail["user_email"] as? String ?? "")
            txtMainCategoryType.text = (userDetail["category_name"] as? String ?? nil)
            txtSubCategoryType.text = (userDetail["sub_category_name"] as? String ?? nil)
            experienceTF.text = (userDetail["user_brief"] as? String ?? nil)?.capitalized
            let url = URL.init(string: "\(userDetail["User_image"] as? String ?? "")")
            userImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "plaeholder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.userImage.sd_removeActivityIndicator()
            })
            self.doctorID = userDetail["user_id"] as? String ?? ""
            self.subCategoryID = userDetail["user_sub_cat"] as? String ?? ""
            self.categoryID = userDetail["user_cat"] as? String ?? ""
            
            self.title = "Edit Doctor".localized

        }
        
        let backItem = self.navigationItem.backButtonOnRight(title: "Back")
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
        
        cancelButton.title = "Cancel".localized
        doneButton.title = "Done".localized
        
        txtMainCategoryType.inputAccessoryView = toolBar
        txtMainCategoryType.inputView = pickerHealth
        
        txtSubCategoryType.inputAccessoryView = toolBar
        txtSubCategoryType.inputView = pickerHealth
        
        pickerHealth.backgroundColor = UIColor.white
        btnSignIn.layer.cornerRadius = 20.0
        btnSignIn.layer.cornerRadius = 20.0
        btnSignIn.layer.borderWidth = 1.0
        btnSignIn.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        btnSignIn.layer.borderWidth = 1.0
        btnSignIn.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            backItem.semanticContentAttribute = .forceRightToLeft
            mainView.semanticContentAttribute = .forceRightToLeft
            txtName.textAlignment = .right
            txtEmail.textAlignment = .right
            txtMainCategoryType.textAlignment = .right
            txtSubCategoryType.textAlignment = .right
            experienceTF.textAlignment = .right
            limitLable.textAlignment = .left
            txtName.placeholder = "Name".localized
            experienceTF.placeholder = "Write About Experience".localized
            txtEmail.placeholder = "Email".localized
            btnSignIn.setTitle("ADD".localized, for: .normal)
            txtMainCategoryType.placeholder = "Category".localized
            txtSubCategoryType.placeholder = "Sub category".localized
            addPhotoLable.text = "Add Photo".localized
            limitLable.text = "100 characters".localized
        }
        else
        {
            mainView.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @objc func backTapped(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func photoPickerButton(_ sender: UIButton) {
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
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
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
        let pickerImage = UIImagePickerController()
        pickerImage.delegate = self;
        pickerImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerImage.allowsEditing = true
        self.present(pickerImage, animated: true, completion: nil)
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
            image = info[UIImagePickerControllerEditedImage] as? UIImage
        } else
        {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        userImage.image = image
        imgDataProfile = UIImageJPEGRepresentation(image!, 0.4)! as Data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        else if txtEmail.text == ""
        {
            isGo = false
            errorMessage = kEnterEmailError.localized
        }
        else if self.isValidEmail(testStr: txtEmail.text!) == false
        {
            isGo = false
            errorMessage = kEnterVaildEmailError.localized
        }
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        return isGo
    }
    
    @objc func updateCategoryData()
    {
        if arrAllCategory.count > 0
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                txtMainCategoryType.text = (arrAllCategory.object(at: 0) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtMainCategoryType.text = (arrAllCategory.object(at: 0) as AnyObject).object(forKey: kCatName) as? String
            }
            
            categoryID = (arrAllCategory.object(at: 0) as! NSDictionary).valueForNullableKey(key: kCatID)
        }
        
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
        let newLength = textField.text!.count + string.count - range.length
        
        if (textField == txtName)
        {
            return newLength > kFullNameLength ? false : true
        }
        if (textField == txtEmail)
        {
            return newLength > kEmailLength ? false : true
        }
        if (textField == experienceTF)
        {
            return newLength > 100 ? false : true
        }
        return true
    }
    
    //New user Signup
    @IBAction func methodSignUp(_ sender: Any)
    {
        self.view.endEditing(true)
        if CheckValidationSignup() {
            
            if appDelegate.isInternetAvailable() == true
            {
                if isEdit
                {
                    self.updateUser()
                }else
                {
                    self.methodAddUserPost()
                }
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
                txtMainCategoryType.text = (arrAllCategory.object(at: temp) as AnyObject).object(forKey: "Cat_ar") as? String
            }
            else
            {
                txtMainCategoryType.text = (arrAllCategory.object(at: temp) as AnyObject).object(forKey: kCatName) as? String
            }
            categoryID = (arrAllCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            
            self.showActivity(text: "")
            txtSubCategoryType.text = ""
            self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
        }
        else if isSltedTextF == false
        {
            isSltedTextF = true
            if temp < arrSubCategory.count
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    txtSubCategoryType.text = (arrSubCategory.object(at: temp) as AnyObject).object(forKey: "Cat_ar") as? String
                }
                else
                {
                    txtSubCategoryType.text = (arrSubCategory.object(at: temp) as AnyObject).object(forKey: kCatName) as? String
                }
                self.subCategoryID = (arrSubCategory.object(at: temp) as! NSDictionary).valueForNullableKey(key: kCatID)
            }
        }
        print("self.subCategoryID",self.subCategoryID)
        self.view.endEditing(true)
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
            if arrAllCategory.count > 0
            {
                return arrAllCategory.count
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
            if arrAllCategory.count > 0
            {
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    return  (arrAllCategory.object(at: row) as AnyObject).object(forKey: "Cat_ar") as? String
                }
                else
                {
                    return  (arrAllCategory.object(at: row) as AnyObject).object(forKey: kCatName) as? String
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
        strCountryName = (cou.object(forKey: "name") as! NSString) as String
    }
    
    @objc func methodAddUserPost()
    {
        self.showActivity(text: "")
        getallApiResultwithimagePostMethod(strMethodname: kMethodAddUser, imgData: imgDataProfile, strImgKey: "doctor_image", Details: addPostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        print("responseData",responseData!)
                        self.showOptionAlert(title: "Alert".localized, message: "Doctor added Successfully.".localized, button1Title: "OK".localized, button2Title: "", completion: { (success) in
                            if success
                            {
                                self.showActivity(text: "Updating Slots Detail.")
                                self.appointmentDetail?.userID = responseData?["user_id"] as? String ?? ""
                                self.setTimeSlotsInformation()
                            }
                        })
                    }
                    else
                    {
                        print("responseData",responseData!)
                    }
                }
            }
            self.hideActivity()
        }
    }
    
    @objc func updateUser()
    {
        self.showActivity(text: "")
        getallApiResultwithimagePostMethod(strMethodname: kMethodUpdateUser, imgData: imgDataProfile, strImgKey: "doctor_image", Details: addPostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        print("responseData",responseData!)
                        self.showOptionAlert(title: "Alert".localized, message: "Doctor updated Successfully.".localized, button1Title: "OK".localized, button2Title: "", completion: { (success) in
                            if success
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    else
                    {
                        print("responseData",responseData!)
                    }
                }
            }
            self.hideActivity()
        }
    }
    
    func addPostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if isEdit
        {
            dictUser.setObject(self.doctorID, forKey: "user_id" as NSCopying)
        }else
        {
            if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
            {
                dictUser.setObject(userid, forKey: "created_by" as NSCopying)
            }
        }
        
        dictUser.setObject(self.txtName.text ?? "", forKey: "name" as NSCopying)
        dictUser.setObject(self.txtEmail.text ?? "", forKey: "email" as NSCopying)
        dictUser.setObject(self.subCategoryID, forKey: "user_sub_cat" as NSCopying)
        dictUser.setObject(self.categoryID, forKey: "user_cat_id" as NSCopying)
        dictUser.setObject(self.experienceTF.text ?? "", forKey: "user_brief" as NSCopying)
        dictUser.setObject(UserDefaults.standard.hospital_name ?? "", forKey: "hospital_name" as NSCopying)

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
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            self.txtSubCategoryType.text = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: "Cat_ar") as? String
                        }
                        else
                        {
                            self.txtSubCategoryType.text = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: kCatName) as? String
                        }
                        self.subCategoryID = (self.arrSubCategory.object(at: 0) as AnyObject).object(forKey: kCatID) as? String ?? ""
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

extension AddUserScreen
{
    func setTimeSlotsInformation()
    {
        if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
        {
            let originalString = "&user_id=\(appointmentDetail?.userID ?? userid)&availablFromTime=\(appointmentDetail?.availableFromHours ?? "")&availablToTime=\(appointmentDetail?.availableToHours ?? "")&lunchFromTime=\(appointmentDetail?.breakFromTime ?? "")&lunchToTime=\(appointmentDetail?.breakToTime ?? "")&selectedSlotTime=\(appointmentDetail?.slotTime ?? "")&selectedDays=\(appointmentDetail?.availableDays ?? "")&locationTextfield=&locationLatitude=&locationLongitude=&notes=\(appointmentDetail?.notes ?? "")"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            var request = URLRequest(url: URL(string: Base_URL + kMethodSetTimeSlot + escapedString)!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              DispatchQueue.main.async {
                  self.hideActivity()
                  guard let data = data else {
                      print(String(describing: error))
                      return
                  }
                  let dict = self.convertToDictionary(text: String(data: data, encoding: .utf8)!)
                  if let response = dict?["response"] as? String, response == "1"
                  {
                      let alertController = UIAlertController(title: "", message: "Time Slot Modified Successfully.".localized as String?, preferredStyle: .alert)
                      let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                          self.navigationController?.popToRootViewController(animated: true)
                      }
                      alertController.addAction(yesAction)
                      self.present(alertController, animated: true, completion: nil)
                  }
                  else
                  {
                      print("response_Else",dict?["message"] as? String ?? "")
                  }
              }
            }
            task.resume()
        }
    }
}

