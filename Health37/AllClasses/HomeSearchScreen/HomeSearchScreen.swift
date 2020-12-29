//
//  HomeSearchScreen.swift
//  Health37
//
//  Created by Ramprasad on 25/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class HomeSearchScreen: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate  {
    
    @IBOutlet var tblSearchData: UITableView!
    @IBOutlet var viewSearchBG: UIView!
    
    @IBOutlet var txtsearchOptions: UITextField!
    @IBOutlet var btnUsers: UIButton!
    @IBOutlet var btnGroups: UIButton!
    @IBOutlet var btnPosts: UIButton!
    @IBOutlet var seprator: UILabel!
    @IBOutlet var viewButtonsBG: UIView!
    
    var  arrAllFriendsInfo = NSMutableArray()
    
    var  dicAllFriendsData = NSDictionary()
    
    var strSearch:String! = ""
    
    var strSelectOption = "Users"
    var boolGetData:Bool!
    var pageCureent:Int!,totalRecord:Int!,totalPage:Int!,NoOFPageRecord:Int!
    var  arrExpendedRow = NSMutableArray()
    var OtherFUserID = ""
    
    var strGroupID = ""
    var strIsMine = ""
    var kStrJoinLeaveKey = "joinGroup"
    
    @IBOutlet var btnSearch: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewSearchBG.layer.cornerRadius = 19.0
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            btnSearch.setTitle("Search".localized, for: .normal)
            btnUsers.setTitle("USERS".localized, for: .normal)
            //  btnGroups.setTitle("GROUPS".localized, for: .normal)
            btnPosts.setTitle("POSTS".localized, for: .normal)
            txtsearchOptions.placeholder = "Search....".localized
            seprator.frame = CGRect.init(x: btnUsers.frame.origin.x, y: seprator.frame.origin.y, width: btnPosts.frame.size.width, height: seprator.frame.size.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
                
        self.navigationItem.title = "Search".localized
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
                self.navigationBarWithBackButton(strTitle: "Search", leftbuttonImageName: "white_back")
            }
        }
        
    }
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldMethod
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        strSearch = textField.text
        if CheckValidationLogin()
        {
            if strSearch != ""
            {
                if appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.methodSearchFriendListApi), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
                }
            }
        }
    }
    
    // MARK:- Check Login Validation................
    func CheckValidationLogin() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtsearchOptions.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            isGo = false
            errorMessage = kEnterSearchTextError.localized
        }
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        return isGo
    }
    
    @IBAction func methodSearch(_ sender: Any)
    {
        self.view.endEditing(true)
        if CheckValidationLogin()
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                seprator.frame = CGRect.init(x: btnUsers.frame.origin.x, y: seprator.frame.origin.y, width: btnPosts.frame.size.width, height: seprator.frame.size.height)
            }
        }
    }
    @IBAction func methodReadMoreDetails(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if arrExpendedRow.contains(sender.tag)
        {
            arrExpendedRow.remove(sender.tag)
        }
        else
        {
            arrExpendedRow.add(sender.tag)
        }
        tblSearchData.reloadData()
        let index = IndexPath.init(row: sender.tag, section: 0)
        self.tblSearchData.scrollToRow(at: index , at: .top, animated: false)
        
    }
    
    @IBAction func methodAllUsersGroupPost(_ sender: UIButton)
    {
        self.arrAllFriendsInfo = NSMutableArray()
        
        if sender.tag == 0
        {
            seprator.frame = CGRect.init(x: btnUsers.frame.origin.x, y: seprator.frame.origin.y, width: btnGroups.frame.size.width, height: seprator.frame.size.height)
            strSelectOption = "Users"
            self.arrAllFriendsInfo = (dicAllFriendsData.object(forKey: "user")as!NSArray).mutableCopy() as! NSMutableArray
            
        }
        else if sender.tag == 1
        {
            seprator.frame = CGRect.init(x: btnGroups.frame.origin.x, y: seprator.frame.origin.y, width: btnGroups.frame.size.width, height: seprator.frame.size.height)
            strSelectOption = "Groups"
            self.arrAllFriendsInfo = (dicAllFriendsData.object(forKey: "group")as!NSArray).mutableCopy() as! NSMutableArray
            
        }
        else if sender.tag == 2
        {
            seprator.frame = CGRect.init(x: btnPosts.frame.origin.x, y: seprator.frame.origin.y, width: btnPosts.frame.size.width, height: seprator.frame.size.height)
            strSelectOption = "Posts"
            self.arrAllFriendsInfo = (dicAllFriendsData.object(forKey: "post")as!NSArray).mutableCopy() as! NSMutableArray
        }
        tblSearchData.reloadData()
    }
    @IBAction func methodJoinLeaveGroups(_ sender: UIButton)
    {
        if sender.isSelected == false
        {
            kStrJoinLeaveKey = "joinGroup"
        }
        else
        {
            kStrJoinLeaveKey = "leaveGroup"
        }
        
        strGroupID = (arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "groupID")
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.JoinLeaveGroupsAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
        }
        
    }
    
    @IBAction func methodGroupDetails(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let OtherU: OtherUserProfileScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            OtherU  = OtherUserProfileScreen(nibName: "OtherUserProfile_Arabic",bundle:nil)
        }
        else
        {
            OtherU  = OtherUserProfileScreen(nibName: "OtherUserProfileScreen",bundle:nil)
        }
        
        OtherU.strFromGroup = "FromGroupScreen"
        OtherU.strIsMine = strIsMine
        OtherU.dicGroupDetails = (self.arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary)
        self.navigationController?.pushViewController(OtherU, animated: true)
    }
    
    @IBAction func methodOtherUserProfile(_ sender: UIButton)
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
        OtherUser.strFromSearchGroup = "FromSearchGroup"
        OtherUser.strOtherFriendID = (self.arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }
    ///SharingSocialPopupShow
    @IBAction func methodSharingonSocialPopup(_ sender: UIButton)
    {
        let strPostID = (arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        
        let strPostImage = (arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_image")
        var strPostContent = (arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_content")
        
        if strPostContent.characters.count > 190
        {
            strPostContent = String(strPostContent.prefix(150))
        }
        
        // text to share
        let shareURL = "\(Base_DOMAIN)post/share-post.php?iPostId="
        let strURL = String.init(format: "%@%@", shareURL,strPostID) + "\n" + strPostContent.decode()
        // print("strURL",strURL)
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
    @IBAction func methodAddFriend(_ sender: UIButton)
    {
        OtherFUserID = (self.arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        if sender.isSelected == false
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodAddFriendApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
            }
            
        }
        else
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodRemoveFriendApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
            }
            
        }
    }
    
    @IBAction func methodLikeUnlikePost(_ sender: UIButton)
    {
        if appDelegate.isInternetAvailable() == false
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            return
        }
        
        let dicLike = NSMutableDictionary.init(dictionary: (arrAllFriendsInfo.object(at: sender.tag) as! NSDictionary))
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
        
        arrAllFriendsInfo.replaceObject(at: sender.tag, with: dicLike)
        let inDexPath = IndexPath.init(row: sender.tag, section: 0)
        let cellLike = tblSearchData.cellForRow(at: inDexPath) as? AllPostTblCell
        
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
        dictUser.setObject("notification", forKey: "v1" as NSCopying)
        self.performSelector(inBackground: #selector(self.LikeUnlikePostAPI), with: dictUser)
        
        // sender.isUserInteractionEnabled = false
        
        //  self.perform(#selector(enableButton(sendder:)), with: sender, afterDelay: 2.0)
        
    }
    ///Method All Comments
    @IBAction func methodAllComments(_ sender: UIButton)
    {
        let Notifi: NotificationAddComment!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Notifi  = NotificationAddComment(nibName: "NotificationAddComment_Arabic",bundle:nil)
        }
        else
        {
            Notifi  = NotificationAddComment(nibName: "NotificationAddComment",bundle:nil)
        }
        
        // let Notifi  = NotificationAddComment(nibName: "NotificationAddComment",bundle:nil)
        let postID = (arrAllFriendsInfo.object(at: sender.tag) as? NSDictionary ?? [:]).valueForNullableKey(key: "post_id")
        Notifi.strPostID = postID
        Notifi.strFromTimeLine = "FromTimeLine"
        self.navigationController?.pushViewController(Notifi, animated: true)
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
                    self.tblSearchData.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if strSelectOption == "Groups"
        {
            return 92
        }
        else if strSelectOption == "Posts"
        {
            if arrAllFriendsInfo.count > 0
            {
                var height: CGFloat = 80.0 + 60.0
                
                let stringImage = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
                let stringDes = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
                
                if stringImage != ""
                {
                    let dicSizes = UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()
                    //
                    if (dicSizes.valueForNullableKey(key: stringImage) != "")
                    {
                        height = height + CGFloat(Float(dicSizes.valueForNullableKey(key: stringImage))!)
                    }
                    else
                    {
                        let imageSize : CGSize = FTImageSize.getImageSize(stringImage)
                        var ratioheight = self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width))
                        if ratioheight > 0
                        {
                            let dicSizes = (UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()).mutableCopy() as! NSMutableDictionary
                            
                            dicSizes.setObject("\(ratioheight)", forKey: stringImage as NSCopying)
                            UserDefaults.standard.set(dicSizes, forKey: "dicSizes")
                            UserDefaults.standard.synchronize()
                        }
                        else
                        {
                            ratioheight = 160
                            self.performSelector(inBackground: #selector(self.getCellHeight(stringImage:)), with: stringImage)
                        }
                        
                        
                        height = height + ratioheight
                        //                            height = height + 160.0
                        //                            self.performSelector(inBackground: #selector(self.getCellHeight(stringImage:)), with: stringImage)
                    }
                }
                if stringDes != ""
                {
                    let decodedString = stringDes.decode() ?? ""
                    let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                    if hh <= 120
                    {
                        height = height + hh
                    }
                    else
                    {
                        height = height + (arrExpendedRow.contains(indexPath.row) ? hh : 120)
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
            return 100
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrAllFriendsInfo.count > 0
        {
            return  self.arrAllFriendsInfo.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if strSelectOption == "Users"
        {
            let identifier : String = "AddFriendsTblCell"
            var cell: AddFriendsTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? AddFriendsTblCell
            if (cell == nil)
            {
                let nib:Array<Any>!
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    nib = Bundle.main.loadNibNamed("AddFriendsTblCell_AR", owner: nil, options: nil)!
                }
                else
                {
                    nib = Bundle.main.loadNibNamed("AddFriendsTblCell", owner: nil, options: nil)! as [Any]
                }
                
                cell = nib[0] as? AddFriendsTblCell
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = UIColor.clear
            }
            cell?.imgFriends.layer.cornerRadius = (cell?.imgFriends.frame.size.width)!/2
            cell?.btnAddFriends.layer.cornerRadius = 15.0
            cell?.imgFriends.layer.masksToBounds = true
            
            cell?.btnAddFriends.tag = indexPath.row
            
            if (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
            {
                cell?.lblFriendsName.text = (self.arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
            }
            else
            {
                let strWorkingPost = (self.arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "super_user_ic_badge.png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attachmentStr = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                myString.append(attachmentStr)
                cell?.lblFriendsName.attributedText = myString
            }
            
            if (self.arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "isFriend") == "0"
            {
                cell?.btnAddFriends.isSelected = false
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    cell?.btnAddFriends.setTitle("الغاء الصداقه", for: .normal)
                }
            }
            else
            {
                cell?.btnAddFriends.isSelected = true
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    cell?.btnAddFriends.setTitle("أضف صديق", for: .selected)
                }
            }
            let userSelfID = UserDefaults.standard.object(forKey: kUserID)!
            let userIDOther = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
            
            if "\(userSelfID)" == "\(userIDOther)"
            {
                cell?.btnAddFriends.isHidden = true
            }
            else
            {
                cell?.btnAddFriends.isHidden = false
            }
            
            cell?.btnAddFriends.addTarget(self, action: #selector(methodAddFriend), for: .touchUpInside)
            let imgUrl = (self.arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image") as? String
            cell?.imgFriends.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
            cell?.imgFriends.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell?.imgFriends.sd_removeActivityIndicator()
            })
            
            cell?.btnFriendProfile.tag = indexPath.row
            cell?.btnFriendProfile.addTarget(self, action: #selector(methodOtherUserProfile), for: .touchUpInside)
            
            return cell!
            
        }
        else if strSelectOption == "Groups"
        {
            let identifier : String = "GroupTblCell"
            var cell: GroupTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? GroupTblCell
            if (cell == nil)
            {
                let nib:Array<Any>!
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    nib = Bundle.main.loadNibNamed("GroupTblCell_AR", owner: nil, options: nil)!
                }
                else
                {
                    nib = Bundle.main.loadNibNamed("GroupTblCell", owner: nil, options: nil)! as [Any]
                }
                
                cell = nib[0] as? GroupTblCell
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = UIColor.clear
            }
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                cell?.lblTitle.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "groupName_ar") as? String
            }
            else
            {
                cell?.lblTitle.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "groupName") as? String
                
            }
            cell?.lblSubtitle.text = "\((arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "groupUserCount"))" + " Members"
            
            if (self.arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "joined") == "approved_member"
            {
                cell?.btnJoin.isSelected = true
            }
            else
            {
                cell?.btnJoin.isSelected = false
            }
            
            cell?.btnJoin.tag = indexPath.row
            cell?.btnJoin.addTarget(self, action: #selector(methodJoinLeaveGroups), for: .touchUpInside)
            let imgUrl = (self.arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "groupImage") as? String
            cell?.imgUsers.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
            cell?.imgUsers.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell?.imgUsers.sd_removeActivityIndicator()
            })
            
            cell?.btnGroupDtls.tag = indexPath.row
            cell?.btnGroupDtls.addTarget(self, action: #selector(methodGroupDetails), for: .touchUpInside)
            return cell!
            
        }
        else
        {
            let identifier: String = "AllPostTblCell"
            var cell: AllPostTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? AllPostTblCell
            if (cell == nil)
            {
                let nib:Array<Any>!
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    nib = Bundle.main.loadNibNamed("AllPostTblCell_AR", owner: nil, options: nil)!
                }
                else
                {
                    nib = Bundle.main.loadNibNamed("AllPostTblCell", owner: nil, options: nil)! as [Any]
                }
                
                cell = nib[0] as? AllPostTblCell
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = UIColor.clear
            }
            // Required float rating view params
            cell?.viewRating.emptyImage = UIImage(named: "greystar.png")
            cell?.viewRating.fullImage = UIImage(named: "starBig.png")
            
            // Optional params
            
            let ratingCount = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "rating")
            
            cell?.viewRating.contentMode = UIViewContentMode.scaleAspectFit
            cell?.viewRating.maxRating = 5
            cell?.viewRating.minRating = Int(ratingCount)!
            cell?.viewRating.editable = false
            //  cell?.viewRating.halfRatings = true
            //  cell?.viewRating.floatRatings = false
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                cell?.viewRating.transform = CGAffineTransform(scaleX: -1, y: 1);
            }
            
            cell?.viewPostBG.layer.cornerRadius = 6.0
            cell?.btnInformation.isHidden = false
            cell?.btnComments.tag = indexPath.row
            cell?.btnComments.addTarget(self, action: #selector(methodAllComments), for: .touchUpInside)
            cell?.btnDelete.tag = indexPath.row
            
            cell?.btnDelete.isHidden = true
            cell?.btnHide.isHidden = true
            //   cell?.btnInformation.addTarget(self, action: #selector(methodUserInformation), for: .touchUpInside)
            
            
            if (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
            {
                cell?.lblNameTimeline.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
            }
            else
            {
                let strWorkingPost = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "super_user_ic_badge.png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attachmentStr = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                myString.append(attachmentStr)
                cell?.lblNameTimeline.attributedText = myString
            }
            
            cell?.lblNameTimeline.sizeToFit()
            
            if (cell?.lblNameTimeline.frame.width)! > 84.1
            {
                cell?.btnInformation.frame = CGRect.init(x: (cell?.lblNameTimeline.frame.origin.x)! + (cell?.lblNameTimeline.frame.size.width)!, y: (cell?.btnInformation.frame.origin.y)!, width: (cell?.btnInformation.frame.size.width)!, height: (cell?.btnInformation.frame.size.height)!)
            }
            
            if (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String != ""
            {
                let imgUrl = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image")
                cell?.imgPost.sd_addActivityIndicator()
                //                    let url = URL.init(string: "\(imgUrl!)")
                //                    cell?.imgPost.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                //                        cell?.imgPost.sd_removeActivityIndicator()
                //                    })
                cell?.imgPost.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                
            }
            if (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar") as! String != ""
            {
                let imgUrlUser = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                cell?.imgTimeline.sd_addActivityIndicator()
                let url1 = URL.init(string: "\(imgUrlUser!)")
                cell?.imgTimeline.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url1) in
                    cell?.imgTimeline.sd_removeActivityIndicator()
                })
            }
            let stringImage = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
            
            
            let stringDes = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
            cell?.btnReadMore.isHidden = true
            
            if stringDes != ""
            {
                let hh = getLabelHeight(text: stringDes, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                
                var frame = (cell?.lblPostDetails.frame)!
                frame.size.height = hh
                if let decodedString : String = stringDes.decode() {
                    cell?.lblPostDetails.text = decodedString
                }
                else
                {
                    cell?.lblPostDetails.text = stringDes
                }
                
                
                if hh > 120.0
                {
                    frame.size.height = arrExpendedRow.contains(indexPath.row) ? hh : 120
                    cell?.btnReadMore.isSelected = arrExpendedRow.contains(indexPath.row)
                    cell?.btnReadMore.isHidden = false
                    var framebtnReadMore = (cell?.btnReadMore.frame)!
                    framebtnReadMore.origin.y = (frame.origin.y + 6) + (frame.size.height - 20)
                    cell?.btnReadMore.frame = framebtnReadMore
                }
                cell?.lblPostDetails.frame = frame
            }
            else
            {
                var framelblPostDetails = (cell?.lblPostDetails.frame)!
                framelblPostDetails.size.height = 0
                cell?.lblPostDetails.frame = framelblPostDetails
            }
            if stringImage != ""
            {
                cell?.imgPost.sd_addActivityIndicator()
                //                let url = URL.init(string: "\(stringImage)")
                //                cell?.imgPost.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                //                    cell?.imgPost.sd_removeActivityIndicator()
                //                })
                
                cell?.imgPost.sd_setImage(with: URL(string: "\(stringImage)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                
                var frameimgPost = (cell?.imgPost.frame)!
                frameimgPost.origin.y = cell!.lblPostDetails.frame.origin.y + cell!.lblPostDetails.frame.size.height + 8
                
                //                    let imageSize : CGSize = FTImageSize.getImageSize(stringImage)
                //                    let ratioheight = (self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width))) > 0 ? self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width)) : 0
                //
                //                    frameimgPost.size.height = ratioheight
                
                let dicSizes = UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()
                
                if (dicSizes.valueForNullableKey(key: stringImage) != "")
                {
                    frameimgPost.size.height = CGFloat(Float(dicSizes.valueForNullableKey(key: stringImage))!)
                }
                else
                {
                    //                        frameimgPost.size.height = 160
                    //                        self.performSelector(inBackground: #selector(self.getCellHeight(stringImage:)), with: stringImage)
                    let imageSize : CGSize = FTImageSize.getImageSize(stringImage)
                    //                        let ratioheight = (self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width))) > 0 ? self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width)) : 0
                    var ratioheight = self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width))
                    if ratioheight > 0
                    {
                        let dicSizes = (UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()).mutableCopy() as! NSMutableDictionary
                        
                        dicSizes.setObject("\(ratioheight)", forKey: stringImage as NSCopying)
                        UserDefaults.standard.set(dicSizes, forKey: "dicSizes")
                        UserDefaults.standard.synchronize()
                    }
                    else
                    {
                        ratioheight = 160
                        self.performSelector(inBackground: #selector(self.getCellHeight(stringImage:)), with: stringImage)
                    }
                    
                    frameimgPost.size.height = ratioheight
                    
                }
                cell?.imgPost.frame = frameimgPost
                //
                //                if (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String != ""
                //                {
                //                    cell?.lblPostDetails.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as? String
                //                    //  cell?.lblPostDetails.text = lblDescription.text
                //                }
                
                ////Date Format
                let formateSearch = DateFormatter()
                formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if  formateSearch.date(from: ((arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count")as? String)!) != nil
                {
                    let  strBookingDate = formateSearch.date(from: ((arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count")as? String)!)
                    
                    cell?.lblTimeAgo.text = formateSearch.string(from: strBookingDate!)
                }
                else
                {
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        cell?.lblTimeAgo.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count_ar")as? String//formateSearch.string(from: strBookingDate!)
                    }
                    else
                    {
                        cell?.lblTimeAgo.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count")as? String//formateSearch.string(from: strBookingDate!)
                    }
                }
            }
            cell?.btnUserProfile.tag = indexPath.row
            cell?.btnUserProfile.addTarget(self, action: #selector(methodOtherUserProfile), for: .touchUpInside)
            cell?.btnSharing.tag = indexPath.row
            
            cell?.btnSharing.addTarget(self, action: #selector(methodSharingonSocialPopup), for: .touchUpInside)
            
            cell?.btnReadMore.addTarget(self, action: #selector(methodReadMoreDetails), for: .touchUpInside)
            cell?.btnReadMore.tag = indexPath.row
            
            cell?.lblLikeCount.text = (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "likes") as? String
            
            if  (arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_like") as! String  == "1"
            {
                cell?.btnLike.isSelected = true
            }
            else
            {
                cell?.btnLike.isSelected = false
            }
            
            cell?.btnLike.tag = indexPath.row
            cell?.btnLike.addTarget(self, action: #selector(methodLikeUnlikePost), for: .touchUpInside)
            
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if strSelectOption == "Posts"
        {
            let ProductD: ProductDetailsScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                ProductD  = ProductDetailsScreen(nibName: "ProductDetails_Arabic",bundle:nil)
            }
            else
            {
                ProductD  = ProductDetailsScreen(nibName: "ProductDetailsScreen",bundle:nil)
            }
            
            ProductD.dicAllPosts = arrAllFriendsInfo.object(at: indexPath.row) as! NSDictionary
            self.navigationController?.pushViewController(ProductD, animated: true)
        }
    }
    
    // MARK:- updateProfile API Integration.................
    func SearchAllUserParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if strSearch != ""
        {
            dictUser.setObject(strSearch, forKey: kKeyWord as NSCopying)
        }
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
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
    
    @objc func methodSearchFriendListApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodSearchAllUsers, Details: self.SearchAllUserParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        
                        self.arrAllFriendsInfo = NSMutableArray()
                        self.dicAllFriendsData = responseData?.object(forKey: kData) as! NSDictionary
                        self.viewButtonsBG.isHidden = false
                        
                        if   self.strSelectOption == "Users"
                        {
                            self.arrAllFriendsInfo = (self.dicAllFriendsData.object(forKey: "user")as!NSArray).mutableCopy() as! NSMutableArray
                        }
                        else if   self.strSelectOption == "Groups"
                        {
                            self.arrAllFriendsInfo = (self.dicAllFriendsData.object(forKey: "group")as!NSArray).mutableCopy() as! NSMutableArray
                        }
                        else if   self.strSelectOption == "Posts"
                        {
                            self.arrAllFriendsInfo = (self.dicAllFriendsData.object(forKey: "post")as!NSArray).mutableCopy() as! NSMutableArray
                        }
                        
                        self.tblSearchData.reloadData()
                    }
                    else
                    {
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
        }
    }
    
    // MARK:- updateProfile API Integration.................
    func GetFriendsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        dictUser.setObject(OtherFUserID, forKey: kFriendID as NSCopying)
        
        return dictUser
    }
    @objc func methodAddFriendApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAddFriend, Details: self.GetFriendsParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                        
                        self.showActivity(text: "")
                        self.pageCureent = 1
                        self.performSelector(inBackground: #selector(self.methodSearchFriendListApi), with: nil)
                        //    self.tblAddFriendsList.reloadData()
                        
                    }
                    else
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
        }
    }
    // MARK:- updateProfile API Integration.................
    func RemoveFriendsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        dictUser.setObject(OtherFUserID, forKey: kFriendID as NSCopying)
        
        return dictUser
    }
    @objc func methodRemoveFriendApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodRemoveFriend, Details: self.RemoveFriendsParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                        
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.methodSearchFriendListApi), with: nil)
                        
                    }
                    else
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
        }
    }
    
    // MARK:- JoinGroups API Integration.................
    func JoinLeaveGroupParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject("\(strGroupID)", forKey: "group_id" as NSCopying)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: kDefaultLanguage as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: kDefaultLanguage as NSCopying)
        }
        
        return dictUser
    }
    
    @objc func JoinLeaveGroupsAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kStrJoinLeaveKey, Details: self.JoinLeaveGroupParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.methodSearchFriendListApi), with: nil)
                    }
                    else
                    {
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
        }
    }
    
    // MARK:- LikeUnlike API Integration.................
    
    @objc func LikeUnlikePostAPI(dicLike : NSMutableDictionary)
    {
        let tagRow = dicLike.valueForNullableKey(key: "tag")
        dicLike.removeObject(forKey: "tag")
        getallApiResultwithGetMethod(strMethodname: kMethodLikeUnlike, Details: dicLike) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("tagRow",tagRow)
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
    
    
}
