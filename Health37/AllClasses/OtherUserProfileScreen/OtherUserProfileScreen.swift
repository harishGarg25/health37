//
//  OtherUserProfileScreen.swift
//  Health37
//
//  Created by Ramprasad on 08/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class OtherUserProfileScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet var imgLogoHeader: UIImageView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewSocialPopup: UIView!
    @IBOutlet var viewReportPostPopup: UIView!
    @IBOutlet var lblSureReportMsg: UILabel!
    @IBOutlet var btnCancelReportPost: UIButton!
    @IBOutlet var btnOkReportPost: UIButton!
    @IBOutlet var tblUserProfile: UITableView!
    
    var pageCureent:Int!,totalRecord:Int!,totalPage:Int!,NoOFPageRecord:Int!
    var boolGetData:Bool!
    var refreshControl = UIRefreshControl()
    var strGroupID = ""
    var  arrAllPosts = NSMutableArray()
    var  arrProfileData = NSMutableArray()
    var strOtherFriendID = ""
    var strPostID = ""
    var strActionSet = ""
    var strStatusFuF = ""
    var strFromGroup = ""
    var dicGroupDetails = NSDictionary()
    var kStrJoinLeaveKey = ""
    var  arrAllGroups = NSMutableArray()
    var strIsMine = ""
    var strFromOtherPro = ""
    var strFromSearchGroup = ""
    var  arrExpendedRow = NSMutableArray()
    var strPostImage = ""
    var strPostContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  print("strOtherFriendID",strOtherFriendID)
        DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.pageCureent = 1
                    if self.strFromGroup != "FromGroupScreen"
                    {
                        self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
                        self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
                    }
                    else
                    {
                        self.strOtherFriendID = self.dicGroupDetails.valueForNullableKey(key: "groupID")
                        self.performSelector(inBackground: #selector(self.OtherUserAllPostAPI), with: nil)
                    }
                }
                else
                {
                    self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
                }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeUnlike), name: NSNotification.Name(rawValue: "updateLikeUnlike"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileData), name: NSNotification.Name(rawValue: "updateFollowerCount"), object: nil)
        
        refreshControl.addTarget(self, action: #selector(PullRefresh), for:UIControlEvents.valueChanged)
        self.refreshControl.isHidden = true
        tblUserProfile.addSubview(refreshControl)
        
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            btnOkReportPost.setTitle("OK".localized, for: .normal)
            btnCancelReportPost.setTitle("CANCEL".localized, for: .normal)
            lblSureReportMsg.text = "Are you sure you want to report this post?".localized
        }
    }
    
    //PoolRefresh
    @objc func PullRefresh()
    {
        self.pageCureent = 1
        self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
        refreshControl.isHidden = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        })
    }
    
    @objc func updateLikeUnlike()
    {
        if appDelegate.isInternetAvailable() == true
        {
            if self.strFromGroup != "FromGroupScreen"
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
            }
            else
            {
                self.strOtherFriendID = self.dicGroupDetails.valueForNullableKey(key: "groupID")
                self.performSelector(inBackground: #selector(self.OtherUserAllPostAPI), with: nil)
            }
            
        }
        else
        {
            self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
        }
        
    }
    
    @objc func updateProfileData()
    {
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                if strFromGroup == "FromGroupScreen"
                {
                    imgLogoHeader.isHidden = false
                    
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else if strFromSearchGroup == "FromSearchGroup"
                {
                    imgLogoHeader.isHidden = true
                    
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else
                {
                    imgLogoHeader.isHidden = true
                    
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                }
            }
            else
            {
                if strFromGroup == "FromGroupScreen" || strFromSearchGroup == "FromSearchGroup"
                {
                    imgLogoHeader.isHidden = false
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                }
                else
                {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                    
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                }
            }
        }
        else
        {
            imgLogoHeader.isHidden = true
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    imgLogoHeader.isHidden = false
                    
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
            }
            else
            {
                if strFromGroup == "FromGroupScreen"
                {
                    imgLogoHeader.isHidden = false
                }
                else
                {
                    imgLogoHeader.isHidden = true
                }
                
                if strFromGroup == "fromFriendList"
                {
                    self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "white_back")
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
        }
        
        self.navigationItem.titleView = viewHeader
        
    }
    @objc func BackTo(_ sender : UIButton)
    {
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
    
    ///TableView Scrolling method
    func methodTableIndexReload()
    {
        let indexitem = NSIndexPath.init(item: 0, section: 0)
        self.tblUserProfile.scrollToRow(at: indexitem as IndexPath, at: UITableViewScrollPosition.top, animated: false)
    }
    
    // MARK: - UIBUttonsMethod
    @IBAction func MethodViewExit(_ sender: Any)
    {
        self.viewSocialPopup.removeFromSuperview()
    }
    
    @IBAction func methodShareTimeLineSocial(_ sender: UIButton)
    {
        self.viewSocialPopup.removeFromSuperview()
        
        if sender.tag == 0
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.ShareTimelineAPI), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
            }
        }
        else
        {
            if strPostContent.characters.count > 190
            {
                strPostContent = String(strPostContent.prefix(150))
            }
            
            // print("strPostID",strPostID)
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
                    print("urlData not nil")
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
    }
    @IBAction func methodOkCancelPopup(_ sender: UIButton)
    {
        self.viewReportPostPopup.removeFromSuperview()
        if sender.tag == 1
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.AddReportAPI), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
            }
        }
        
    }
    @IBAction func methodUserInformation(_ sender: UIButton)
    {
        strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        strOtherFriendID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        print("strPostID",strPostID)
        print("sender",sender.tag)
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.viewReportPostPopup)
        self.viewReportPostPopup.frame = window.frame
    }
    
    @IBAction func methodBookAppointment(_ sender: UIButton)
    {
        
        if let catID : String = (arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "cat_parent_id") as? String,catID == "4"
        {
            let controller = DoctorListTableViewController.instantiate(fromAppStoryboard: .Appointment)
            controller.hospitalID = (arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
            controller.appointmentDetail = ["doctor_name":(arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "user_name"),"doctor_id":(arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)]
            self.navigationController?.pushViewController(controller, animated:true)
        }else
        {
            let controller = NewApptTableViewController.instantiate(fromAppStoryboard: .Appointment)
            controller.doctorID = (arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
            controller.appointmentDetail = ["doctor_name":(arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "user_name"),"doctor_id":(arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)]
            self.navigationController?.pushViewController(controller, animated:true)
        }
    }
    
    @IBAction func methodSeeLocation(_ sender: UIButton)
    {
        let latString = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_lat") as? String ?? ""
        let longString = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "user_lon") as? String ?? ""
        redirectToGoogleMap(coordinates: "\(latString),\(longString)")
    }
    
    @IBAction func methodCall(_ sender: UIButton)
    {
        let phoneNumber = (arrProfileData.object(at: 0) as! NSDictionary).object(forKey: "phone_number") as? String ?? ""
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                         application.openURL(phoneCallURL as URL)
                    }
                }
            }
    }
    
    @IBAction func methodFollowerFollowings(_ sender: UIButton)
    {
        let Follow: FollowerFollowingScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Follow  = FollowerFollowingScreen(nibName: "FollowerFollowing_Arabic",bundle:nil)
        }
        else
        {
            Follow  = FollowerFollowingScreen(nibName: "FollowerFollowingScreen",bundle:nil)
        }
        
        Follow.strOtherUserID = (arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        if sender.tag != 0
        {
            Follow.strFromFollowing = "FromFollowing"
        }
        self.navigationController?.pushViewController(Follow, animated: true)
        
    }
    @IBAction func methodFollowUnfollowUser(_ sender: UIButton)
    {
        if sender.isSelected == false
        {
            strStatusFuF = "1"
        }
        else
        {
            strStatusFuF = "0"
        }
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.FollowUnfollowAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
        }
    }
    @IBAction func methodLikeUnlikePost(_ sender: UIButton)
    {
        if appDelegate.isInternetAvailable() == false
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            return
        }
        
        let dicLike = NSMutableDictionary.init(dictionary: (arrAllPosts.object(at: sender.tag) as! NSDictionary))
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
        
        arrAllPosts.replaceObject(at: sender.tag, with: dicLike)
        let inDexPath = IndexPath.init(row: sender.tag, section: 1)
        let cellLike = tblUserProfile.cellForRow(at: inDexPath) as? AllPostTblCell
        
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
    }
    
    @IBAction func methodAddUserPost(_ sender: UIButton)
    {
        let Post: PostVC!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            Post  = PostVC(nibName: "PostVC_Arabic",bundle:nil)
        }
        else
        {
            Post  = PostVC(nibName: "PostVC",bundle:nil)
        }
        Post.strFromGroups = "FromGroupDtls"
        Post.strGroupID = self.dicGroupDetails.valueForNullableKey(key: "groupID")
        self.navigationController?.pushViewController(Post, animated: true)
    }
    @IBAction func methodJoinLeaveGroups(_ sender: UIButton)
    {
        if dicGroupDetails.object(forKey: "joined") as? String == "approved_member"
        {
            kStrJoinLeaveKey = "leaveGroup"
        }
        else
        {
            kStrJoinLeaveKey = "joinGroup"
        }
        strGroupID = dicGroupDetails.valueForNullableKey(key: "groupID")
        
        print("G_ID",strGroupID)
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
        tblUserProfile.reloadData()
        let index = IndexPath.init(row: sender.tag, section: 1)
        self.tblUserProfile.scrollToRow(at: index , at: .top, animated: false)
        
    }
    @IBAction func methodAskMeFriends(_ sender: UIButton)
    {
        if self.arrProfileData.count > 0
        {
            let ChatV: ChatViewController!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                ChatV  = ChatViewController(nibName: "ChatView_Arabic",bundle:nil)
            }
            else
            {
                ChatV  = ChatViewController(nibName: "ChatViewController",bundle:nil)
            }
            
            ChatV.strSltChatType = "AddFriend"
            ChatV.strFriendID = (arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
            ChatV.strFriendName = (arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "user_name")
            self.navigationController?.pushViewController(ChatV, animated: true)
        }
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
        
        let postID = (arrAllPosts.object(at: sender.tag) as? NSDictionary ?? [:]).valueForNullableKey(key: "post_id")
        Notifi.strPostID = postID
        Notifi.strFromTimeLine = "FromTimeLine"
        self.navigationController?.pushViewController(Notifi, animated: true)
    }
    
    ///SharingSocialPopupShow
    @IBAction func methodSharingonSocialPopup(_ sender: UIButton)
    {
        strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        
        strPostImage = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_image")
        //        strPostContent = "\n Description:- " + (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_content")
        let stringDesProfile = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_content")
        if let decodedString : String = stringDesProfile.decode() {
            strPostContent = decodedString
        }
        else
        {
            strPostContent = stringDesProfile
        }
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.viewSocialPopup)
        self.viewSocialPopup.frame = window.frame
        
    }
    
    @IBAction func methodOtherUserProfile(_ sender: UIButton)
    {
        if self.strFromGroup == "FromGroupScreen"
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
            OtherUser.strOtherFriendID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
            
            OtherUser.strFromOtherPro = "FromOtherUserPro"
            self.navigationController?.pushViewController(OtherUser, animated: true)
        }
    }
    @IBAction func methodRateReviewUsers(_ sender: UIButton)
    {
        if self.arrProfileData.count > 0
        {
            let RateA: RateAndReviewScreen!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                RateA  = RateAndReviewScreen(nibName: "RateAndReview_Arabic",bundle:nil)
            }
            else
            {
                RateA  = RateAndReviewScreen(nibName: "RateAndReviewScreen",bundle:nil)
            }
            
            RateA.strOtherFriendID = (self.arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
            RateA.strIsRated = (self.arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "is_rated")
            
            RateA.strFromRating = "FromTimeLine"
            self.navigationController?.pushViewController(RateA, animated: true)
        }
    }
    
    // MARK: - UITableViewMethods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 && indexPath.section == 0
        {
            if strFromGroup == "FromGroupScreen"
            {
                //                if dicGroupDetails.object(forKey: "joined") as? String == "approved_member"
                //                {
                return UITableViewAutomaticDimension
                //                }
                //                else
                //                {
                //                    return 305
                //                }
            }
            else
            {
                if arrProfileData.count > 0
                {
                    let strUserBrief = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "user_brief")
                    
                    if strUserBrief != ""
                    {
                        var height: CGFloat =  380.0
                        let decodedString = strUserBrief.decode() ?? ""
                        let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 8, font: UIFont.init(name: "Lato-Regular", size: 15)!)
                        if hh <= 150
                        {
                            height = height + hh
                        }
                        else
                        {
                            height = height +  170
                        }
                        
                        return height
                    }
                    else
                    {
                        return 385
                    }
                }
                else
                {
                    return 385
                }
            }
        }
        else
        {
            if (indexPath.row == arrAllPosts.count) && (arrAllPosts.count > 0)
            {
                return 40
            }
            else
            {
                
                if arrAllPosts.count > 0
                {
                    var height: CGFloat = 80.0 + 60.0
                    
                    let stringImage = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
                    let stringDes = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
                    
                    if stringImage != ""
                    {
                        //                        let ratioheight = self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width))
                        //                        let ratioheight = (self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width))) > 0 ? self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(imageSize.height)/CGFloat(imageSize.width)) : 0
                        //
                        //                        height = height + ratioheight
                        
                        let dicSizes = UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()
                        //
                        if (dicSizes.valueForNullableKey(key: stringImage) != "")
                        {
                            height = height + CGFloat(Float(dicSizes.valueForNullableKey(key: stringImage))!)
                        }
                        else
                        {
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
        }
    }
    @objc func getCellHeight(stringImage: String)
    {
        
        if let imageSource = CGImageSourceCreateWithURL(URL(string: stringImage) as! CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
                DispatchQueue.main.async {
                    let ratioheight = self.appDelegate.window!.frame.size.width * CGFloat(CGFloat(pixelHeight)/CGFloat(pixelWidth))
                    print("the image ratioheight is:\(pixelWidth)  \(pixelHeight)  \(ratioheight)")
                    print("the image stringImage is: \(stringImage)")
                    
                    let dicSizes = (UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()).mutableCopy() as! NSMutableDictionary
                    
                    dicSizes.setObject("\(ratioheight)", forKey: stringImage as NSCopying)
                    UserDefaults.standard.set(dicSizes, forKey: "dicSizes")
                    UserDefaults.standard.synchronize()
                    self.tblUserProfile.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else
        {
            if arrAllPosts.count > 0
            {
                if pageCureent < totalPage
                {
                    if  self.boolGetData == false
                    {
                        return arrAllPosts.count + 1
                    }
                    else
                    {
                        return arrAllPosts.count
                    }
                }
                else
                {
                    return arrAllPosts.count
                }
            }
            else
            {
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath.row == arrAllPosts.count) && (arrAllPosts.count > 0)
        {
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            spinner.frame = CGRect(x: (UIScreen .main.bounds.size.width - 20)/2, y: 12, width: 20, height: 20)
            cell.addSubview(spinner)
            spinner.startAnimating()
            return cell
        }
        else
        {
            
            if indexPath.section == 0
            {
                if strFromGroup == "FromGroupScreen"
                {
                    let identifier: String = "GroupOuserProTblCell"
                    var cell: GroupOuserProTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? GroupOuserProTblCell
                    if (cell == nil)
                    {
                        
                        let nib:Array<Any>!
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            nib = Bundle.main.loadNibNamed("GroupOuserProTblCell_AR", owner: nil, options: nil)!
                        }
                        else
                        {
                            nib = Bundle.main.loadNibNamed("GroupOuserProTblCell", owner: nil, options: nil)! as [Any]
                        }
                        
                        cell = nib[0] as? GroupOuserProTblCell
                        cell?.selectionStyle = UITableViewCellSelectionStyle.none
                        cell?.backgroundColor = UIColor.clear
                    }
                    cell?.btnLeaveJoin.isHidden = false
                    if dicGroupDetails.count > 0
                    {
                        
                        cell?.lblUserName.text = dicGroupDetails.object(forKey: "groupName") as? String
                        cell?.lblGroupCount.text = dicGroupDetails.object(forKey: "groupUserCount") as? String
                        cell?.lblDesignation.text = dicGroupDetails.object(forKey: "groupDesciption") as? String
                        
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            cell?.lblUserName.text = dicGroupDetails.object(forKey: "groupNameArabic") as? String
                            cell?.lblDesignation.text = dicGroupDetails.object(forKey: "description_ar") as? String
                        }
                        
                        let imgUrl = dicGroupDetails.object(forKey: "groupImage")
                        cell?.imgUserProfile.sd_addActivityIndicator()
                        let url = URL.init(string: "\(imgUrl!)")
                        cell?.imgUserProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                            cell?.imgUserProfile.sd_removeActivityIndicator()
                        })
                        
                        let imgUrlCover = dicGroupDetails.object(forKey: "group_banner")
                        cell?.imgCover.sd_addActivityIndicator()
                        let urlCover = URL.init(string: "\(imgUrlCover!)")
                        cell?.imgCover.sd_setImage(with: urlCover, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, urlCover) in
                            cell?.imgCover.sd_removeActivityIndicator()
                        })
                        if dicGroupDetails.object(forKey: "joined") as? String == "approved_member"
                        {
                            cell?.btnLeaveJoin.isSelected = true
                            
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.btnLeaveJoin.setTitle("غادر", for: .selected)
                                cell?.btnAddPost.setTitle("أضف منشورا", for: .normal)
                            }
                        }
                        else
                        {
                            cell?.btnLeaveJoin.isSelected = false
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.btnLeaveJoin.setTitle("انضم", for: .normal)
                            }
                            
                        }
                        
                        cell?.btnAddPost.addTarget(self, action: #selector(methodAddUserPost), for: .touchUpInside)
                        
                        cell?.btnLeaveJoin.tag = indexPath.row
                        cell?.btnLeaveJoin.addTarget(self, action: #selector(methodJoinLeaveGroups), for: .touchUpInside)
                        
                    }
                    
                    return cell!
                }
                else
                {
                    let identifier: String = "UsersInfoTblCell"
                    var cell: UsersInfoTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? UsersInfoTblCell
                    if (cell == nil)
                    {
                        let nib:Array<Any>!
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            nib = Bundle.main.loadNibNamed("UsersInfoTblCell_Arabic", owner: nil, options: nil)!
                        }
                        else
                        {
                            nib = Bundle.main.loadNibNamed("UsersInfoTblCell", owner: nil, options: nil)! as [Any]
                        }
                        
                        cell = nib[0] as? UsersInfoTblCell
                        cell?.selectionStyle = UITableViewCellSelectionStyle.none
                        cell?.backgroundColor = UIColor.clear
                    }
                    
                    cell?.btnFollowers.tag = 0
                    cell?.btnFollowing.tag = 1
                    cell?.btnLocation.isHidden = false
                    cell?.btnFollowers.addTarget(self, action: #selector(methodFollowerFollowings), for: .touchUpInside)
                    cell?.btnFollowing.addTarget(self, action: #selector(methodFollowerFollowings), for: .touchUpInside)
                    cell?.btnFollowUnfollow.tag = indexPath.row
                    cell?.btnFollowUnfollow.addTarget(self, action: #selector(methodFollowUnfollowUser), for: .touchUpInside)
                    cell?.btnBookAppointMent.addTarget(self, action: #selector(methodBookAppointment), for: .touchUpInside)
                    cell?.btnLocation.addTarget(self, action: #selector(methodSeeLocation), for: .touchUpInside)
                    cell?.btnCall.addTarget(self, action: #selector(methodCall), for: .touchUpInside)
                    if arrProfileData.count > 0
                    {
                        if let doctorID = (arrProfileData.object(at: 0) as? NSDictionary)?.valueForNullableKey(key: kUserID)
                        {
                            if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
                            {
                                cell?.appointmentView.isHidden = doctorID == userid ? true : false
                                cell?.discountView.isHidden = doctorID == userid ? true : false
                                if let discount_amount = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "discount_amount") as? String
                                {
                                    cell?.discountLabel.text = "\(discount_amount)%"
                                }else
                                {
                                    cell?.discountView.isHidden = true
                                }
                            }
                        }
                        
                        if (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
                        {
                            cell?.lblName.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: kFullName) as? String
                        }
                        else
                        {
                            let strWorkingPost = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: kFullName) as? String
                            let attachment = NSTextAttachment()
                            attachment.image = UIImage(named: "super_user_ic_badge.png")
                            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                            let attachmentStr = NSAttributedString(attachment: attachment)
                            let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                            myString.append(attachmentStr)
                            cell?.lblName.attributedText = myString
                        }
                        
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            if (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_cat_name") as? String != ""
                            {
                                cell?.lblWorkingPost.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_cat_name_ar") as? String
                            }
                            else
                            {
                                cell?.lblWorkingPost.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "parent_cat_name_ar") as? String
                            }
                            cell?.btnFollowers.setTitle("متابعون", for: .normal)
                            cell?.btnFollowing.setTitle("اتابع", for: .normal)
                            cell?.btnAskMe.setTitle("اسألني", for: .normal)
                        }
                        else
                        {
                            if (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_cat_name") as? String != ""
                            {
                                cell?.lblWorkingPost.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_cat_name") as? String
                            }
                            else
                            {
                                cell?.lblWorkingPost.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "parent_cat_name") as? String
                            }
                        }
                        
                        cell?.lblDiscriptions.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "user_brief")
                        cell?.lblDiscriptions.layer.masksToBounds = true
                        
                        cell?.lblTotalFollowers.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "followers")
                        
                        cell?.lblTotalFollowing.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "follow")
                        
                        let ratingCount = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "rating")
                        
                        if (arrProfileData.object(at:indexPath.row) as! NSDictionary).valueForNullableKey(key: "is_following") == "1"
                        {
                            cell?.btnFollowUnfollow.isSelected = true
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.btnFollowUnfollow.setTitle("الغاء المتابعة", for: .selected)
                            }
                        }
                        else
                        {
                            cell?.btnFollowUnfollow.isSelected = false
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.btnFollowUnfollow.setTitle("إتبع", for: .normal)
                            }
                            
                        }
                        
                        cell?.lblRatingCounting.text = NSString.init(format: "(%@)", (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "count_rating")) as String
                        
                        // Required float rating view params
                        cell?.viewRating.emptyImage = UIImage(named: "greystar.png")
                        cell?.viewRating.fullImage = UIImage(named: "starBig.png")
                        // Optional params
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
                        
                        let imgUrl = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                        cell?.imgProfile.sd_addActivityIndicator()
                        let url = URL.init(string: "\(imgUrl!)")
                        cell?.imgProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                            cell?.imgProfile.sd_removeActivityIndicator()
                        })
                        
                        let imgUrlCover = (arrProfileData.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_cover")
                        cell?.imgCoverPhoto.sd_addActivityIndicator()
                        let urlCover = URL.init(string: "\(imgUrlCover!)")
                        cell?.imgCoverPhoto.sd_setImage(with: urlCover, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, urlCover) in
                            cell?.imgCoverPhoto.sd_removeActivityIndicator()
                        })
                        
                        cell?.btnAskMe.tag = indexPath.row
                        cell?.btnAskMe.addTarget(self, action: #selector(methodAskMeFriends), for: .touchUpInside)
                        
                        if strFromOtherPro == "FromOtherUser"
                        {
                            cell?.btnAskMe.isHidden = true
                            cell?.imgAsk.isHidden = true
                            
                            cell?.btnFollowUnfollow.isHidden = true
                        }
                        else
                        {
                            cell?.btnAskMe.isHidden = false
                            cell?.imgAsk.isHidden = false
                            
                            cell?.btnFollowUnfollow.isHidden = false
                        }
                        
                        let userSelfID = UserDefaults.standard.object(forKey: kUserID)!
                        let userIDFollow = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
                        if "\(userSelfID)" == "\(userIDFollow)"
                        {
                            cell?.btnFollowUnfollow.isHidden = true
                        }
                        else
                        {
                            cell?.btnFollowUnfollow.isHidden = false
                        }
                        
                    }
                    cell?.btnRateAndReview.tag = indexPath.row
                    cell?.btnRateAndReview.addTarget(self, action: #selector(methodRateReviewUsers), for: .touchUpInside)
                    
                    return cell!
                }
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
                        if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                        {
                            nib = Bundle.main.loadNibNamed("AllPostTblCell_AREng", owner: nil, options: nil)!
                        }
                        else
                        {
                            nib = Bundle.main.loadNibNamed("AllPostTblCell", owner: nil, options: nil)! as [Any]
                        }
                    }
                    
                    cell = nib[0] as? AllPostTblCell
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = UIColor.clear
                }
                // Required float rating view params
                cell?.viewRating.emptyImage = UIImage(named: "greystar.png")
                cell?.viewRating.fullImage = UIImage(named: "starBig.png")
                // Optional params
                if arrAllPosts.count > 0
                {
                    let ratingCount = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "rating")
                    
                    cell?.viewRating.contentMode = UIViewContentMode.scaleAspectFit
                    cell?.viewRating.maxRating = 5
                    cell?.viewRating.minRating = Int(ratingCount)!
                    cell?.viewRating.editable = false
                    
                }
                
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    cell?.viewRating.transform = CGAffineTransform(scaleX: -1, y: 1);
                }
                // cell?.viewRating.halfRatings = true
                // cell?.viewRating.floatRatings = false
                
                cell?.viewPostBG.layer.cornerRadius = 6.0
                cell?.btnInformation.isHidden = false
                cell?.btnDelete.tag = indexPath.row
                
                cell?.btnDelete.isHidden = true
                
                cell?.btnHide.tag = indexPath.row
                cell?.btnHide.isHidden = true
                
                cell?.btnInformation.addTarget(self, action: #selector(methodUserInformation), for: .touchUpInside)
                
                let userSelfID = UserDefaults.standard.object(forKey: kUserID)!
                let userIDFollow = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
                if "\(userSelfID)" == "\(userIDFollow)"
                {
                    cell?.btnInformation.isHidden = true
                }
                else
                {
                    cell?.btnInformation.isHidden = false
                }
                
                
                if (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
                {
                    cell?.lblNameTimeline.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                }
                else
                {
                    let strWorkingPost = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "super_user_ic_badge.png")
                    attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                    let attachmentStr = NSAttributedString(attachment: attachment)
                    let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                    myString.append(attachmentStr)
                    cell?.lblNameTimeline.attributedText = myString
                }
                
                // cell?.lblNameTimeline.sizeToFit()
                
                if (cell?.lblNameTimeline.frame.width)! > 84.1
                {
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                    }
                    else
                    {
                        cell?.btnInformation.frame = CGRect.init(x: (cell?.lblNameTimeline.frame.origin.x)! + (cell?.lblNameTimeline.frame.size.width)!, y: (cell?.btnInformation.frame.origin.y)!, width: (cell?.btnInformation.frame.size.width)!, height: (cell?.btnInformation.frame.size.height)!)
                    }
                }
                let stringImage = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
                let stringDes = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
                cell?.btnReadMore.isHidden = true
                
                if stringDes != ""
                {
                    let decodedString = stringDes.decode() ?? ""
                    //                let stringAscii = decodedString.replacingOccurrences(of: "240\\", with: "")
                    let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                    
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
                        framebtnReadMore.origin.y = (frame.origin.y + 10) + (frame.size.height - 20)
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
                    frameimgPost.origin.y = cell!.lblPostDetails.frame.origin.y + (cell!.lblPostDetails.frame.size.height + 12)
                    
                    let dicSizes = UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()
                    
                    if (dicSizes.valueForNullableKey(key: stringImage) != "")
                    {
                        frameimgPost.size.height = CGFloat(Float(dicSizes.valueForNullableKey(key: stringImage))!)
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
                        
                        frameimgPost.size.height = ratioheight
                        
                    }
                    cell?.imgPost.frame = frameimgPost
                    
                }
                
                let imgUrlUser = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                cell?.imgTimeline.sd_addActivityIndicator()
                let url1 = URL.init(string: "\(imgUrlUser!)")
                cell?.imgTimeline.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url1) in
                    cell?.imgTimeline.sd_removeActivityIndicator()
                })
                
                ////Date Format
                let formateSearch = DateFormatter()
                formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                if  formateSearch.date(from: ((arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time")as? String)!) != nil
                {
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        
                        cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count_ar")as? String
                    }
                    else
                    {
                        cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "month_time")as? String
                        
                        //                  let strBookingDate = formateSearch.date(from: ((arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time")as? String)!)
                        //                    let str = formateSearch.string(from: strBookingDate!)
                        //                    let datebooking = formateSearch.date(from: str)
                        //
                        //                    formateSearch.dateFormat = "hh:mm"
                        //              formateSearch.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                        //
                        //                    let timesPost = formateSearch.string(from: datebooking!)
                        //                    let    strSendtime = timeAgo(strBookingDate!)
                        //
                        //                    cell?.lblTimeAgo.text = getCreatePostTime(strdate: (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "time"))//strSendtime//UTCToLocal(date: timesPost)
                        
                    }
                    
                }
                else
                {
                }
                
                cell?.btnSharing.tag = indexPath.row
                
                cell?.btnSharing.addTarget(self, action: #selector(methodSharingonSocialPopup), for: .touchUpInside)
                
                cell?.btnReadMore.addTarget(self, action: #selector(methodReadMoreDetails), for: .touchUpInside)
                cell?.btnReadMore.tag = indexPath.row
                
                cell?.btnComments.tag = indexPath.row
                cell?.btnComments.addTarget(self, action: #selector(methodAllComments), for: .touchUpInside)
                
                cell?.lblComment.text = String.init(format: "(%@)", (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "comments") as! CVarArg)
                
                cell?.lblLikeCount.text =  String.init(format: "(%@)", (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "likes") as! CVarArg)
                
                
                //            if strFromGroup != "FromGroupScreen"
                //            {
                if  (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_like") as! String  == "1"
                {
                    cell?.btnLike.isSelected = true
                }
                else
                {
                    cell?.btnLike.isSelected = false
                }
                //  }
                
                cell?.btnLike.tag = indexPath.row
                cell?.btnLike.addTarget(self, action: #selector(methodLikeUnlikePost), for: .touchUpInside)
                
                cell?.btnUserProfile.tag = indexPath.row
                cell?.btnUserProfile.addTarget(self, action: #selector(methodOtherUserProfile), for: .touchUpInside)
                
                return cell!
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        //        if strSearchingOff == "SearchingOFF"
        //        {
        //            return
        //        }
        if(indexPath.item == arrAllPosts.count - 1)
        {
            print (boolGetData)
            if (!boolGetData)
            {
                if(pageCureent != totalPage )
                {
                    boolGetData = true
                    if arrAllPosts.count < totalRecord
                    {
                        pageCureent = pageCureent + 1
                        if strFromGroup == "FromGroupScreen"
                        {
                            self.performSelector(inBackground: #selector(self.OtherUserAllPostAPI), with: nil)
                        }
                        else
                        {
                            self.performSelector(inBackground: #selector(updateAllPostListAPI), with: nil)
                        }
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section != 0
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
            
            print("arrAllPosts",arrAllPosts)
            ProductD.dicAllPosts = arrAllPosts.object(at: indexPath.row) as! NSDictionary
            self.navigationController?.pushViewController(ProductD, animated: true)
        }
    }
    
    
    // MARK:- updateProfile API Integration.................
    func updateProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        let userID = UserDefaults.standard.object(forKey: kUserID)
        dictUser.setObject(userID!, forKey: "other_id" as NSCopying)
        dictUser.setObject(strOtherFriendID, forKey: kUserID as NSCopying)
        
        return dictUser
    }
    
    func redirectToGoogleMap(coordinates : String) {
        
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(coordinates)&directionsmode=driving"),
            UIApplication.shared.canOpenURL(url) {
            print("comgoogle maps worked")
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else{
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(coordinates)&directionsmode=driving"),
                UIApplication.shared.canOpenURL(url) {
                print("google com maps worked")
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }else{
            }
        }
    }
    
    @objc func updateGetProfileAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetProfile, Details: self.updateProfileParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        self.arrProfileData = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                        self.lblUserName.text = (self.arrProfileData.object(at: 0) as! NSDictionary).valueForNullableKey(key: "full_name")
                        
                        self.tblUserProfile.reloadData()
                    }
                    else
                    {
                        print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }        }
    }
    // MARK:- updateAll Post API Integration.................
    func updateAllPostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        //  dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "other_id" as NSCopying)
        dictUser.setObject(strOtherFriendID, forKey: kUserID as NSCopying)
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "other_id" as NSCopying)
        
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        dictUser.setObject("\(strIsMine)", forKey: "is_mine" as NSCopying)
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
    
    @objc func updateAllPostListAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAllPost, Details: self.updateAllPostParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        
                        if self.pageCureent == 1
                        {
                            self.arrAllPosts = NSMutableArray()
                        }
                        if responseData?.object(forKey: kPostData) != nil && (responseData?.object(forKey: kPostData) as! NSArray).count > 0
                        {
                            self.totalPage = (responseData?.object(forKey: "total_page")! as AnyObject).integerValue
                            self.totalRecord = (responseData?.object(forKey: "total_records")! as AnyObject).integerValue
                            
                            if responseData?.object(forKey: kPostData) != nil && (responseData?.object(forKey: kPostData) as! NSArray).count > 0
                            {
                                self.arrAllPosts.addObjects(from: (responseData?.object(forKey: kPostData) as? [AnyObject])!)
                                self.boolGetData = false
                            }
                        }
                        else
                        {
                        }
                        self.tblUserProfile.reloadData()
                    }
                    else
                    {
                        print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }        }
    }
    
    
    @objc func LikeUnlikePostAPI(dicLike : NSMutableDictionary)//LikeUnlikePostAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodLikeUnlike, Details: dicLike) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                        
                        //                    self.showActivity(text: "")
                        //                    self.pageCureent = 1
                        //                    if self.strFromGroup == "FromGroupScreen"
                        //                    {
                        //                        self.performSelector(inBackground: #selector(self.OtherUserAllPostAPI), with: nil)
                        //                    }
                        //                    else
                        //                    {
                        //                        self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
                        //                    }
                    }
                    else
                    {
                        print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }        }
    }
    
    // MARK:- FollowUnfollow API Integration.................
    func FollowUnfollowParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strOtherFriendID, forKey: "other_id" as NSCopying)
        dictUser.setObject("\(strStatusFuF)", forKey: "status" as NSCopying)
        dictUser.setObject("notification", forKey: "v1" as NSCopying)
        return dictUser
    }
    
    @objc func FollowUnfollowAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodFollowUnfollow, Details: self.FollowUnfollowParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFollowerCount"), object: nil)
                        
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
    
    //    // MARK:- FollowUnfollow API Integration.................
    func OtherUserProParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strOtherFriendID, forKey: "group_id" as NSCopying)
        //  dictUser.setObject("en", forKey: "language" as NSCopying)
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        dictUser.setObject("\(strIsMine)", forKey: "is_mine" as NSCopying)
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
    
    @objc func OtherUserAllPostAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGroupOtherProfile, Details: self.OtherUserProParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        if self.pageCureent == 1
                        {
                            self.arrAllPosts = NSMutableArray()
                        }
                        if responseData?.object(forKey: kPostData) != nil && (responseData?.object(forKey: kPostData) as! NSArray).count > 0
                        {
                            self.totalPage = (responseData?.object(forKey: "total_page")! as AnyObject).integerValue
                            self.totalRecord = (responseData?.object(forKey: "total_records")! as AnyObject).integerValue
                            
                            if responseData?.object(forKey: kPostData) != nil && (responseData?.object(forKey: kPostData) as! NSArray).count > 0
                            {
                                self.arrAllPosts.addObjects(from: (responseData?.object(forKey: kPostData) as? [AnyObject])!)
                                self.boolGetData = false
                                
                            }
                            self.tblUserProfile.reloadData()
                        }
                        else
                        {
                        }
                        
                        print("OtherUserPro",responseData!)
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
    
    // MARK:- JoinGroups API Integration.................
    func JoinLeaveGroupParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject("\(strGroupID)", forKey: "group_id" as NSCopying)
        dictUser.setObject("\(strIsMine)", forKey: "is_mine" as NSCopying)
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
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            if self.kStrJoinLeaveKey == "joinGroup"
                            {
                                self.onShowAlertController(title: "" , message: " انضميت الى المجموعة ")
                            }
                            else
                            {
                                self.onShowAlertController(title: "" , message: "لقد غادرت المجموعة بنجاح ")
                            }
                        }
                        else
                        {
                            self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                        }
                        
                        print("LeaveJoin",responseData!)
                        self.showActivity(text: "")
                        self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
                    }
                    else
                    {
                        print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    print("dicGroupDetails_API",self.dicGroupDetails)
                }
            }
        }
    }
    
    // MARK:- AllGroups API Integration.................
    func AllGroupsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        dictUser.setObject("\(strIsMine)", forKey: "is_mine" as NSCopying)
        dictUser.setObject("\(strIsMine)", forKey: "is_mine" as NSCopying)
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
    
    @objc func AllGroupsListAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAllGroups, Details: self.AllGroupsParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.arrAllGroups = (responseData?.object(forKey: "groups_data")as!NSArray).mutableCopy() as! NSMutableArray
                        
                        print("self.arrAllGroups",self.arrAllGroups)
                        
                        self.matchGroupID()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGroupUsers"), object: nil)
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
    
    // MARK:- Delete API Integration.................
    func AddReportParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "reported_to" as NSCopying)
        dictUser.setObject(strOtherFriendID, forKey: "reported_from" as NSCopying)
        
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        
        return dictUser
    }
    
    @objc func AddReportAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAddReport, Details: self.AddReportParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    else
                    {
                        print("responseData",responseData!)
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
            
        }
    }
    
    // MARK:- ShareTimeline Integration.................
    func ShareTimelineParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        
        return dictUser
    }
    
    @objc func ShareTimelineAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodShareTimeL, Details: self.ShareTimelineParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    else
                    {
                        print("responseData",responseData!)
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
        }
    }
    func matchGroupID()
    {
        for i in 0..<self.arrAllGroups.count
        {
            let userGroupID = (self.arrAllGroups.object(at: i) as! NSDictionary).object(forKey: "groupID")
            
            if "\(strGroupID)" == "\(userGroupID!)"
            {
                dicGroupDetails = self.arrAllGroups.object(at: i) as! NSDictionary
                print("dicGroupDetails",dicGroupDetails)
            }
        }
        
        self.tblUserProfile.reloadData()
    }
    
    func getCreatePostTime(strdate:String) -> String
    {
        let datesendFormate = DateFormatter()
        datesendFormate.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        datesendFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datesendFormate.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        let datesend = datesendFormate.date(from: strdate)
        datesendFormate.timeZone = NSTimeZone.system
        //datesendFormate.dateFormat = "MM/dd/yyyy"
        var strSendtime = datesendFormate.string(from: datesend!)
        let datetime = datesendFormate.date(from: strSendtime)
        if datetime != nil
        {
            strSendtime = timeAgo(datetime!)
        }
        return strSendtime
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
                        //  dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        // dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                        //                        dateFormatter.timeZone = TimeZone(identifier: "UTC")
                        //
                        //                        let str = dateFormatter.string(from: compareDate)
                        //                        dateFormatter.timeZone = TimeZone.current
                        //                        dateFormatter.dateFormat = "EEEE, HH:mm"
                        //                        let newdatebooking = dateFormatter.date(from: str)
                        //
                        //                        result = "\(dateFormatter.string(from: newdatebooking!))" //7 days ago
                        dateFormatter.timeZone = NSTimeZone.system
                        result =  dateFormatter.string(from: compareDate)
                    }
                    else
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, HH:mm"
                        // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        // dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                        //                        dateFormatter.timeZone = TimeZone(identifier: "UTC")
                        //                        let str = dateFormatter.string(from: compareDate)
                        //                        dateFormatter.timeZone = TimeZone.current
                        //                        dateFormatter.dateFormat = "MMMM, dd, HH:mm"
                        //                        let newdatebooking = dateFormatter.date(from: str)
                        //
                        //                        result = "\(dateFormatter.string(from: newdatebooking!))" //7 days ago
                        dateFormatter.timeZone = NSTimeZone.system
                        result =  dateFormatter.string(from: compareDate)
                    }
                }
            }
        }
        return result
    }
    
}
