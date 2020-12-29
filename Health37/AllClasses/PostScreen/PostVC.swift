//
//  PostVC.swift
//  Health37
//
//  Created by Aarti on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    ////IBoutlets
    @IBOutlet var imgPost: UIImageView!
    @IBOutlet weak var containerView: UIView!
    //@IBOutlet weak var commentTextView: SZTextView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var txtDescription: SZTextView!
    
    var imgPostData = Data()
    
    @IBOutlet var toolBar: UIToolbar!

    @IBOutlet var btnPost: UIButton!

    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!

    @IBOutlet var viewInfoPopupBG: UIView!
    @IBOutlet var viewInfoPopup: UIView!
    @IBOutlet var lblPostMsg: UILabel!
    var strFromGroups = ""
    @IBOutlet var scrollingBar: UIScrollView!
    @IBOutlet var lblTitlePopup: UILabel!
    @IBOutlet var btnOk: UIButton!
    var strGroupID = ""
    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true

        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 157.0/255, green: 214.0/255, blue: 215.0/255, alpha: 1).cgColor
        txtDescription.placeholderString = ""
        txtDescription.inputAccessoryView = toolBar
        
        DispatchQueue.main.async
            {
                self.scrollingBar.contentSize = CGSize.init(width: self.scrollingBar.frame.size.width, height: 667)
        }
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
          //  btnPost.setTitle("Post".localized, for: .normal)
            txtDescription.placeholderString = "Add your comment here".localized
            lblTitlePopup.text = "Health37".localized
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
//        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)

       // self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "back-white")
        self.navigationItem.titleView = viewHeader
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "white_back")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }

    }

    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    ///Open Settings
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

    // MARK: - UITextViewMethods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (textView.text == "" && text == " ") ||  (textView.text == "" && text == "/n")//(textView.text == "" && text == " ")
        {
            return false
        }
        return true
    }

    // MARK:- Check Login Validation................
    func CheckValidation() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if (txtDescription.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" && imgPost.image == nil)
        {
            isGo = false
            errorMessage = kEnterPostError.localized
        }
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
    }

    //MARK:- UIButton Action Method
    @IBAction func methodPost(_ sender: UIButton)
    {
        self.view.endEditing(true)
            if CheckValidation()
            {
                let window = UIApplication.shared.keyWindow!
                window.addSubview(self.viewInfoPopup)
                self.viewInfoPopup.frame = window.frame

                if self.strFromGroups == "FromGroupDtls"
                {
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        self.lblPostMsg.text = "تهدف المجوعات الى رفع مستوى الوعي الصحي للمجتمع. تأكد من ان منشورك موثوق علميا ، لا يحتوي على صور مبتذله  ولا يحوي او يشير الى دعاية كذكر الاسماء ، ارقام الهواتف ، الروابط"
                    }
                    else
                    {
                        self.lblPostMsg.text = "Aim of groups is to raise the level of society health awareness. Make sure that your post is scientifically reliable, contains no indecent photos , does not contain or refers to advertisements such as names, phone numbers "
                    }
                }
                else
                {
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        self.lblPostMsg.text = "تأكد من أن منشىوراتك موثوق بها علميا ، لا تحتوي على معلومات مضلله ، صور غير لائقة لمزيد من المعلومات يرجى زيارة الشروط والأحكام"
                    }
                    else
                    {
                        self.lblPostMsg.text = "Make sure your posts are scientific reliable, not contain fake informations, indecent photos For more informations please visit our terms and conditions."
                    }
                }
        }
    }
    @IBAction func methodKeyPadDone(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func methodInfoOK(_ sender: UIButton)
    {
        viewInfoPopup.removeFromSuperview()
        if sender.tag == 1
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.addPostListAPI), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
    }
    ////Camera Open
    @IBAction func cameraButton(_ sender: Any)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning".localized, message: "You don't have camera".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }


    }
    ///Open Galary
    @IBAction func galaryButton(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)

    }
    ///Open Settings
    @IBAction func settingsButton(_ sender: Any)
    {
        self.menuContainerViewController.toggleRightSideMenuCompletion
            { () -> Void in
        }
    }
    ///Open side Panel
    @IBAction func sidePanelButton(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func methodTimeLine(_ sender: Any)
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
    @IBAction func methodNotification(_ sender: Any)
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
    @IBAction func methodInbox(_ sender: Any)
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
        imgPost.image = image
        imgPostData = UIImageJPEGRepresentation(image!, 0.6)!
    }
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        // MARK:- addPost API Integration.................
        func addPostParams() -> NSMutableDictionary
        {
            let dictUser = NSMutableDictionary()
    
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
            dictUser.setObject(txtDescription.text!.encode(), forKey: "post_content" as NSCopying)
            
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                dictUser.setObject("ar", forKey: "language" as NSCopying)
            }
            else
            {
                dictUser.setObject("en", forKey: "language" as NSCopying)
            }
            
            if self.strFromGroups == "FromGroupDtls"
            {
                dictUser.setObject("\(strGroupID)", forKey: "group_id" as NSCopying)
            }
            return dictUser
    }
    
    @objc func addPostListAPI()
    {
        var strAddPostKey = ""
        if self.strFromGroups == "FromGroupDtls"
        {
            strAddPostKey = "addGroupPost"
        }
        else
        {
            strAddPostKey = "addPost"
        }

        getallApiResultwithimagePostMethod(strMethodname: strAddPostKey, imgData: imgPostData, strImgKey: kPostImage, Details: addPostParams()) { (responseData, error) in
                if error == nil
                {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAllPostList"), object: nil)
                        self.navigationController?.popViewController(animated: true)

                    }
                    else
                    {
                        print("responseData",responseData!)
                    }
                }
                self.hideActivity()
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
