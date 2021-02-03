//
//  TimelineScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class TimelineScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Iboutlets
    @IBOutlet var viewRating: FloatRatingView!
    @IBOutlet var tblTimeline: UITableView!
    var pageCureent:Int!,totalRecord:Int!,totalPage:Int!,NoOFPageRecord:Int!
    var boolGetData:Bool!
    
    var selectIndex: Int = 0
    //String
    var strFromHome = ""
    var strTabbarClick = ""
    
    var strNotifcationUPTO = ""
    
    var selecteOptions : Int = 1
    @IBOutlet var viewHeader: UIView!
    var lblDescription = UILabel()
    @IBOutlet var viewReportPostPopup: UIView!
    
    @IBOutlet var viewDeletePostPopup: UIView!
    
    //Seprator Iboutlets
    @IBOutlet var sepratorTimeLine: UILabel!
    @IBOutlet var sepratorNotification: UILabel!
    @IBOutlet var sepratorInbox: UILabel!
    
    var  arrProfileData = NSMutableArray()
    var  arrAllPosts = NSMutableArray()
    
    var  arrConverations = NSMutableArray()
    var  arrAllAddFriends = NSMutableArray()
    
    var  arrAllNotifications = NSMutableArray()
    
    var strPostID = ""
    var strOtherFriendID = ""
    
    var strActionSet = ""
    
    var refreshControl = UIRefreshControl()
    
    var  arrExpendedRow = NSMutableArray()
    
    
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    @IBOutlet var lblTitleReportPost: UILabel!
    @IBOutlet var btnCancelReportP: UIButton!
    @IBOutlet var btnOkReportP: UIButton!
    @IBOutlet var lblTitleDelete: UILabel!
    @IBOutlet var btnCancelDelete: UIButton!
    @IBOutlet var btnOkDelete: UIButton!
    
    
    @IBOutlet var viewHeaderConveration: UIView!
    @IBOutlet var viewHeaderAllFri: UIView!
    @IBOutlet var btnConveration: UIButton!
    @IBOutlet var btnAllFriends: UIButton!
    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!
    var dicInboxData = NSDictionary()
    
    var strDeleteHideAPI = ""
    var sltdIndexPath : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotifications), name: NSNotification.Name(rawValue: "updateNoficationCounts"), object: nil)
        
        print("First", strTabbarClick)
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true
        
        btnAllFriends.layer.cornerRadius = 18.0
        btnConveration.layer.cornerRadius = 18.0
        btnAllFriends.layer.borderWidth = 1.0
        btnConveration.layer.borderWidth = 1.0
        btnConveration.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        btnAllFriends.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            
            btnConveration.setTitle("Conversation".localized, for: .normal)
            btnAllFriends.setTitle("All Friends".localized, for: .normal)
            
            btnOkDelete.setTitle("OK".localized, for: .normal)
            btnOkReportP.setTitle("OK".localized, for: .normal)
            
            btnCancelReportP.setTitle("CANCEL".localized, for: .normal)
            btnCancelDelete.setTitle("CANCEL".localized, for: .normal)
            
            //  lblTitleDelete.text = "Are you sure, you want to delete this post?".localized
            lblTitleReportPost.text = "Are you sure you want to report this post?".localized
            
        }
        
        DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.pageCureent = 1
                    
                    self.performSelector(inBackground: #selector(self.updateGetProfileAPI), with: nil)
                    self.showActivity(text: "")
                    
                    self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
                    // self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.FriendsListAPICall), with: nil)
                    
                    // self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.NotificationsListAPICall), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateAllPostData), name: NSNotification.Name(rawValue: "updateAllPostList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeUnlike), name: NSNotification.Name(rawValue: "updateLikeUnlike"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileData), name: NSNotification.Name(rawValue: "updateFollowerCount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInboxDetails), name: NSNotification.Name(rawValue: "updateChatInboxDetails"), object: nil)
        
        
        refreshControl.addTarget(self, action: #selector(PullRefresh), for:UIControlEvents.valueChanged)
        self.refreshControl.isHidden = true
        tblTimeline.addSubview(refreshControl)
        
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
        //        self.strNotifcationUPTO = "\(appDelegate.strNotificationUPTo)"
    }
    
    //PoolRefresh
    @objc func PullRefresh()
    {
        
        if selecteOptions == 0
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.HomeAllPostAPI), with: nil)
        }
        else if selecteOptions == 1
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
        }
        else if selecteOptions == 2
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.MyLikePostAPI), with: nil)
        }
        
        if  strTabbarClick == "FromNotification"
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.NotificationsListAPICall), with: nil)
        }
        
        refreshControl.isHidden = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        })
    }
    
    @objc func updateInboxDetails()
    {
        self.pageCureent = 1
        
        self.performSelector(inBackground: #selector(self.FriendsListAPICall), with: nil)
    }
    @objc func updateLikeUnlike()
    {
        // let index = IndexPath.init(row: selectIndex, section: 0)
        // self.tblTimeline.scrollToRow(at: index , at: .top, animated: false)
        
        if selecteOptions == 0
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.HomeAllPostAPI), with: nil)
        }
        else if selecteOptions == 1
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
        }
        else if selecteOptions == 2
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.MyLikePostAPI), with: nil)
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
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
    }
    @objc func updateAllPostData()
    {
        tblTimeline.reloadData()
        if appDelegate.isInternetAvailable() == true
        {
            selecteOptions = 1
            self.pageCureent = 1
            
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)
        
        self.navigationItem.titleView = viewHeader
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
            }
            else
            {
                //  UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "menu")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
            }
        }
    }
    ///sideMenu
    @objc override func methodSideMenu(_ sender : UIButton)
    {
        self.view.endEditing(true)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if strFromHome != "FromSideMenu"
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.menuContainerViewController.toggleRightSideMenuCompletion
                    { () -> Void in
                }
            }
        }
        else
        {
            self.menuContainerViewController.toggleLeftSideMenuCompletion
                { () -> Void in
            }
        }
    }
    ///SettingsScreenOpen
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
    
    
    
    
    // MARK: - UIButtonsMethod
    ///SettingsScreenOpen
    @IBAction func methodOkCancelAddReportPopup(_ sender: UIButton)
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
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
    }
    @IBAction func methodSetting(_ sender: Any)
    {
        self.menuContainerViewController.toggleRightSideMenuCompletion
            { () -> Void in
        }
    }
    ///SharingSocialPopupShow
    
    func share(shareText:String?,shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }
    
    
    @IBAction func methodSharingonSocialPopup(_ sender: UIButton)
    {
        
        strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        
        let strPostImage = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_image")
        var strPostContent = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_content")
        
        if strPostContent.characters.count > 152
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
    ///TimeLines
    @IBAction func methodTimeline(_ sender: UIButton)
    {
        strTabbarClick = "FromTimeLine"
        self.pageCureent = 1
        self.showActivity(text: "")
        
        self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)
        
        // methodTableIndexReload()
        
    }
    
    ///TableView Scrolling method
    func methodTableIndexReload()
    {
        let indexitem = NSIndexPath.init(item: 0, section: 0)
        self.tblTimeline.scrollToRow(at: indexitem as IndexPath, at: UITableViewScrollPosition.top, animated: false)
    }
    
    ///AllNotifications
    @IBAction func methodNotification(_ sender: UIButton)
    {
        strTabbarClick = "FromNotification"
        self.viewNotificationCount.isHidden = true
        DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    print("upTo",self.appDelegate.strNotificationUPTo)
                    if self.appDelegate.strNotificationUPTo != ""
                    {
                        self.strNotifcationUPTO = "\(self.appDelegate.strNotificationUPTo)"
                    }
                    
                    let dicDetails = NSMutableDictionary()
                    dicDetails.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                    dicDetails.setObject(self.strNotifcationUPTO, forKey: "upto" as NSCopying)
                    
                    
                    self.showActivity(text: "")
                    self.pageCureent = 1
                    self.performSelector(inBackground: #selector(self.NotificationsListAPICall), with: nil)
                    
                    self.performSelector(inBackground: #selector(self.methodAddNotificationCount), with: dicDetails)
                    
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
        }
        
    }
    
    ///AllInboxMessages
    @IBAction func methodInbox(_ sender: UIButton)
    {
        strTabbarClick = "FromInbox"
        
        DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.FriendsListAPICall), with: nil)
                    self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)
                    
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
        }
    }
    
    ///Method Add Post
    @IBAction func methodAddPost(_ sender: UIButton)
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
        
        self.navigationController?.pushViewController(Post, animated: true)
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
        
        let postID = (arrAllPosts.object(at: sender.tag) as? NSDictionary ?? [:]).valueForNullableKey(key: "post_id")
        Notifi.strPostID = postID
        Notifi.strFromTimeLine = "FromTimeLine"
        self.navigationController?.pushViewController(Notifi, animated: true)
    }
    @IBAction func methodHomeLikeOthers(_ sender: UIButton)
    {
        
        if sender.tag == 0
        {
            if arrAllPosts.count > 0
            {
                strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
            }
            DispatchQueue.main.async
                {
                    
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.pageCureent = 1
                        self.performSelector(inBackground: #selector(self.HomeAllPostAPI), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
            }
        }
        else if sender.tag == 1
        {
            DispatchQueue.main.async
                {
                    
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.pageCureent = 1
                        self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
            }
        }
        else if sender.tag == 2
        {
            DispatchQueue.main.async
                {
                    
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.showActivity(text: "")
                        self.pageCureent = 1
                        self.performSelector(inBackground: #selector(self.MyLikePostAPI), with: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                    }
            }
        }
        
        methodTableIndexReload()
        selecteOptions = sender.tag
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
        
        if sender.tag == 0
        {
            self.navigationController?.pushViewController(Follow, animated: true)
        }
        else
        {
            //            let Follow  = FollowerFollowingScreen(nibName: "FollowerFollowingScreen",bundle:nil)
            Follow.strFromFollowing = "FromFollowing"
            self.navigationController?.pushViewController(Follow, animated: true)
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
        tblTimeline.reloadData()
        let index = IndexPath.init(row: sender.tag, section: 1)
        self.tblTimeline.scrollToRow(at: index , at: .top, animated: false)
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
        let cellLike = tblTimeline.cellForRow(at: inDexPath) as? AllPostTblCell
        
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
    
    @objc func enableButton(sendder : UIButton)
    {
        sendder.isUserInteractionEnabled = true
    }
    
    @IBAction func methodDeletePost(_ sender: UIButton)
    {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.viewDeletePostPopup)
        self.viewDeletePostPopup.frame = window.frame
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            lblTitleDelete.text = "هل أنت متأكد أنك تريد حذف هذه المشاركة؟"
        }
        else
        {
            lblTitleDelete.text = "Are you sure, you want to delete this post?"
        }
        
        strDeleteHideAPI = "removePost"
        strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
    }
    
    @IBAction func methodPostHide(_ sender: UIButton)
    {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.viewDeletePostPopup)
        self.viewDeletePostPopup.frame = window.frame
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            lblTitleDelete.text = "هل أنت متأكد من أنك تريد إخفاء هذه المشاركة؟"
        }
        else
        {
            lblTitleDelete.text = "Are you sure, you want to hide this post?"
        }
        strDeleteHideAPI = "hidePost"
        strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        
        
    }
    
    @IBAction func methodOkCancelDeletePost(_ sender: UIButton)
    {
        viewDeletePostPopup.removeFromSuperview()
        if sender.tag != 0
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.DeleteSelectedPostAPI), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
        
    }
    
    @IBAction func methodUserInformation(_ sender: UIButton)
    {
        strPostID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "post_id")
        strOtherFriendID = (arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        //        print("strPostID",strPostID)
        //        print("sender",sender.tag)
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self.viewReportPostPopup)
        self.viewReportPostPopup.frame = window.frame
    }
    
    @IBAction func methodOtherUserProfile(_ sender: UIButton)
    {
        if selecteOptions == 0 || selecteOptions == 2
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
            
            OtherUser.strOtherFriendID = (self.arrAllPosts.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
            OtherUser.strFromOtherPro = "FromOtherUserPro"
            
            self.navigationController?.pushViewController(OtherUser, animated: true)
        }
        else
        {
            strTabbarClick = "FromTimeLine"
            
            tblTimeline.reloadData()
            methodTableIndexReload()
        }
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
        
        OtherUser.strOtherFriendID = (self.arrAllNotifications.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }
    @IBAction func methodRateReviewUsers(_ sender: UIButton)
    {
        let RateAndR: RateAndReviewScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            RateAndR  = RateAndReviewScreen(nibName: "RateAndReview_Arabic",bundle:nil)
            
        }
        else
        {
            RateAndR  = RateAndReviewScreen(nibName: "RateAndReviewScreen",bundle:nil)
        }
        RateAndR.strOtherFriendID = (self.arrProfileData.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        RateAndR.strFromRating = "FromTimeLine"
        self.navigationController?.pushViewController(RateAndR, animated: true)
    }
    
    
    // MARK: - UITableViewMethods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if strTabbarClick == "FromTimeLine" || strTabbarClick == "FromInbox"
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if  (indexPath.row == arrAllPosts.count) && indexPath.section == 1
        {
            if  (strTabbarClick != "FromNotification") &&  (strTabbarClick != "FromInbox")
            {
                return 40
            }
            return 0
        }
        else
        {
            if strTabbarClick == "FromTimeLine"
            {
                if indexPath.section == 0
                {
                    if indexPath.row == 0
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
                    else
                    {
                        return 96
                    }
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
            else if strTabbarClick == "FromNotification"
            {
                if indexPath.row == arrAllNotifications.count
                {
                    return 0
                }
                return 104
            }
            else
            {
                return 96
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if strTabbarClick == "FromTimeLine" //|| strTabbarClick != "FromInbox"
        {
            if section == 0
            {
                return 2
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
        else if strTabbarClick == "FromNotification"
        {
            if self.arrAllNotifications.count > 0
            {
                if pageCureent < totalPage
                {
                    if  self.boolGetData == false
                    {
                        return arrAllNotifications.count
                        
                    }
                    else
                    {
                        return arrAllNotifications.count + 1
                    }
                }
                else
                {
                    return arrAllNotifications.count
                }
            }
            return 0
        }
        else
        {
            if section == 0
            {
                if self.arrConverations.count > 0
                {
                    return self.arrConverations.count
                }
                return 0
            }
            else
            {
                if self.arrAllAddFriends.count > 0
                {
                    return self.arrAllAddFriends.count
                }
                return 0
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
                    
                    let dicSizes = (UserDefaults.standard.object(forKey: "dicSizes") as? NSDictionary ?? NSDictionary()).mutableCopy() as! NSMutableDictionary
                    
                    dicSizes.setObject("\(ratioheight)", forKey: stringImage as NSCopying)
                    UserDefaults.standard.set(dicSizes, forKey: "dicSizes")
                    UserDefaults.standard.synchronize()
                    self.tblTimeline.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if  (indexPath.row == arrAllPosts.count) && indexPath.section == 1
        {
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            spinner.frame = CGRect(x: (UIScreen .main.bounds.size.width - 20)/2, y: 12, width: 20, height: 20)
            if  (strTabbarClick != "FromNotification")
            {
                cell.addSubview(spinner)
                spinner.startAnimating()
            }
            if (strTabbarClick == "FromInbox")
            {
                spinner.stopAnimating()
            }
            return cell
        }
        else
        {
            if strTabbarClick == "FromTimeLine"
            {
                if indexPath.section == 0
                {
                    if indexPath.row == 0
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
                        
                        cell?.btnFollowers.addTarget(self, action: #selector(methodFollowerFollowings), for: .touchUpInside)
                        cell?.btnFollowing.addTarget(self, action: #selector(methodFollowerFollowings), for: .touchUpInside)
                        
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
                                        cell?.discountLabel.text = discount_amount
                                    }
                                }
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
                                cell?.btnFollowers.setTitle("متابعون".localized, for: .normal)
                                cell?.btnFollowing.setTitle("اتابع".localized, for: .normal)
                                cell?.btnAskMe.setTitle("اسألني".localized, for: .normal)
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
                            
                            cell?.lblTotalFollowers.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "followers")
                            
                            cell?.lblDiscriptions.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "user_brief")
                            cell?.lblDiscriptions.layer.masksToBounds = true
                            
                            cell?.lblTotalFollowing.text = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "follow")
                            
                            let ratingCount = (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "rating")
                            
                            cell?.lblRatingCounting.text =  NSString.init(format: "(%@)", (arrProfileData.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "count_rating")) as String
                            
                            // Required float rating view params
                            cell?.viewRating.emptyImage = UIImage(named: "greystar.png")
                            cell?.viewRating.fullImage = UIImage(named: "starBig.png")
                            // Optional params
                            cell?.viewRating.contentMode = UIViewContentMode.left
                            cell?.viewRating.maxRating = 5
                            cell?.viewRating.minRating = Int(ratingCount) ?? 0
                            cell?.viewRating.editable = false
                            
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
                            cell?.imgCoverPhoto.sd_setImage(with: urlCover, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options:.refreshCached, completed: { (img, error, cacheType, urlCover) in
                                cell?.imgCoverPhoto.sd_removeActivityIndicator()
                            })
                            
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
                            
                            cell?.btnRateAndReview.tag = indexPath.row
                            cell?.btnRateAndReview.addTarget(self, action: #selector(methodRateReviewUsers), for: .touchUpInside)
                            
                            
                        }
                        return cell!
                    }
                    else //if indexPath.row == 1
                    {
                        let identifier: String = "TimelineButtonTblCell"
                        var cell: TimelineButtonTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? TimelineButtonTblCell
                        if (cell == nil)
                        {
                            let nib:Array<Any>!
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                nib = Bundle.main.loadNibNamed("TimelineButtonTblCell_AR", owner: nil, options: nil)!
                            }
                            else
                            {
                                nib = Bundle.main.loadNibNamed("TimelineButtonTblCell", owner: nil, options: nil)! as [Any]
                            }
                            
                            cell = nib[0] as? TimelineButtonTblCell
                            cell?.selectionStyle = UITableViewCellSelectionStyle.none
                            cell?.backgroundColor = UIColor.clear
                        }
                        cell?.btnHome.tag = 0
                        cell?.btnAllPost.tag = 1
                        cell?.btnHeart.tag = 2
                        
                        cell?.btnHome.addTarget(self, action: #selector(methodHomeLikeOthers), for: .touchUpInside)
                        cell?.btnAllPost.addTarget(self, action: #selector(methodHomeLikeOthers), for: .touchUpInside)
                        cell?.btnHeart.addTarget(self, action: #selector(methodHomeLikeOthers), for: .touchUpInside)
                        
                        cell?.btnHome.isSelected = false
                        cell?.btnAllPost.isSelected = false
                        cell?.btnHeart.isSelected = false
                        if selecteOptions == 0
                        {
                            cell?.btnHome.isSelected = true
                        }
                        else if selecteOptions == 1
                        {
                            cell?.btnAllPost.isSelected = true
                        }
                        else if selecteOptions == 2
                        {
                            cell?.btnHeart.isSelected = true
                        }
                        
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            cell?.btnAddPost.setTitle("أضف منشورا", for: .normal)
                        }
                        
                        cell?.btnAddPost.addTarget(self, action: #selector(methodAddPost), for: .touchUpInside)
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
                    
                    let ratingCount = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "rating")
                    
                    cell?.viewRating.contentMode = UIViewContentMode.scaleAspectFit
                    cell?.viewRating.maxRating = 5
                    cell?.viewRating.minRating = Int(ratingCount) ?? 0
                    cell?.viewRating.editable = false
                    // cell?.viewRating.halfRatings = true
                    //  cell?.viewRating.floatRatings = false
                    
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        cell?.viewRating.transform = CGAffineTransform(scaleX: -1, y: 1);
                    }
                    
                    cell?.viewPostBG.layer.cornerRadius = 6.0
                                        
                    cell?.btnComments.tag = indexPath.row
                    cell?.btnComments.addTarget(self, action: #selector(methodAllComments), for: .touchUpInside)
                    
                    cell?.btnDelete.tag = indexPath.row
                    cell?.btnDelete.isHidden = true
                    cell?.btnInformation.isHidden = true
                    cell?.btnInformation.tag = indexPath.row
                    cell?.btnHide.isHidden = true
                    if selecteOptions == 0
                    {
                        cell?.btnInformation.isHidden = false
                    }
                    if selecteOptions == 1
                    {
                        cell?.btnDelete.isHidden = false
                        cell?.btnDelete.addTarget(self, action: #selector(methodDeletePost), for: .touchUpInside)
                        
                        cell?.btnHide.tag = indexPath.row
                        cell?.btnHide.isHidden = false
                        cell?.btnHide.addTarget(self, action: #selector(methodPostHide), for: .touchUpInside)
                        
                    }
                    if selecteOptions == 2
                    {
                        let strPostUserID = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
                        
                        if "\(strPostUserID)" != "\(UserDefaults.standard.object(forKey: kUserID)!)"
                        {
                            cell?.btnInformation.isHidden = false
                        }
                    }
                    
                    cell?.btnInformation.addTarget(self, action: #selector(methodUserInformation), for: .touchUpInside)
                    
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
                    
                    if (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String != ""
                    {
                        let imgUrl = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image")
                        cell?.imgPost.sd_addActivityIndicator()
                        //                    let url = URL.init(string: "\(imgUrl!)")
                        //                    cell?.imgPost.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        //                        cell?.imgPost.sd_removeActivityIndicator()
                        //                    })
                        
                        cell?.imgPost.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                        
                    }
                    
                    let stringImage = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String
                    
                    
                    let stringDescription = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_content") as! String
                    let decodedString = stringDescription.decode() ?? ""
                    
                    cell?.btnReadMore.isHidden = true
                    
                    if decodedString != ""
                    {
                        let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                        
                        var frame = (cell?.lblPostDetails.frame)!
                        frame.size.height = hh
                        cell?.lblPostDetails.text = decodedString
                        
                        if hh > 120.0
                        {
                            frame.size.height = arrExpendedRow.contains(indexPath.row) ? hh : 120
                            cell?.btnReadMore.isSelected = arrExpendedRow.contains(indexPath.row)
                            cell?.btnReadMore.isHidden = false
                            var framebtnReadMore = (cell?.btnReadMore.frame)!
                            framebtnReadMore.origin.y = (frame.origin.y + 8) + (frame.size.height - 20)
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
                        if selecteOptions == 2
                        {
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count_ar")as? String
                            }
                            else
                            {
                                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                                {
                                    cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "month_time")as? String
                                }
                                else
                                {
                                    let  strBookingDate = formateSearch.date(from: ((arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time")as? String)!)
                                    let   strSendtime = (timeAgo(strBookingDate!))
                                    
                                    cell?.lblTimeAgo.text = getCreatePostTime(strdate: (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "time"))
                                    
                                }
                            }
                        }
                        else if selecteOptions == 1
                        {
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count_ar")as? String
                            }
                            else
                            {
                                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                                {
                                    cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "month_time")as? String
                                    
                                }
                                else
                                {
                                    let  strBookingDate = formateSearch.date(from: ((arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time")as? String)!)
                                    
                                    let   strSendtime = (timeAgo(strBookingDate!))
                                    
                                    cell?.lblTimeAgo.text = getCreatePostTime(strdate: (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "time"))
                                    
                                }
                            }
                        }
                        else
                        {
                            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                            {
                                cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time_count_ar")as? String
                            }
                            else
                            {
                                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                                {
                                    cell?.lblTimeAgo.text = (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "month_time")as? String
                                }
                                else
                                {
                                    let  strBookingDate = formateSearch.date(from: ((arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "time")as? String)!)
                                    
                                    let   strSendtime = (timeAgo(strBookingDate!))
                                    
                                    cell?.lblTimeAgo.text = getCreatePostTime(strdate: (arrAllPosts.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "time"))
                                    
                                }
                            }
                        }
                    }
                    else
                    {
                    }
                    cell?.btnSharing.tag = indexPath.row
                    cell?.btnSharing.addTarget(self, action: #selector(methodSharingonSocialPopup), for: .touchUpInside)
                    
                    cell?.btnReadMore.addTarget(self, action: #selector(methodReadMoreDetails), for: .touchUpInside)
                    cell?.btnReadMore.tag = indexPath.row
                    
                    if  (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "is_like") as! String  == "1"
                    {
                        //  strActionSet = "1"
                        cell?.btnLike.isSelected = true
                    }
                    else
                    {
                        // strActionSet = "0"
                        
                        cell?.btnLike.isSelected = false
                    }
                    
                    cell?.lblLikeCount.text = String.init(format: "(%@)", (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "likes") as! CVarArg)
                    
                    cell?.lblComment.text = String.init(format: "(%@)", (arrAllPosts.object(at: indexPath.row) as! NSDictionary).object(forKey: "comments") as! CVarArg)
                    
                    cell?.btnLike.tag = indexPath.row
                    cell?.btnLike.addTarget(self, action: #selector(methodLikeUnlikePost), for: .touchUpInside)
                    
                    
                    cell?.btnUserProfile.tag = indexPath.row
                    cell?.btnUserProfile.addTarget(self, action: #selector(methodOtherUserProfile), for: .touchUpInside)
                    
                    return cell!
                }
            }
            else if strTabbarClick == "FromNotification"
            {
                if  (indexPath.row == arrAllNotifications.count)
                {
                    let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                    
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                    spinner.frame = CGRect(x: (UIScreen .main.bounds.size.width - 20)/2, y: 12, width: 20, height: 20)
                    cell.addSubview(spinner)
                    spinner.startAnimating()
                    spinner.isHidden = true
                    return cell
                }
                let cellIdentifire : String = "NotificationsCell"
                
                var cell : NotificationsCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifire) as? NotificationsCell
                
                if cell == nil {
                    
                    let nib:Array<Any>!
                    
                    //1 Arabic, 2 English
                    let languageType =  (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "lang") as? String
                    if languageType == "1"
                    {
                        nib = Bundle.main.loadNibNamed("NotificationsCell_AR", owner: nil, options: nil)!
                    }else if languageType == "2"
                    {
                        nib = Bundle.main.loadNibNamed("NotificationsCell", owner: nil, options: nil)!
                    }
                    else
                    {
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            nib = Bundle.main.loadNibNamed("NotificationsCell_AR", owner: nil, options: nil)!
                        }
                        else
                        {
                            nib = Bundle.main.loadNibNamed("NotificationsCell", owner: nil, options: nil)! as [Any]
                        }
                    }
                    
                    cell = nib[0] as? NotificationsCell
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = UIColor.clear
                }
                
                // cell?.userImageView.image = UIImage(named:self.notificationArray[indexPath.row] as! String)
                if arrAllNotifications.count > 0
                {
                    cell?.nameLabel.text = ((arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String)?.capitalized
                    
                    let comments =  (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "notification") as? String
                    //let word = comments?.components(separatedBy: " ").first
                    //let  strNotification = comments?.replacingOccurrences(of: word!, with: "")
                    cell?.commentLabel.text = comments//strNotification?.trimmingCharacters(in: .whitespaces).capitalized
                    
                    ////Date Format
                    let formateSearch = DateFormatter()
                    formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ssa "
                    let inputDateAsString = (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "timeCountMain") as? String ?? ""
                    let languageType =  (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "lang") as? String
                    if languageType == "1"
                    {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssa"
                        if let date = formatter.date(from: inputDateAsString) {
                            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
                            formatter.dateFormat = "d MMM, HH:mm a"
                            let outputDate = formatter.string(from: date)
                            cell?.timeLabel.text = outputDate
                        }
                        else
                        {
                            cell?.timeLabel.text = (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "timeCount_ar") as? String
                        }
                    }else if languageType == "2"
                    {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssa"
                        if let date = formatter.date(from: inputDateAsString) {
                            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
                            formatter.dateFormat = "d MMM, HH:mm a"
                            let outputDate = formatter.string(from: date)
                            cell?.timeLabel.text = outputDate
                        }
                        else
                        {
                            cell?.timeLabel.text = (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "timeCount") as? String
                        }
                    }
                    else
                    {
                        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                        {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ssa"
                            if let date = formatter.date(from: inputDateAsString) {
                                formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
                                formatter.dateFormat = "d MMM, HH:mm a"
                                let outputDate = formatter.string(from: date)
                                cell?.timeLabel.text = outputDate
                            }
                            else
                            {
                                cell?.timeLabel.text = (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "timeCount_ar") as? String
                            }
                        }
                        else
                        {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ssa"
                            if let date = formatter.date(from: inputDateAsString) {
                                formatter.locale = NSLocale(localeIdentifier: "en") as Locale
                                formatter.dateFormat = "d MMM, HH:mm a"
                                let outputDate = formatter.string(from: date)
                                cell?.timeLabel.text = outputDate
                            }
                            else
                            {
                                cell?.timeLabel.text = (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "timeCount") as? String
                            }
                        }
                    }
                    
                    
                    let imgUrl = (arrAllNotifications.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_avatar")
                    cell?.userImageView.sd_addActivityIndicator()
                    let url = URL.init(string: "\(imgUrl!)")
                    cell?.userImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        cell?.userImageView.sd_removeActivityIndicator()
                    })
                    cell?.btnUserProfile.tag = indexPath.row
                    cell?.btnUserProfile.addTarget(self, action: #selector(methodNotificationUserProfile), for: .touchUpInside)
                    
                }
                return cell!
            }
            else
            {
                let identifier: String = "InboxTblCell"
                var cell : InboxTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? InboxTblCell
                
                if (cell == nil)
                {
                    let nib:Array<Any>!
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        nib = Bundle.main.loadNibNamed("InboxTblCell_AR", owner: nil, options: nil)!
                    }
                    else
                    {
                        nib = Bundle.main.loadNibNamed("InboxTblCell", owner: nil, options: nil)! as [Any]
                    }
                    cell = nib[0] as? InboxTblCell
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = UIColor.clear
                }
                if indexPath.section == 0
                {
                    if self.arrConverations.count > 0
                    {
                        let dicConverstion =  (arrConverations.object(at: indexPath.row) as! NSDictionary).object(forKey: "friend") as! NSDictionary
                        
                        let imgUrl = dicConverstion.object(forKey: "user_image")
                        
                        cell?.imgUsers.sd_addActivityIndicator()
                        let url = URL.init(string: "\(imgUrl!)")
                        cell?.imgUsers.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                            cell?.imgUsers.sd_removeActivityIndicator()
                        })
                        //  cell?.lblName.text = dicConverstion.object(forKey: "user_fullname") as? String
                        
                        if dicConverstion.object(forKey: "super_user") as? String == "0"
                        {
                            cell?.lblName.text = dicConverstion.object(forKey: "user_fullname") as? String
                        }
                        else
                        {
                            let strWorkingPost = dicConverstion.object(forKey: "user_fullname") as? String
                            let attachment = NSTextAttachment()
                            attachment.image = UIImage(named: "super_user_ic_badge.png")
                            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                            let attachmentStr = NSAttributedString(attachment: attachment)
                            let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                            myString.append(attachmentStr)
                            cell?.lblName.attributedText = myString
                        }
                        
                        ////Date Format
                        let formateSearch = DateFormatter()
                        formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        //                if  formateSearch.date(from: ((arrConverations.object(at: 0) as! NSDictionary).object(forKey: "conversation_time")as? String)!) != nil
                        //                {
                        
                        let  strBookingDate = formateSearch.date(from: ((arrConverations.object(at: indexPath.row) as! NSDictionary).object(forKey: "conversation_time")as? String)!)
                        
                        let   strSendtime = (timeAgo(strBookingDate!))
                        
                        ///Digit Formatter
                        
                        cell?.lblDate.text = strSendtime
                    }
                }
                else
                {
                    if self.arrAllAddFriends.count > 0
                    {
                        if (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image") as! String != ""
                        {
                            let imgUrl = (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image")
                            cell?.imgUsers.sd_addActivityIndicator()
                            let url = URL.init(string: "\(imgUrl!)")
                            cell?.imgUsers.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                                cell?.imgUsers.sd_removeActivityIndicator()
                            })
                        }
                        if (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
                        {
                            cell?.lblName.text = (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                        }
                        else
                        {
                            let strWorkingPost = (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                            let attachment = NSTextAttachment()
                            attachment.image = UIImage(named: "super_user_ic_badge.png")
                            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                            let attachmentStr = NSAttributedString(attachment: attachment)
                            let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                            myString.append(attachmentStr)
                            cell?.lblName.attributedText = myString
                        }
                    }
                }
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if  strTabbarClick == "FromNotification"
        {
            if(indexPath.item == arrAllNotifications.count - 1)
            {
                print (boolGetData)
                if (!boolGetData)
                {
                    if(pageCureent != totalPage )
                    {
                        boolGetData = true
                        if arrAllNotifications.count < totalRecord
                        {
                            self.showActivity(text: "")
                            
                            pageCureent = pageCureent + 1
                            //  print("pageCureent",pageCureent)
                            self.performSelector(inBackground: #selector(NotificationsListAPICall), with: nil)
                        }
                    }
                }
            }
        }
        if selecteOptions == 0
        {
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
                            self.showActivity(text: "")
                            
                            pageCureent = pageCureent + 1
                            //  print("pageCureent",pageCureent)
                            self.performSelector(inBackground: #selector(HomeAllPostAPI), with: nil)
                        }
                    }
                }
            }
        }
        else if selecteOptions == 1
        {
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
                            self.showActivity(text: "")
                            
                            pageCureent = pageCureent + 1
                            //  print("pageCureent",pageCureent)
                            self.performSelector(inBackground: #selector(updateAllPostListAPI), with: nil)
                        }
                    }
                }
            }
            
        }
        else if selecteOptions == 2
        {
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
                            self.showActivity(text: "")
                            
                            pageCureent = pageCureent + 1
                            //  print("pageCureent",pageCureent)
                            self.performSelector(inBackground: #selector(MyLikePostAPI), with: nil)
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if strTabbarClick == "FromInbox"
        {
            if section == 0
            {
                if self.arrConverations.count > 0
                {
                    return viewHeaderConveration
                }
                return nil
            }
            else
            {
                if self.arrAllAddFriends.count > 0
                {
                    return viewHeaderAllFri
                }
                return nil
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if strTabbarClick == "FromInbox"
        {
            if section == 0
            {
                if self.arrConverations.count > 0
                {
                    return 58
                }
                return 0
            }
            else
            {
                if self.arrAllAddFriends.count > 0
                {
                    return 58
                }
                return 0
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if strTabbarClick == "FromTimeLine"
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
                ProductD.dicAllPosts = arrAllPosts.object(at: indexPath.row) as! NSDictionary
                self.navigationController?.pushViewController(ProductD, animated: true)
            }
        }
        else if strTabbarClick == "FromInbox"
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
            
            if indexPath.section == 0
            {
                let dicConverstion =  (arrConverations.object(at: indexPath.row) as! NSDictionary).object(forKey: "friend") as! NSDictionary
                ChatV.strSltChatType = ""
                ChatV.strFriendID = dicConverstion.valueForNullableKey(key: kUserID)
                ChatV.strFriendName = dicConverstion.valueForNullableKey(key: "user_fullname")
            }
            else
            {
                ChatV.strSltChatType = "AddFriend"
                ChatV.strFriendID = (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
                ChatV.strFriendName = (arrAllAddFriends.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "user_fullname")
            }
            self.navigationController?.pushViewController(ChatV, animated: true)
        }
        else if strTabbarClick == "FromNotification"
        {
            let type = (arrAllNotifications.object(at: indexPath.row) as? NSDictionary ?? [:]).valueForNullableKey(key: "type")
            if type == "Appointment"
            {
                let type = (arrAllNotifications.object(at: indexPath.row) as? NSDictionary ?? [:]).valueForNullableKey(key: "is_offline")
                if type == "1"
                {
                    if UserDefaults.standard.getAppointmentStatus == "1"
                    {
                        if UserDefaults.standard.cat_parent_id == "4"
                        {
                            let controller = DoctorListTableViewController.instantiate(fromAppStoryboard: .Appointment)
                            controller.hospitalID = ""
                            self.navigationController?.pushViewController(controller, animated:true)
                        }else
                        {
                            let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
                            self.navigationController?.pushViewController(controller, animated:true)
                        }
                    }
                }
                else
                {
                    let not_id = (arrAllNotifications.object(at: indexPath.row) as? NSDictionary ?? [:]).valueForNullableKey(key: "not_id")
                    let controller = ApptDetailTVC.instantiate(fromAppStoryboard: .Appointment)
                    controller.notificationID = not_id
                    self.navigationController?.pushViewController(controller, animated:true)
                }
            } else if type == "Payment"
            {
                let controller = SubscriptionDetailScreen.instantiate(fromAppStoryboard: .Appointment)
                self.navigationController?.pushViewController(controller, animated:true)
            }
            else
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
                let postID = (arrAllNotifications.object(at: indexPath.row) as? NSDictionary ?? [:]).valueForNullableKey(key: "post_id")
                Notifi.strPostID = postID
                self.navigationController?.pushViewController(Notifi, animated: true)
            }
        }
        else
        {
            if indexPath.row != 0
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
                ProductD.dicAllPosts = arrAllPosts.object(at: indexPath.row) as! NSDictionary
                self.navigationController?.pushViewController(ProductD, animated: true)
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
    
    // MARK:- updateProfile API Integration.................
    func updateProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        let userID = UserDefaults.standard.object(forKey: kUserID)
        dictUser.setObject(userID!, forKey: kUserID as NSCopying)
        dictUser.setObject(userID!, forKey: "other_id" as NSCopying)
        
        return dictUser
    }
    
    @objc func updateGetProfileAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetProfile, Details: self.updateProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        self.arrProfileData = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                    }
                    else
                    {
                        print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    self.tblTimeline.reloadData()
                }
            }
        }
    }
    
    // MARK:- updateAll Post API Integration.................
    func updateAllPostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "other_id" as NSCopying)
        
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
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        // print("UpdateAll Post",responseData!)
                        
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
                                print("Array Count: **All Post**", self.arrAllPosts.count, self.arrAllPosts)
                            }
                        }
                        self.tblTimeline.reloadData()
                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
            //   self.tblTimeline.reloadData()
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
                        print("responseData",responseData!)
                        
                        if self.selecteOptions == 2
                        {
                            self.arrAllPosts.removeObject(at: Int(tagRow)!)
                            print("tagRow",tagRow)
                            self.tblTimeline.reloadData()
                            if Int(tagRow)! < self.arrAllPosts.count
                            {
                                let indexpath = IndexPath.init(item: Int(tagRow)!, section: 1)
                                self.tblTimeline.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
                                
                            }
                            else if Int(tagRow)! - 1 > 0 && Int(tagRow)! - 1 < self.arrAllPosts.count
                            {
                                
                                let indexpath = IndexPath.init(item: Int(tagRow)! - 1, section: 1)
                                self.tblTimeline.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
                                
                            }
                            
                        }
                        
                        
                        //     self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                        
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
    // MARK:- MyLike API Integration.................
    func MyLikePostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        
        return dictUser
    }
    
    @objc func MyLikePostAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodMyLikePost, Details: self.MyLikePostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey:"response") as! String
                        == "1"
                    {
                        // print("response: Else Part: - ",responseData!)
                        
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
                                print("Array Count: **My Like Post**", self.arrAllPosts.count, self.arrAllPosts)
                            }
                        }
                        
                        //  print("My LikePosts: - ",self.arrAllPosts)
                        
                        self.tblTimeline.reloadData()
                    }
                    else
                    {
                        print("response: Else Part: - ",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
            //   self.tblTimeline.reloadData()
        }
        
    }
    
    // MARK:- HomePost API Integration.................
    func HomePostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strPostID, forKey: "post_id" as NSCopying)
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        
        return dictUser
    }
    
    @objc func HomeAllPostAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodHomeAllPost, Details: self.HomePostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        //  print("arrAllPosts Main",responseData!)
                        
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
                                print("Array Count: **HOME All Post**", self.arrAllPosts.count, self.arrAllPosts)
                            }
                        }
                        self.tblTimeline.reloadData()
                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                }
            }
            //    self.tblTimeline.reloadData()
        }
    }
    
    // MARK:- Delete API Integration.................
    func DeletePostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(strPostID, forKey: "iPostId" as NSCopying)
        
        return dictUser
    }
    // kMethodPostDelete
    @objc func DeleteSelectedPostAPI()
    {
        print("sltdIndexPath",sltdIndexPath)
        getallApiResultwithGetMethod(strMethodname: strDeleteHideAPI, Details: self.DeletePostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        if self.selecteOptions == 1
                        {
                            if self.appDelegate.isInternetAvailable() == true
                            {
                                self.showActivity(text: "")
                                self.pageCureent = 1
                                
                                self.performSelector(inBackground: #selector(self.updateAllPostListAPI), with: nil)
                            }
                            else
                            {
                                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                            }
                            self.tblTimeline.reloadData()
                        }
                        else if self.selecteOptions == 2
                        {
                            if self.appDelegate.isInternetAvailable() == true
                            {
                                self.showActivity(text: "")
                                self.pageCureent = 1
                                
                                self.performSelector(inBackground: #selector(self.MyLikePostAPI), with: nil)
                            }
                            else
                            {
                                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                            }
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
            // print("AddReportParams", self.AddReportParams())
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        //  print("responseData",responseData!)
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
    
    // MARK:- Delete API Integration.................
    func FriendsListParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
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
    
    @objc func FriendsListAPICall()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodChatFriendList, Details: self.FriendsListParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        self.arrConverations = (responseData?.object(forKey: "allConversation")as!NSArray).mutableCopy() as! NSMutableArray
                        self.arrAllAddFriends = (responseData?.object(forKey: "allFriends")as!NSArray).mutableCopy() as! NSMutableArray
                        
                        print("responseData",responseData!)
                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    self.tblTimeline.reloadData()
                }
            }
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
                        self.strNotifcationUPTO = responseData?.valueForNullableKey(key: "upto") as! String
                        print("responseData",responseData!)
                        
                        print("From",self.strTabbarClick)
                        if  self.strTabbarClick == "FromNotification"
                        {
                            if self.appDelegate.isInternetAvailable() == true
                            {
                                let dicDetails = NSMutableDictionary()
                                dicDetails.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                                dicDetails.setObject(self.strNotifcationUPTO, forKey: "upto" as NSCopying)
                                
                                self.performSelector(inBackground: #selector(self.methodAddNotificationCount), with: dicDetails)
                            }
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
    // MARK:- Get Add Notification Integration.................
    @objc func methodAddNotificationCount(dicAddNoti: NSMutableDictionary)
    {
        //let dictParameters = NSDictionary()
        getallApiResultwithGetMethod(strMethodname: kMethodAddNotification, Details: dicAddNoti) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        
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
                        print("responseData",responseData!)
                        self.viewNotificationCount.isHidden = true
                    }
                }
            }
        }
    }
    
    // MARK:- Delete API Integration.................
    func NotificationListParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: kDefaultLanguage as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: kDefaultLanguage as NSCopying)
        }
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        
        return dictUser
    }
    
    @objc func NotificationsListAPICall()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodNotificationsList, Details: self.NotificationListParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        if self.pageCureent == 1
                        {
                            self.arrAllNotifications = NSMutableArray()
                        }
                        if responseData?.object(forKey: "notification_data") != nil && (responseData?.object(forKey: "notification_data") as! NSArray).count > 0
                        {
                            self.totalPage = (responseData?.object(forKey: "total_page")! as AnyObject).integerValue
                            self.totalRecord = (responseData?.object(forKey: "total_records")! as AnyObject).integerValue
                            
                            if responseData?.object(forKey: "notification_data") != nil && (responseData?.object(forKey: "notification_data") as! NSArray).count > 0
                            {
                                self.arrAllNotifications.addObjects(from: (responseData?.object(forKey: "notification_data") as? [AnyObject])!)
                                self.boolGetData = false
                                print("arrAllNotifications",responseData!)
                            }
                        }
                    }
                    else
                    {
                        if responseData?.object(forKey: "message") as? String == "User not exist."
                        {
                            self.appDelegate.logoutAndClearDefaults()
                        }
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    self.tblTimeline.reloadData()
                }
            }
        }
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
        debugPrint(getDayOfWeek(compareDate) ?? "")
        return getDayOfWeek(compareDate) ?? ""
        
        var temp: Int = 0
        var result: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        result = "\(dateFormatter.string(from: compareDate))"
        
        
        if timeInterval < 60 {
            dateFormatter.dateFormat = "HH:mm"
        }
        else
        {
            temp = Int(timeInterval / 60.0)
            
            if temp < 60
            {
                dateFormatter.dateFormat = "HH:mm"
            }
            else
            {
                temp = temp / 60
                if temp < 24 {
                    dateFormatter.dateFormat = "HH:mm"
                }
                else
                {
                    temp = temp / 24
                    
                    if temp < 7
                    {
                        dateFormatter.dateFormat = "EEEE, HH:mm"
                    }
                    else
                    {
                        dateFormatter.dateFormat = "MMMM, dd, HH:mm"
                    }
                }
            }
        }
        result = "\(dateFormatter.string(from: compareDate))"
        
        return result
    }
    
    //Graph Functions
    
    func getDayOfWeek(_ today:Date) -> String?
    {
        var date = ""
        var formattedDate = ""
        let currentDate = Date()
        
        let calendar = Calendar(identifier: .gregorian)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        let weekMonth = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let weekDay = calendar.component(.weekday, from: today)
        let hour = calendar.component(.hour, from: today)
        let minute = calendar.component(.minute, from: today)
        
        switch weekDay {
        case 1:
            date =  "Sun"
        case 2:
            date = "Mon"
        case 3:
            date = "Tue"
        case 4:
            date = "Wed"
        case 5:
            date = "Thu"
        case 6:
            date = "Fri"
        case 7:
            date = "Sat"
        default:
            date = ""
        }
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            date =  weekDay.getArabicWeekDay()
        }
        
        let hours = "\(hour)".count == 1 ? "0\(hour)" : "\(hour)"
        let minutes = "\(minute)".count == 1 ? "0\(minute)" : "\(minute)"
        
        if currentMonth != weekMonth
        {
            formattedDate =  "\(getMonthOfYear(today) ?? ""), \(day) \(hours):\(minutes)"
            return formattedDate
        }
        
        formattedDate =  "\(date), \(hours):\(minutes)"
        return formattedDate
    }
    
    func getMonthOfYear(_ today:Date) -> String? {
        var date = ""
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.month, from: today)
        switch weekDay {
        case 1:
            date = "January"
        case 2:
            date = "February"
        case 3:
            date = "March"
        case 4:
            date = "April"
        case 5:
            date = "May"
        case 6:
            date = "June"
        case 7:
            date = "July"
        case 8:
            date = "August"
        case 9:
            date = "September"
        case 10:
            date = "October"
        case 11:
            date = "November"
        case 12:
            date = "December"
        default:
            date = ""
        }
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            return weekDay.getArabicMonth()
        }
        else
        {
            return date
        }
        
    }
}


