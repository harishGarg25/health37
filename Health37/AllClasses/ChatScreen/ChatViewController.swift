//
//  ChatViewController.swift
//  LunchBox
//
//  Created by RamPrasad-IOS on 28/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import GrowingTextView

class ChatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate  {
    
    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var tblMsgList: UITableView!
    @IBOutlet var btnSend: UIButton!
    // @IBOutlet var txtmsgs: UITextField!
    @IBOutlet var viewTxtFBG: UIView!
    
    @IBOutlet weak var txtmsgs: GrowingTextView!
    @IBOutlet  var viewBottomTxtField: UIView!
    var  arrExpendedRow = NSMutableArray()
    
    var safeAreaBottom:CGFloat = 0
    
    var strFriendID = ""
    var strFriendName = ""
    var strConversationID = ""
    
    @IBOutlet var ViewImageHideHeight: NSLayoutConstraint!
    var  arrChatDetails = NSMutableArray()
    var imagePicker = UIImagePickerController()
    
    var strSltChatType = "" 
    @IBOutlet var lblFriendName: UILabel!
    
    var imgUpload = UIImageView()
    var imgDataUpload = Data()
    @IBOutlet var imgChoosePost: UIImageView!
    //      @IBOutlet  var textView: UITextView!
    @IBOutlet var viewSendImage: UIView!
    
    @IBOutlet var viewcommenttext: NSLayoutConstraint!
    
    var timer: Timer?
    var strScroll = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.strScroll = "Scrolling"
        viewSendImage.layer.masksToBounds = true
        txtmsgs.delegate = self
        txtmsgs.trimWhiteSpaceWhenEndEditing = false
        txtmsgs.minHeight = 30.0
        txtmsgs.maxHeight = 150.0
        lblFriendName.text = "\(strFriendName)"
        btnRemove.layer.cornerRadius = 8.0
        btnRemove.layer.borderWidth = 1.0
        btnRemove.layer.borderColor = UIColor.init(red: 31/255.0, green: 89/255.0, blue: 101/255.0, alpha: 1.0).cgColor
        
        
        if #available(iOS 11.0, *)
        {
            let window = UIApplication.shared.keyWindow
            //            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            
            safeAreaBottom = bottomPadding!
            //            safeAreaTop = topPadding!
        }
        
        
        //        textvi.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        ViewImageHideHeight.constant = 0
        viewSendImage.isHidden = true
        DispatchQueue.main.async
            {
                //                let yAxis = self.appDelegate.window!.frame.size.height - self.viewBottomTxtField.frame.size.height - self.safeAreaBottom
                //
                //                self.viewBottomTxtField.frame = CGRect (x: 0, y: yAxis, width: self.viewBottomTxtField.frame.size.width, height: self.viewBottomTxtField.frame.size.height)
                //
                //                self.tblMsgList.frame = CGRect(x: 0, y: 80, width: self.appDelegate.window!.frame.size.width, height: self.appDelegate.window!.frame.size.height - (self.viewBottomTxtField.frame.size.height + 80) - self.safeAreaBottom)
                
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.ChatDetailsAPICall), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
                
        }
        
        //        let index = IndexPath.init(row: self.arrChatDetails.count - 1, section: 0)
        //        self.tblMsgList.scrollToRow(at: index , at: .bottom, animated: false)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            //   btnSubmit.setTitle("SUBMIT".localized, for: .normal)
            //   btnNoThanks.setTitle("NO, THANKS".localized, for: .normal)
            txtmsgs.placehold = "Add Message...".localized
        }
        
        viewTxtFBG.layer.cornerRadius = viewTxtFBG.frame.height/2
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(resignTextView))
        tap.delegate = self
        tblMsgList.addGestureRecognizer(tap)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self,
                                              selector: #selector(self.timerDidFire(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    // Timer expects @objc selector
    @objc private func timerDidFire(timer: Timer)
    {
        self.performSelector(inBackground: #selector(self.ChatDetailsAPICall), with: nil)
    }
    
    //MARK:- Chat Methods
    @objc func resignTextView()
    {
        txtmsgs.resignFirstResponder()
        //        var containerFrame : CGRect
        //        containerFrame = viewBottomTxtField.frame
        //        containerFrame.origin.y = appDelegate.window!.frame.size.height - containerFrame.size.height - safeAreaBottom
        //        viewBottomTxtField.frame = containerFrame
        
        //        tblMsgList.frame = CGRect(x: 0, y: 80, width: appDelegate.window!.frame.size.width, height: viewBottomTxtField.frame.origin.y-80)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //self.animateTextField(textField: textField, up:false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    // MARK: - ButtonsMethod
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func methodSendMSG(_ sender: Any)
    {
        // self.view.endEditing(true)
        if imgUpload.image == nil && txtmsgs.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            self.onShowAlertController(title: kInternetError.localized , message: "Please write something or atleast select a photo.".localized)
        }
        else
        {
            DispatchQueue.main.async
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.MessageSendAPICall), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
            }
        }
    }
    @IBAction func methodRemoveImage(_ sender: Any)
    {
        imgUpload.image = nil
        imgChoosePost.image = nil
        btnRemove.isHidden = true
        self.ViewImageHideHeight.constant = 0
        self.viewSendImage.isHidden = true
        
    }
    @IBAction func methodChatUserDetails(_ sender: UIButton)
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
        OtherUser.strOtherFriendID = strFriendID//(self.arrChatDetails.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }
    @IBAction func methodChatTimeLine(_ sender: UIButton)
    {
        let Timeline: TimelineScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Timeline  = TimelineScreen(nibName: "Timeline_Arabic",bundle:nil)
        }
        else
        {
            Timeline  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
        }
        
        Timeline.strTabbarClick = "FromTimeLine"
        self.navigationController?.pushViewController(Timeline, animated: true)
    }
    @IBAction func methodImageLargeView(_ sender: UIButton)
    {
        
        let ProductD  = ProductImageDtlsScreen(nibName: "ProductImageDtlsScreen",bundle:nil)
        ProductD.dicAllPosts = self.arrChatDetails.object(at: sender.tag) as! NSDictionary//).object(forKey: "image")
        ProductD.strFromChat = "FromChat"
        self.navigationController?.pushViewController(ProductD, animated: true)
    }
    
    @IBAction func methodChoosePicture(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "Chose image".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { _ in
            self.openCamera()
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
        
        //        if sender.tag == 0
        //        {
        //            selectedButton = 0
        //        }
        //        else
        //        {
        //            selectedButton = 1
        //        }
        
    }
    
    //MARK:- User Defind Methods............
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
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
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
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
        btnRemove.isHidden = false
        imgChoosePost.image = image
        imgUpload.image = image
        imgDataUpload = (UIImageJPEGRepresentation(image, 0.7) as NSData!) as Data
        ViewImageHideHeight.constant = 180
        viewSendImage.isHidden = false
        if self.arrChatDetails.count > 0
        {
            let index = IndexPath.init(row: self.arrChatDetails.count - 1, section: 0)
            self.tblMsgList.scrollToRow(at: index , at: .top, animated: false)
        }
        
    }
    //    override func viewDidLayoutSubviews()
    //    {
    //        super.viewDidLayoutSubviews()
    //
    //        if textView.frame.size.height >= tblVW.frame.size.height/2
    //        {
    //            textView.isScrollEnabled = true
    //        }
    //        // scrollToBottom(force: false)
    //    }
    //MARK:- Keyboard Methods
    @objc func keyboardWillChangeFrame(notification: NSNotification)
    {
        //        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let keyboardHeight = keyboardFrame.size.height
            viewcommenttext.constant = -keyboardHeight
        }
    }
    
    @objc func KeyboardWillHide()
    {
        // txtmsgs.resignFirstResponder()
        viewcommenttext.constant = 0
    }
    
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" && text == " "
    //        {
    //            return false
    //        }
    //        if  textView.contentSize.height <= tblVW.frame.size.height/2
    //        {
    //            textView.isScrollEnabled = false
    //        }
    //        return true
    //    }
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrChatDetails.count > 0
        {
            return arrChatDetails.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //        return UITableViewAutomaticDimension
        if arrChatDetails.count > 0
        {
            if (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String != ""
            {
                var height: CGFloat = 80.0
                let imgHeight: CGFloat = 166.0
                
                let stringDes = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String
                let imgUrl = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "image") as! String
                
                if stringDes != "" && imgUrl != ""
                {
                    let decodedString = stringDes.decode() ?? ""
                    let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                    if hh <= 100
                    {
                        height = height + hh + imgHeight
                    }
                    else
                    {
                        height = imgHeight + height + (arrExpendedRow.contains(indexPath.row) ? hh : 80)
                    }
                    return height
                }
                else if stringDes != ""
                {
                    let decodedString = stringDes.decode() ?? ""
                    let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                    if hh <= 100
                    {
                        height = height + hh
                    }
                    else
                    {
                        height =  height + (arrExpendedRow.contains(indexPath.row) ? hh : 80)
                    }
                    return height
                }
                else if imgUrl != ""
                {
                    height = height + imgHeight
                    
                    return height
                }
                
                return height
                
            }
            else
            {
                //                var height: CGFloat = 80.0
                //
                //                let stringDes = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String
                //                if stringDes != ""
                //                {
                //                    let hh = getLabelHeight(text: stringDes, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                //                    if hh <= 90
                //                    {
                //                        height = height + hh
                //                    }
                //                    else
                //                    {
                //                        height = height + (arrExpendedRow.contains(indexPath.row) ? hh : 80)
                //                    }
                //
                //                }
                tblMsgList.estimatedRowHeight = 80
                tblMsgList.rowHeight = UITableViewAutomaticDimension
                
                return UITableViewAutomaticDimension
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if "\(UserDefaults.standard.object(forKey: kUserID)!)" == (arrChatDetails.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
        {
            let dicChat = self.arrChatDetails.object(at: indexPath.row) as! NSDictionary
            if dicChat.object(forKey: "image") as! String != ""
            {
                let cellIdentifier:String = "ChatImageTblCell"
                var cell:ChatImageTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatImageTblCell
                
                if (cell == nil)
                {
                    //  let nib:Array = Bundle.main.loadNibNamed("ChatImageTblCell", owner: nil, options: nil)! as [Any]
                    
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("ChatImageTblCell_AR", owner: nil, options: nil)!
                        
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("ChatImageTblCell", owner: nil, options: nil)! as [Any]
                    }
                    
                    
                    cell = nib[0] as? ChatImageTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                //                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                //                {
                //                    cell?.imgPost.roundCorners([ .topLeft], radius: 15.0)
                //
                //                }
                //                else
                //                {
                //                    cell?.imgPost.roundCorners([ .topLeft], radius: 15.0)
                //                }
                
                //            //ForIncraseSeparatorSize
                //            cell?.preservesSuperviewLayoutMargins = false
                //            cell?.separatorInset = UIEdgeInsets.zero
                //            cell?.layoutMargins = UIEdgeInsets.zero
                cell?.viewCellBG.isHidden = true
                
                let imgUrl = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "image")
                cell?.imgPost.sd_addActivityIndicator()
                let url = URL.init(string: "\(imgUrl!)")
                cell?.imgPost.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgPost.sd_removeActivityIndicator()
                })
                
                //                cell?.imgPost.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                
                let stringDes = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String
                if stringDes != ""
                {
                    //                    let hh = getLabelHeight(text: stringDes, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                    //
                    //                    var frame = (cell?.lblPostDetails.frame)!
                    //                    frame.size.height = hh
                    if let decodedString : String = stringDes.decode() as? String {
                        cell?.lblPostDetails.text = decodedString
                    }
                    else
                    {
                        cell?.lblPostDetails.text = stringDes
                    }
                    
                    
                    //                    if hh > 110.0
                    //                    {
                    //                        frame.size.height = arrExpendedRow.contains(indexPath.row) ? hh : 110
                    //                    }
                    //                    cell?.lblPostDetails.frame = frame
                    
                }
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    cell?.lblTime.text = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "conversation_time_month")as? String
                }
                else
                {
                    ////Date Format
                    let formateSearch = DateFormatter()
                    formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    formateSearch.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                    
                    //                if  formateSearch.date(from: ((arrConverations.object(at: 0) as! NSDictionary).object(forKey: "conversation_time")as? String)!) != nil
                    //                {
                    let  strBookingDate = formateSearch.date(from: ((arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "dateTime")as? String)!)
                    
                    let   strSendtime = (timeAgo(strBookingDate!))
                    
                    cell?.lblTime.text = strSendtime
                }
                
                if "\(UserDefaults.standard.object(forKey: kUserID)!)" == (arrChatDetails.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
                {
                    let imgUrl = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                    
                    cell?.imgUserPro.sd_addActivityIndicator()
                    let url = URL.init(string: "\(imgUrl!)")
                    cell?.imgUserPro.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        cell?.imgUserPro.sd_removeActivityIndicator()
                    })
                    
                }
                cell?.btnUserProfile.tag = indexPath.row
                cell?.btnUserProfile.addTarget(self, action: #selector(methodChatTimeLine), for: .touchUpInside)
                cell?.btnImgInfoFirst.tag = indexPath.row
                cell?.btnImgInfoFirst.addTarget(self, action: #selector(methodImageLargeView), for: .touchUpInside)
                
                return cell!
            }
            else
            {
                let cellIdentifier:String = "ChatRoomOtherTblCell"
                var cell:ChatRoomOtherTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRoomOtherTblCell
                
                if (cell == nil)
                {
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("ChatRoomOtherTblCell_AR", owner: nil, options: nil)!
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("ChatRoomOtherTblCell", owner: nil, options: nil)! as [Any]
                    }
                    
                    // let nib:Array = Bundle.main.loadNibNamed("ChatRoomOtherTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? ChatRoomOtherTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                //ForIncraseSeparatorSize
                cell?.preservesSuperviewLayoutMargins = false
                cell?.separatorInset = UIEdgeInsets.zero
                cell?.layoutMargins = UIEdgeInsets.zero
                
                //   cell?.lblMSG.text = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as? String
                
                ////Date Format
                let formateSearch = DateFormatter()
                formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formateSearch.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                //                if  formateSearch.date(from: ((arrConverations.object(at: 0) as! NSDictionary).object(forKey: "conversation_time")as? String)!) != nil
                //                {
                let  strBookingDate = formateSearch.date(from: ((arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "dateTime")as? String)!)
                
                let   strSendtime = (timeAgo(strBookingDate!))
                
                cell?.lblTimes.text = strSendtime
                
                let imgUrl = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                
                cell?.imgUserFriend.sd_addActivityIndicator()
                let url = URL.init(string: "\(imgUrl!)")
                cell?.imgUserFriend.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgUserFriend.sd_removeActivityIndicator()
                })
                
                let stringDes = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String
                if stringDes != ""
                {
                    //                let hh = getLabelHeight(text: stringDes, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                    //
                    //                var frame = (cell?.lblMSG.frame)!
                    //                frame.size.height = hh
                    
                    if let decodedString : String = stringDes.decode() as? String {
                        cell?.lblMSG.text = decodedString
                    }
                    else
                    {
                        cell?.lblMSG.text = stringDes
                    }
                    
                    
                    //                if hh > 110.0
                    //                {
                    //                    frame.size.height = arrExpendedRow.contains(indexPath.row) ? hh : 110
                    //                }
                    //                cell?.lblMSG.frame = frame
                    // cell?.lblMSG.frame = CGRect.init(x: (cell?.lblMSG.frame.origin.x)! + 2, y: (cell?.imgTextMessage.frame.origin.y)!, width: (cell?.lblMSG.frame.size.width)!, height: (cell?.lblMSG.frame.size.height)!)
                }
                cell?.btnUserProfile.tag = indexPath.row
                cell?.btnUserProfile.addTarget(self, action: #selector(methodChatTimeLine), for: .touchUpInside)
                
                return cell!
            }
        }
        else
        {
            let dicChat = self.arrChatDetails.object(at: indexPath.row) as! NSDictionary
            
            if dicChat.object(forKey: "image") as! String != ""
            {
                let cellIdentifier:String = "ChatImageTblCell"
                var cell:ChatImageTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatImageTblCell
                
                if (cell == nil)
                {
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("ChatImageTblCell_AR", owner: nil, options: nil)!
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("ChatImageTblCell", owner: nil, options: nil)! as [Any]
                    }
                    //  let nib:Array = Bundle.main.loadNibNamed("ChatImageTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? ChatImageTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                //                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                //                {
                //                    cell?.imgPost2.roundCorners([ .topRight], radius: 15.0)
                //                }
                //                else
                //                {
                //                    cell?.imgPost2.roundCorners([ .topRight], radius: 15.0)
                //                }
                //            //ForIncraseSeparatorSize
                cell?.preservesSuperviewLayoutMargins = false
                cell?.separatorInset = UIEdgeInsets.zero
                cell?.layoutMargins = UIEdgeInsets.zero
                
                let imgUrl = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                cell?.viewCellBG.isHidden = false
                
                
                cell?.imgUserPro2.sd_addActivityIndicator()
                let url = URL.init(string: "\(imgUrl!)")
                cell?.imgUserPro2.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgUserPro2.sd_removeActivityIndicator()
                })
                
                let imgUrl1 = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "image")
                cell?.imgPost2.sd_addActivityIndicator()
                let url1 = URL.init(string: "\(imgUrl1!)")
                cell?.imgPost2.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgPost2.sd_removeActivityIndicator()
                })
                //                cell?.imgPost.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                
                let stringDes = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String
                if stringDes != ""
                {
                    //                    let hh = getLabelHeight(text: stringDes, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                    //
                    //                    var frame = (cell?.lblPostDetails.frame)!
                    //                    frame.size.height = hh
                    if let decodedString : String = stringDes.decode() as? String{
                        cell?.lblPostDetails2.text = decodedString
                    }
                    else
                    {
                        cell?.lblPostDetails2.text = stringDes
                    }
                    
                    
                    //                    if hh > 120.0
                    //                    {
                    //                        frame.size.height = arrExpendedRow.contains(indexPath.row) ? hh : 120
                    //                    }
                    //                    cell?.lblPostDetails.frame = frame
                    //   cell?.lblPostDetails.frame = CGRect.init(x: (cell?.lblPostDetails.frame.origin.x)! + 2, y: (cell?.imgPostBG.frame.origin.y)!, width: (cell?.lblPostDetails.frame.size.width)!, height: (cell?.lblPostDetails.frame.size.height)!)
                }
                
                ////Date Format
                let formateSearch = DateFormatter()
                formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formateSearch.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                //                if  formateSearch.date(from: ((arrConverations.object(at: 0) as! NSDictionary).object(forKey: "conversation_time")as? String)!) != nil
                //                {
                let  strBookingDate = formateSearch.date(from: ((arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "dateTime")as? String)!)
                
                let   strSendtime = (timeAgo(strBookingDate!))
                
                cell?.lblTime2.text = strSendtime
                
                cell?.btnUserProfile2.tag = indexPath.row
                cell?.btnUserProfile2.addTarget(self, action: #selector(methodChatTimeLine), for: .touchUpInside)
                
                cell?.btnImgInfo.tag = indexPath.row
                cell?.btnImgInfo.addTarget(self, action: #selector(methodImageLargeView), for: .touchUpInside)
                
                return cell!
            }
            else
            {
                let cellIdentifier:String = "ChatRoomUserTblCell"
                var cell:ChatRoomUserTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRoomUserTblCell
                
                if (cell == nil)
                {
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("ChatRoomUserTblCell_AR", owner: nil, options: nil)!
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("ChatRoomUserTblCell", owner: nil, options: nil)! as [Any]
                    }
                    
                    //let nib:Array = Bundle.main.loadNibNamed("ChatRoomUserTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? ChatRoomUserTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                //ForIncraseSeparatorSize
                cell?.preservesSuperviewLayoutMargins = false
                cell?.separatorInset = UIEdgeInsets.zero
                cell?.layoutMargins = UIEdgeInsets.zero
                
                let imgUrl = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                
                cell?.imgUserSelf.sd_addActivityIndicator()
                let url = URL.init(string: "\(imgUrl!)")
                cell?.imgUserSelf.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell?.imgUserSelf.sd_removeActivityIndicator()
                })
                
                ////Date Format
                let formateSearch = DateFormatter()
                formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formateSearch.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                //                if  formateSearch.date(from: ((arrConverations.object(at: 0) as! NSDictionary).object(forKey: "conversation_time")as? String)!) != nil
                //                {
                let  strBookingDate = formateSearch.date(from: ((arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "dateTime")as? String)!)
                
                let   strSendtime = (timeAgo(strBookingDate!))
                
                cell?.lblTimes.text = strSendtime
                let stringDes = (arrChatDetails.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as! String
                if stringDes != ""
                {
                    //                let hh = getLabelHeight(text: stringDes, width: ScreenSize.SCREEN_WIDTH - 54, font: UIFont.init(name: "Lato-Regular", size: 14)!)
                    //
                    //                var frame = (cell?.lblMSG.frame)!
                    //                frame.size.height = hh
                    if let decodedString : String = stringDes.decode() as? String {
                        cell?.lblMSG.text = decodedString
                    }
                    else
                    {
                        cell?.lblMSG.text = stringDes
                    }
                    
                    
                    //                if hh > 110.0
                    //                {
                    //                    frame.size.height = arrExpendedRow.contains(indexPath.row) ? hh : 110
                    //                }
                    //                cell?.lblMSG.frame = frame
                    
                    //  cell?.lblMSG.frame = CGRect.init(x: (cell?.lblMSG.frame.origin.x)! + 2, y: (cell?.imgTextMessage.frame.origin.y)!, width: (cell?.lblMSG.frame.size.width)!, height: (cell?.lblMSG.frame.size.height)!)
                    
                    //  cell?.imgTextMessage.frame = CGRect.init(x: (cell?.imgTextMessage.frame.origin.x)!, y: (cell?.imgTextMessage.frame.origin.y)!, width: (cell?.lblMSG.frame.size.width)!, height: (cell?.imgTextMessage.frame.size.height)!)
                }
                cell?.btnUserProfile.tag = indexPath.row
                cell?.btnUserProfile.addTarget(self, action: #selector(methodChatUserDetails), for: .touchUpInside)
                
                return cell!
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    // MARK:- Delete API Integration.................
    func ChatDetailsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
            dictUser.setObject(strFriendID, forKey: kFriendID as NSCopying)
        }
        
        return dictUser
    }
    
    @objc func ChatDetailsAPICall()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodChatFriendDetails, Details: self.ChatDetailsParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        if responseData?.valueForNullableKey(key: "conversation_id") != nil
                        {
                            self.strConversationID = (responseData?.valueForNullableKey(key: "conversation_id"))!
                        }
                        if (responseData?.object(forKey: "conversation_data")as!NSArray).count > 0
                        {
                            self.arrChatDetails = (responseData?.object(forKey: "conversation_data")as!NSArray).mutableCopy() as! NSMutableArray
                            print("self.arrChatDetails",self.arrChatDetails)
                            self.tblMsgList.reloadData()
                            
                            if (self.strScroll == "Scrolling")
                            {
                                if self.arrChatDetails.count > 0
                                {
                                    let index = IndexPath.init(row: self.arrChatDetails.count - 1, section: 0)
                                    self.tblMsgList.scrollToRow(at: index , at: .bottom, animated: false)
                                }
                                self.strScroll = "NotScrolling"
                            }
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChatInboxDetails"), object: nil)
                        self.tblMsgList.reloadData()
                    }
                    else
                    {
                    }
                }
            }
            
        }
    }
    
    // MARK:- Delete API Integration.................
    func MessageSendParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strFriendID, forKey: kFriendID as NSCopying)
        
        if strConversationID != ""
        {
            dictUser.setObject(strConversationID, forKey: "conversation_id" as NSCopying)
        }
        else
        {
            dictUser.setObject("", forKey: "conversation_id" as NSCopying)
        }
        dictUser.setObject(txtmsgs.text!.encode(), forKey: "msg" as NSCopying)
        dictUser.setObject("notification", forKey: "v1" as NSCopying)
        
        return dictUser
    }
    
    @objc func MessageSendAPICall()
    {
        getallApiResultwithimagePostMethod(strMethodname: kMethodMessageSend, imgData: imgDataUpload, strImgKey: "image", Details: self.MessageSendParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.imgUpload.image = nil
                        self.imgChoosePost.image = nil
                        self.ViewImageHideHeight.constant = 0
                        self.viewSendImage.isHidden = true
                        
                        self.btnRemove.isHidden = true
                        self.txtmsgs.text = ""
                        
                        let index = IndexPath.init(row: self.arrChatDetails.count - 1, section: 0)
                        self.tblMsgList.scrollToRow(at: index , at: .bottom, animated: false)
                        
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.ChatDetailsAPICall), with: nil)
                        
                    }
                    else
                    {
                        // self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    //   self.tblMsgList.reloadData()
                }
            }
        }
    }
    
    func timeAgo(_ compareDate: Date) -> String
    {
        let timeInterval: TimeInterval = -compareDate.timeIntervalSinceNow
        var temp: Int = 0
        var result: String
        
        if timeInterval < 60 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            //            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
            //            let datesend = dateFormatter.date(from: dateStr)
            dateFormatter.timeZone = NSTimeZone.system
            result =  dateFormatter.string(from: compareDate)
            //            let datetime = dateFormatter.date(from: strSendtime)
            
            //            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            //
            //            let str = dateFormatter.string(from: compareDate)
            //            dateFormatter.timeZone = TimeZone.current
            //            dateFormatter.dateFormat = "HH:mm"
            //
            //            let newdatebooking = dateFormatter.date(from: str)
            //
            //            result = "\(dateFormatter.string(from: newdatebooking!))"          //less than a minute
        }
        else
        {
            temp = Int(timeInterval / 60.0)
            
            if temp < 60
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                //  dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                //                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                //                let str = dateFormatter.string(from: compareDate)
                //                dateFormatter.timeZone = TimeZone.current
                //                dateFormatter.dateFormat = "HH:mm"
                //                let newdatebooking = dateFormatter.date(from: str)
                //                result = "\(dateFormatter.string(from: newdatebooking!))"
                dateFormatter.timeZone = NSTimeZone.system
                result =  dateFormatter.string(from: compareDate)
            }
            else
            {
                temp = temp / 60
                
                if temp < 24 {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    //  dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    //  dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                    //                    dateFormatter.timeZone = TimeZone(identifier: "UTC")
                    //
                    //                    let str = dateFormatter.string(from: compareDate)
                    //                    dateFormatter.timeZone = TimeZone.current
                    //                    dateFormatter.dateFormat = "HH:mm"
                    //                    let newdatebooking = dateFormatter.date(from: str)
                    //
                    //                    result = "\(dateFormatter.string(from: newdatebooking!))" //7 days ago
                    dateFormatter.timeZone = NSTimeZone.system
                    result =  dateFormatter.string(from: compareDate)
                }
                else
                {
                    temp = temp / 24
                    
                    if temp < 7
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEEE, HH:mm"
                        dateFormatter.timeZone = NSTimeZone.system
                        result =  dateFormatter.string(from: compareDate)
                    }
                    else
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, HH:mm"
                        dateFormatter.timeZone = NSTimeZone.system
                        result =  dateFormatter.string(from: compareDate)
                    }
                }
            }
        }
        return result
    }
    
}
extension ChatViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
