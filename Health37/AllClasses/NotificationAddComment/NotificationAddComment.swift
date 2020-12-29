//
//  NotificationAddComment.swift
//  Health37
//
//  Created by Ramprasad on 01/11/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import GrowingTextView

class NotificationAddComment: UIViewController,UIGestureRecognizerDelegate, UITableViewDataSource,UITextFieldDelegate, UITableViewDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var viewTxtFBG: UIView!
    @IBOutlet var tblNotificationList: UITableView!
    var safeAreaBottom:CGFloat = 0
    @IBOutlet  var viewBottomTxtField: UIView!
    @IBOutlet var txtmsgs: GrowingTextView!
    
    var  arrPostDetails = NSMutableArray()
    
    var  arrAllPostComments = NSMutableArray()
    var  arrReplyComments = NSMutableArray()
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewcommenttext: NSLayoutConstraint!
    var strPostID = ""
    var strActionSet = ""
    var strCommentID = ""
    var strFromTimeLine = ""
    ///PopupOutlets
    @IBOutlet var imgPostUser: UIImageView!
    
    @IBOutlet var txtAddComments: GrowingTextView!
    @IBOutlet var viewCommentBG: UIView!
    @IBOutlet var viewCommentPopup: UIView!
    @IBOutlet var viewCommentPopupBG: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var txtUserInfo: UITextView!
    @IBOutlet var imgLogoHeader: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtmsgs.delegate = self
        txtmsgs.trimWhiteSpaceWhenEndEditing = false
        txtmsgs.minHeight = 50.0
        txtmsgs.maxHeight = 50.0
        txtAddComments.delegate = self
        txtAddComments.trimWhiteSpaceWhenEndEditing = false
        txtAddComments.minHeight = 30.0
        txtAddComments.maxHeight = 150.0
        imgPostUser.layer.cornerRadius = imgPostUser.frame.size.width/2
        imgPostUser.layer.masksToBounds = true
        
        viewTxtFBG.layer.cornerRadius = viewTxtFBG.frame.height/2
        viewCommentBG.layer.cornerRadius = 2.0
        viewCommentBG.layer.borderWidth = 1.0
        viewCommentBG.layer.borderColor = UIColor.init(red: 0/255.0, green: 161/255.0, blue: 173/255.0, alpha: 1.0).cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        DispatchQueue.main.async
            {
                if self.strFromTimeLine != "FromTimeLine"
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.SinglePostDetailsAPI), with: nil)
                        self.performSelector(inBackground: #selector(self.PostCommentsAPI), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
                }
                else
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.PostCommentsAPI), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
                }
        }
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            
            btnCancel.setTitle("CANCEL".localized, for: .normal)
            btnSubmit.setTitle("SUBMIT".localized, for: .normal)
            
            txtAddComments.placehold = "Add Comment...".localized
            txtmsgs.placehold = "Add Comment...".localized
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Keyboard Methods
    @objc func keyboardWillChangeFrame(notification: NSNotification)
    {
        //        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let keyboardHeight = keyboardFrame.size.height
            if viewcommenttext != nil
            {
                viewcommenttext.constant = keyboardHeight
            }
        }
    }
    
    @objc func KeyboardWillHide()
    {
        // txtmsgs.resignFirstResponder()
        if viewcommenttext != nil
        {
            viewcommenttext.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        
        self.navigationItem.hidesBackButton = true
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.title = "Comments".localized
            
            if self.strFromTimeLine == "FromTimeLine"
            {
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else
                {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                
                self.imgLogoHeader.isHidden = true
                self.viewHeader.isHidden = true
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                self.navigationItem.titleView = viewHeader
            }
        }
        else
        {
            if self.strFromTimeLine == "FromTimeLine"
            {
                self.imgLogoHeader.isHidden = true
                self.viewHeader.isHidden = true
                
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else
                {
                    self.navigationBarWithBackButton(strTitle: "Comments".localized, leftbuttonImageName: "white_back")
                }
            }
            else
            {
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else
                {
                    self.navigationBarWithBackButton(strTitle: "Comments".localized, leftbuttonImageName: "white_back")
                }
                self.navigationItem.titleView = viewHeader
            }
        }
    }
    
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Chat Methods
    @objc func resignTextView()
    {
        txtmsgs.resignFirstResponder()
        var containerFrame : CGRect
        containerFrame = viewBottomTxtField.frame
        containerFrame.origin.y = tblNotificationList.frame.size.height - containerFrame.size.height - safeAreaBottom
        viewBottomTxtField.frame = containerFrame
        
        tblNotificationList.frame = CGRect(x: 0, y: 0, width: tblNotificationList.frame.size.width, height: viewBottomTxtField.frame.origin.y)
    }
    
    // MARK:- Check Login Validation................
    func CheckValidation() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if (txtAddComments.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            isGo = false
            errorMessage = kEnterAddCommentError.localized
        }
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
    }
    
    // MARK:- UIButtonsMethod
    @IBAction func methodSetting(_ sender: Any)
    {
        self.menuContainerViewController.toggleRightSideMenuCompletion
            { () -> Void in
        }
    }
    
    @IBAction func methodSendMSG(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if CheckValidation()
        {
            DispatchQueue.main.async
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.AddCommentsAPI), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
            }
        }
    }
    
    @IBAction func methodLikeUnlikePost(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        ////****
        if appDelegate.isInternetAvailable() == false
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            return
        }
        
        let dicLike = NSMutableDictionary.init(dictionary: (self.arrPostDetails.object(at: sender.tag) as! NSDictionary))
        var strtempTotalCount = 0
        let strtempPostID = dicLike.valueForNullableKey(key: "post_id")
        
        strtempTotalCount = Int(NSString(format: "%@", dicLike.valueForNullableKey(key: "likes")).intValue)
        
        var strtempActionSet = ""
        if  dicLike.valueForNullableKey(key: "is_like") == "1"
        {
            strtempActionSet = "0"
            if strtempTotalCount > 0
            {
                strtempTotalCount = strtempTotalCount - 1
            }
        }
        else
        {
            strtempActionSet = "1"
            strtempTotalCount = strtempTotalCount + 1
        }
        
        dicLike.setObject(strtempActionSet, forKey: "is_like" as NSCopying)
        dicLike.setObject(strtempTotalCount, forKey: "likes" as NSCopying)
        
        arrPostDetails.replaceObject(at: sender.tag, with: dicLike)
        
        var SecNo = 1
        if self.strFromTimeLine != "FromTimeLine"
        {
            SecNo = 0
        }
        
        let inDexPath = IndexPath.init(row: sender.tag, section: SecNo)
        let cellLike = tblNotificationList.cellForRow(at: inDexPath) as? ProductDetailsTblCell
        
        if cellLike == nil
        {
            return
        }
        (strtempActionSet == "1") ? (cellLike?.btnLike.isSelected = true) :(cellLike?.btnLike.isSelected = false)
        cellLike?.lblLikeCount.text = "(\(dicLike.valueForNullableKey(key: "likes")))"
        
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strtempPostID, forKey: "post_id" as NSCopying)
        
        
        dictUser.setObject("\(sender.tag)", forKey: "tag" as NSCopying)
        
        dictUser.setObject(strtempActionSet, forKey: "action" as NSCopying)
        dictUser.setObject(UserDefaults.standard.value(forKey: "applanguage") ?? "en", forKey: "language" as NSCopying)
        self.performSelector(inBackground: #selector(self.MyLikePostAPI), with: dictUser)
        
    }
    
    @IBAction func methodLikeUnlikeComments(_ sender: UIButton)
    {
        
        if appDelegate.isInternetAvailable() == false
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            return
        }
        
        let dicLike = NSMutableDictionary.init(dictionary: (self.arrAllPostComments.object(at: sender.tag) as! NSDictionary))
        var strtempTotalCount = 0
        let strtempPostID = dicLike.valueForNullableKey(key: "post_id")
        let strTempCommentID = (self.arrAllPostComments.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "comment_id")
        
        strtempTotalCount = Int(NSString(format: "%@", dicLike.valueForNullableKey(key: "likes")).intValue)
        
        var strtempActionSet = ""
        if  dicLike.valueForNullableKey(key: "is_like") == "1"
        {
            strtempActionSet = "0"
            if strtempTotalCount > 0
            {
                strtempTotalCount = strtempTotalCount - 1
            }
        }
        else
        {
            strtempActionSet = "1"
            strtempTotalCount = strtempTotalCount + 1
        }
        
        dicLike.setObject(strtempActionSet, forKey: "is_like" as NSCopying)
        dicLike.setObject(strtempTotalCount, forKey: "likes" as NSCopying)
        
        arrAllPostComments.replaceObject(at: sender.tag, with: dicLike)
        
        var SecNo = 0
        if self.strFromTimeLine != "FromTimeLine"
        {
            if tblNotificationList.tag == 1000001
            {
                if self.arrAllPostComments.count > 0
                {
                    SecNo = 1
                }
                else
                {
                    SecNo = 0
                }
                
            }
        }
        else
        {
            SecNo = 0
        }
        let inDexPath = IndexPath.init(row: sender.tag, section: SecNo)
        let cellLike = tblNotificationList.cellForRow(at: inDexPath) as? AddCommentTblCell
        
        if cellLike == nil
        {
            return
        }
        (strtempActionSet == "1") ? (cellLike?.btnLikes.isSelected = true) :(cellLike?.btnLikes.isSelected = false)
        cellLike?.lblLikesCount.text = "(\(dicLike.valueForNullableKey(key: "likes")))"
        
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strtempPostID, forKey: "post_id" as NSCopying)
        dictUser.setObject(strTempCommentID, forKey: "iCommentId" as NSCopying)
        
        
        dictUser.setObject("\(sender.tag)", forKey: "tag" as NSCopying)
        
        dictUser.setObject(strtempActionSet, forKey: "action" as NSCopying)
        dictUser.setObject(UserDefaults.standard.value(forKey: "applanguage") ?? "en", forKey: "language" as NSCopying)
        dictUser.setObject("notification", forKey: "v1" as NSCopying)
        self.performSelector(inBackground: #selector(self.LikeUnlikePostAPI), with: dictUser)
        
    }
    
    
    @IBAction func methodCancelSubmitComment(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if sender.tag != 0
        {
            if appDelegate.isInternetAvailable() == true
            {
                if txtmsgs.text != ""
                {
                    viewCommentPopup.removeFromSuperview()
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.ReplyAddCommentsAPI), with: nil)
                }
                else
                {
                    onShowAlertController(title: "Error" , message: "Plese enter some text.")
                }
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
        else
        {
            viewCommentPopup.removeFromSuperview()
        }
    }
    
    @IBAction func methodReplyCommentPost(_ sender: UIButton)
    {
        strCommentID = (self.arrAllPostComments.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "comment_id")
        
        lblUserName.text = (arrAllPostComments.object(at: sender.tag) as! NSDictionary).object(forKey: "user_name") as? String
        
        let imgUrl = (arrAllPostComments.object(at: sender.tag) as! NSDictionary).object(forKey: "user_avatar")
        imgPostUser.sd_addActivityIndicator()
        let url = URL.init(string: "\(imgUrl!)")
        imgPostUser.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            self.imgPostUser.sd_removeActivityIndicator()
        })
        
        let stringDes = (arrAllPostComments.object(at: sender.tag) as! NSDictionary).object(forKey: "comment") as? String
        if let decodedString = stringDes?.decode() {
            txtUserInfo.text = decodedString
        }
        else
        {
            txtUserInfo.text = stringDes
        }
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(viewCommentPopup)
        viewCommentPopup.frame = window.frame
    }
    
    @IBAction func methodNotificationUserProfile(_ sender: UIButton)
    {
        let OtherUser: OtherUserProfileScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            OtherUser  = OtherUserProfileScreen(nibName: "OtherUserProfile_Arabic",bundle:nil)
        }
        else
        {
            OtherUser  = OtherUserProfileScreen(nibName: "OtherUserProfileScreen",bundle:nil)
        }
        
        OtherUser.strOtherFriendID = (arrAllPostComments.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        OtherUser.strFromOtherPro = "FromOtherUser"
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }
    
    ///SharingSocialPopupShow
    @IBAction func methodSharingonSocialPopup(_ sender: UIButton)
    {
        strPostID = (self.arrPostDetails.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        
        let strPostImage = (arrPostDetails.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_image")
        var strPostContent =  (arrPostDetails.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_content")
        
        if strPostContent.characters.count > 190
        {
            strPostContent = String(strPostContent.prefix(150))
        }
        
        // text to share
        let shareURL = "\(Base_DOMAIN)post/share-post.php?iPostId="
        let strURL = String.init(format: "%@%@", shareURL,strPostID) + "\n" + strPostContent.decode()
        let url = URL.init(string: "\(strURL)")
        var objectsToShare = [strURL] as [Any]
        if (strPostImage != "")
        {
            let urlImage = URL.init(string: "\(strPostImage)")
            
            let urlData = NSData(contentsOf:urlImage!)
            if ((urlData) != nil)
            {
                let image = UIImage.init(data: urlData as! Data)
                objectsToShare = [strURL, image!] as [Any]
            }//comment!, imageData!, myWebsite!]
        }
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.setValue("Service/Product", forKey: "subject")
        //New Excluded Activities Code
        if #available(iOS 9.0, *)
        {
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.openInIBooks, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print]
        } else {
            // Fallback on earlier versions
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print ]
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - AnimatedTextField
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat!
        
        if ScreenSize.SCREEN_HEIGHT <= 568
        {
            movementDistance = -245
        }
        else if ScreenSize.SCREEN_HEIGHT == 736
        {
            movementDistance = -270
        }
        else if ScreenSize.SCREEN_HEIGHT == 812
        {
            movementDistance = -328
        }
        else if ScreenSize.SCREEN_HEIGHT == 667
        {
            movementDistance = -256
        }
        else
        {
            movementDistance = -285
        }
        
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    // MARK: - TextFieldsDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text == "" && string == " ")
        {            return false
        }
        return true
    }
    
    // MARK: - UITableViewMethods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.strFromTimeLine == "FromTimeLine"
        {
            return 1
        }
        else
        {
            if tableView.tag == 1000001
            {
                if self.arrAllPostComments.count > 0
                {
                    return 2
                }
                else
                {
                    return 1
                }
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 1000001
        {
            if indexPath.section == 0 && self.strFromTimeLine != "FromTimeLine"
            {
                
                if arrPostDetails.count > 0
                {
                    var height: CGFloat = 80.0 + 70.0
                    
                    let stringImage = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
                    let stringDes = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
                    
                    if stringImage != ""
                    {
                        height = height +  260.0
                    }
                    if stringDes != ""
                    {
                        let decodedString = stringDes.decode() ?? ""
                        let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                        if hh <= 20
                        {
                            height = height + 20
                        }
                        else
                        {
                            height = height + hh
                        }
                        
                    }
                    
                    return height
                }
                else
                {
                    return 0
                }
            }
            else
            {
                //
                if self.arrAllPostComments.count > 0
                {
                    return UITableViewAutomaticDimension
                    
                }
                else
                {
                    return 0
                }
            }
        }
        else
        {
            let dicMainComment = arrAllPostComments.object(at: tableView.tag) as! NSDictionary
            let arrReplyComment = dicMainComment.object(forKey: "comment_reply") as! NSArray
            let dicComment = arrReplyComment.object(at: indexPath.row) as! NSDictionary
            let stringDes = dicComment.valueForNullableKey(key: "tComment")
            let size = Method_HeightCalculation(text: stringDes, font: UIFont.init(name: "Lato-Regular", size: 13)!, width: ScreenSize.SCREEN_WIDTH - 116)
            return size + 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 1000001
        {
            if section == 0 && self.strFromTimeLine != "FromTimeLine"
            {
                if arrPostDetails.count > 0
                {
                    return arrPostDetails.count
                }
                return 0
            }
            else
            {
                if self.arrAllPostComments.count > 0
                {
                    return self.arrAllPostComments.count
                }
                else
                {
                    return 0
                }
            }
        }
        else
        {
            let dicMainComment = arrAllPostComments.object(at: tableView.tag) as! NSDictionary
            let arrReplyComment = dicMainComment.object(forKey: "comment_reply") as! NSArray
            if arrReplyComment.count > 0
            {
                return arrReplyComment.count
            }
            
            return  0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 1000001
        {
            if indexPath.section == 0 && self.strFromTimeLine != "FromTimeLine"
            {
                let identifier: String = "ProductDetailsTblCell"
                var cell: ProductDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ProductDetailsTblCell
                if (cell == nil)
                {
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("ProductDetailsTblCell_AR", owner: nil, options: nil)!
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("ProductDetailsTblCell", owner: nil, options: nil)! as [Any]
                    }
                    cell = nib[0] as? ProductDetailsTblCell
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = UIColor.clear
                }
                // Required float rating view params
                cell?.viewRating.emptyImage = UIImage(named: "greystar.png")
                cell?.viewRating.fullImage = UIImage(named: "starBig.png")
                
                // Optional params
                cell?.viewRating.isHidden = true
                
                cell?.lblNameTimeline.text = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                
                if (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String != ""
                {
                    let imgUrl = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image")
                    cell?.imgPost.sd_addActivityIndicator()
                    let url = URL.init(string: "\(imgUrl!)")
                    cell?.imgPost.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        cell?.imgPost.sd_removeActivityIndicator()
                    })
                    
                    //                        cell?.imgPost.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                    
                }
                if (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String != ""
                {
                    
                    let str =  (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as? String
                    if let decodedString = str?.decode() {
                        cell?.lblPostDetails.text = decodedString
                    }
                    else
                    {
                        cell?.lblPostDetails.text = str
                    }
                }
                
                let imgUrlUser = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                cell?.imgTimeline.sd_addActivityIndicator()
                let url1 = URL.init(string: "\(imgUrlUser!)")
                cell?.imgTimeline.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url1) in
                    cell?.imgTimeline.sd_removeActivityIndicator()
                })
                cell?.lblTimeAgo.isHidden = true
                cell?.btnDelete.isHidden = true
                
                if  (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_like") as! String  == "1"
                {
                    cell?.btnLike.isSelected = true
                }
                else
                {
                    cell?.btnLike.isSelected = false
                }
                
                cell?.btnSharing.tag = indexPath.row
                
                cell?.btnSharing.addTarget(self, action: #selector(methodSharingonSocialPopup), for: .touchUpInside)
                
                cell?.lblLikeCount.text = String.init(format: "(%@)", (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "likes") as! CVarArg)
                
                let stringDesc = String.init(format: "(%@)", (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "comments") as! CVarArg)
                if let decodedString : String = stringDesc.decode() {
                    cell?.lblComment.text = decodedString
                }
                else
                {
                    cell?.lblComment.text = stringDesc
                }
                
                cell?.btnLike.tag = indexPath.row
                cell?.btnLike.addTarget(self, action: #selector(methodLikeUnlikePost), for: .touchUpInside)
                
                let stringImage = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
                
                var stringDescription = (arrPostDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
                
                if stringDescription != ""
                {
                    cell?.lblPostDetails.isHidden = false
                    
                    if let decodedString : String = stringDescription.decode() {
                        stringDescription = decodedString
                    }
                    let hh = getLabelHeight(text: stringDescription, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                    
                    var frame = (cell?.lblPostDetails.frame)!
                    
                    if stringImage == ""
                    {
                        cell?.imgPost.isHidden = true
                        frame.origin.y = cell!.imgPost.frame.origin.y
                    }
                    else
                    {
                        cell?.imgPost.isHidden = false
                        frame.origin.y = cell!.imgPost.frame.origin.y + cell!.imgPost.frame.size.height + 8
                    }
                    
                    frame.size.height = hh
                    cell?.lblPostDetails.text = stringDescription
                    
                    if hh <= 20
                    {
                        frame.size.height = 20
                    }
                    else
                    {
                        frame.size.height = hh
                    }
                    cell?.lblPostDetails.frame = frame
                }
                else
                {
                    cell?.lblPostDetails.isHidden = true
                }
                
                return cell!
            }
            else
            {
                let identifier: String = "AddCommentTblCell"
                var cell: AddCommentTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? AddCommentTblCell
                if (cell == nil)
                {
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("AddCommentTblCell_AR", owner: nil, options: nil)!
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("AddCommentTblCell", owner: nil, options: nil)! as [Any]
                    }
                    cell = nib[0] as? AddCommentTblCell
                }
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                //cell?.backgroundColor = UIColor.clear
                
                if (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
                {
                    cell?.lblPostUserName.text = (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as? String
                }
                else
                {
                    let strWorkingPost = (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as? String
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "super_user_ic_badge.png")
                    attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                    let attachmentStr = NSAttributedString(attachment: attachment)
                    let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                    myString.append(attachmentStr)
                    cell?.lblPostUserName.attributedText = myString
                }
                
                let imgUrl = (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                cell?.imgPostUser.sd_addActivityIndicator()
                let url = URL.init(string: "\(imgUrl!)")
                cell?.imgPostUser.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgPostUser.sd_removeActivityIndicator()
                })
                //                    cell?.imgPostUser.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                
                
                let dicMainComment = arrAllPostComments.object(at: indexPath.row) as! NSDictionary
                let arrReplyComment = dicMainComment.object(forKey: "comment_reply") as! NSArray
                if arrReplyComment.count > 0
                {
                    var ReplytblHeight:CGFloat = 0.0
                    for dicComment in arrReplyComment
                    {
                        let stringDes = (dicComment as! NSDictionary).valueForNullableKey(key: "tComment")
                        let size = Method_HeightCalculation(text: stringDes,font: UIFont.init(name: "Lato-Regular", size: 13)!, width: ScreenSize.SCREEN_WIDTH - 92)
                        
                        ReplytblHeight = ReplytblHeight + (size + 34)
                    }
                    cell?.tblRepliesHeight.constant = ReplytblHeight
                    //   return CGFloat((194) + ReplytblHeight + size)
                }
                else
                {
                    cell?.tblRepliesHeight.constant = 0
                }
                
                
                let stringDes = (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).object(forKey: "comment") as! String
                if stringDes != ""
                {
                    if let decodedString : String = stringDes.decode() {
                        cell?.lblComment.text = decodedString
                    }
                    else
                    {
                        cell?.lblComment.text = stringDes
                    }
                }
                
                cell?.lblLikesCount.text = String.init(format: "(%@)", (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).object(forKey: "likes") as! CVarArg)
                
                if arrReplyComment.count > 0
                {
                    cell?.lblCommentsCount.text = String.init(format: "(%@)", "\(arrReplyComment.count)")
                }
                
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    
                    cell?.btnReply.setTitle("Reply".localized, for: .normal)
                }
                
                if  (arrAllPostComments.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "is_like")  == "1"
                {
                    cell?.btnLikes.isSelected = true
                }
                else
                {
                    cell?.btnLikes.isSelected = false
                }
                
                cell?.btnReply.tag = indexPath.row
                cell?.btnReply.addTarget(self, action: #selector(methodReplyCommentPost), for: .touchUpInside)
                
                cell?.btnLikes.tag = indexPath.row
                cell?.btnLikes.addTarget(self, action: #selector(methodLikeUnlikeComments), for: .touchUpInside)
                //  cell?.tblReplyComment.backgroundColor = UIColor.red
                cell?.tblReplyComment.tag = indexPath.row
                cell?.tblReplyComment.delegate = self
                cell?.tblReplyComment.dataSource = self
                cell?.tblReplyComment.reloadData()
                
                cell?.btnUserDetails.tag = indexPath.row
                cell?.btnUserDetails.addTarget(self, action: #selector(methodNotificationUserProfile), for: .touchUpInside)
                
                return cell!
            }
        }
        else
        {
            let identifier: String = "ReplyCommentTblCell"
            var cell: ReplyCommentTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReplyCommentTblCell
            if (cell == nil)
            {
                let nib:Array<Any>!
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    nib = Bundle.main.loadNibNamed("ReplyCommentTblCell_AR", owner: nil, options: nil)!
                }
                else
                {
                    nib = Bundle.main.loadNibNamed("ReplyCommentTblCell", owner: nil, options: nil)! as [Any]
                }
                
                cell = nib[0] as? ReplyCommentTblCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = UIColor.clear
            let dicMainComment = arrAllPostComments.object(at: tableView.tag) as! NSDictionary
            let arrReplyComment = dicMainComment.object(forKey: "comment_reply") as! NSArray
            let dicComment = arrReplyComment.object(at: indexPath.row) as! NSDictionary
            
            cell?.lblName.text = "@" + dicComment.valueForNullableKey(key: "user_name")
            let stringDes1 = dicComment.valueForNullableKey(key: "tComment")
            if let decodedString : String = stringDes1.decode() {
                cell?.lblDetails.text = decodedString
            }
            else
            {
                cell?.lblDetails.text = stringDes1
            }
            
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func getCellHeight(stringImage: String)
    {
        
        if let imageSource = CGImageSourceCreateWithURL(URL(string: stringImage) as! CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
                DispatchQueue.main.async {
                    let ratioheight = self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(pixelHeight)/CGFloat(pixelWidth))
                    
                    let dicSizes = (UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()).mutableCopy() as! NSMutableDictionary
                    
                    dicSizes.setObject("\(ratioheight)", forKey: stringImage as NSCopying)
                    UserDefaults.standard.set(dicSizes, forKey: "dicSizes")
                    UserDefaults.standard.synchronize()
                    self.tblNotificationList.reloadData()
                }
            }
        }
    }
    
    @objc func LikeUnlikePostAPI(dicLike : NSMutableDictionary)
    {
        getallApiResultwithGetMethod(strMethodname: kMethodLikeUnlikeComment, Details: dicLike) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
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
    
    // MARK:- LikeUnlike API Integration.................
    func SinglePostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        return dictUser
    }
    
    @objc func SinglePostDetailsAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodSinglePost, Details: self.SinglePostParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("self.arrPostDetails",responseData!)
                        self.arrPostDetails = (responseData?.object(forKey: "post_data")as!NSArray).mutableCopy() as! NSMutableArray
                    }
                    else
                    {
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    self.tblNotificationList.reloadData()
                }
            }
        }
    }
    // MARK:- LikeUnlike API Integration.................
    func ReplyAddCommentsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        dictUser.setObject(txtmsgs.text!.encode(), forKey: "comment" as NSCopying)
        
        dictUser.setObject(strCommentID, forKey: "comment_id" as NSCopying)
        dictUser.setObject("notification", forKey: "v1" as NSCopying)
        return dictUser
    }
    
    @objc func ReplyAddCommentsAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodReplyAddComments, Details: self.ReplyAddCommentsParams()) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.txtAddComments.text = ""
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.PostCommentsAPI), with: nil)
                    }
                    else
                    {
                        // print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    self.tblNotificationList.reloadData()
                }
            }
        }
    }
    
    // MARK:- LikeUnlike API Integration.................
    func AddCommentsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        dictUser.setObject(txtAddComments.text!.encode(), forKey: "comment" as NSCopying)
        dictUser.setObject("notification", forKey: "v1" as NSCopying)

        return dictUser
    }
    
    @objc func AddCommentsAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAddComments, Details: self.AddCommentsParams()) { (responseData, error) in
            
            DispatchQueue.main.async {
                if error == nil
                {
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.PostCommentsAPI), with: nil)
                    }
                    else
                    {
                    }
                }
            }
        }
    }
    
    // MARK:- LikeUnlike API Integration.................
    func PostCommentsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        
        return dictUser
    }
    
    @objc func PostCommentsAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodPostComments, Details: self.PostCommentsParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.txtmsgs.text = ""
                        self.txtAddComments.text = ""
                        
                        self.arrAllPostComments = (responseData?.object(forKey: "comment_data")as!NSArray).mutableCopy() as! NSMutableArray
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFollowerCount"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLikeUnlike"), object: nil)
                    }
                    else
                    {
                    }
                    self.tblNotificationList.reloadData()
                }
            }
        }
    }
    
    // MARK:- MyLike API Integration.................
    //    func MyLikePostParams() -> NSMutableDictionary
    //    {
    //        let dictUser = NSMutableDictionary()
    //
    //       dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
    //        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
    //
    //        return dictUser
    //    }
    
    @objc func MyLikePostAPI(dicLike : NSMutableDictionary)
    {
        getallApiResultwithGetMethod(strMethodname: kMethodLikeUnlike, Details: dicLike) { (responseData, error) in
            
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey:"response") as! String
                    == "1"
                {
                    //    print("responseData",responseData!)
                }
                else
                {
                    print("response: Else Part: - ",responseData!)
                }
            }
        }
        
    }
    
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: dt!)
    }
    
    
    
    
}

extension NotificationAddComment: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
