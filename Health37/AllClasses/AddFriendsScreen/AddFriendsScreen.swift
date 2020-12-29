//
//  AddFriendsScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AddFriendsScreen: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {

    ////Iboutlets
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewTextFieldBG: UIView!
    @IBOutlet var txtSearchFriedn: UITextField!
    @IBOutlet var tblAddFriendsList: UITableView!
    

    var  arrAllFriends = NSMutableArray()
    var refreshControl = UIRefreshControl()
    var boolGetData:Bool!
    var pageCureent:Int!,totalRecord:Int!,totalPage:Int!,NoOFPageRecord:Int!
    var OtherFUserID = ""
    var strSearch:String! = ""
    var strSearchingOff = ""
    
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    @IBOutlet var btnSearch: UIButton!

    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewTextFieldBG.layer.cornerRadius = 17.0
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true

        DispatchQueue.main.async {

        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.methodGetAllFriendListApi), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
        }
        refreshControl.addTarget(self, action: #selector(PullRefresh), for:UIControlEvents.valueChanged)
        self.refreshControl.isHidden = true
        tblAddFriendsList.addSubview(refreshControl)
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            txtSearchFriedn.placeholder = "Search....".localized
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.titleView = viewHeader
//        self.performSelector(inBackground: #selector(self.methodNotificationCount), with: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

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

//        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
//        {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
//        }
//        else
//        {
//            self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "menu")
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))
//        }
    }
    ///sideMenu
    @objc override func methodSideMenu(_ sender : UIButton)
    {
        self.view.endEditing(true)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.menuContainerViewController.toggleRightSideMenuCompletion
                { () -> Void in
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

    
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object:nil)
        //NotificationCenter.default.removeObserver(self)
    }

    //PoolRefresh
    @objc func PullRefresh()
    {
        self.pageCureent = 1
        self.performSelector(inBackground: #selector(self.methodGetAllFriendListApi), with: nil)
        refreshControl.isHidden = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        })
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
       // MARK: - UIButtonsMethod
    
    //MARK: - textFiledDidChangedNotification
    
    @objc func textDidChanged(_ noti: Notification)
    {
        let textFiled = noti.object as! UITextField
        
        let strKeyword = textFiled.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.SearchKeywordreload), object: strKeyword)

        strSearch = strKeyword
        
        if strSearch != ""
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.pageCureent = 1
                self.performSelector(inBackground: #selector(self.methodSearchFriendListApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }
        }
        else
        {
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.methodGetAllFriendListApi), with: nil)

            textFiled.resignFirstResponder()
            
        }
    }
    
    @objc func SearchKeywordreload(strKeyword:String)
    {
        if strKeyword != ""
        {
            self.pageCureent = 1

            self.performSelector(inBackground: #selector(self.methodSearchFriendListApi), with: nil)
        }
        else
        {
            DispatchQueue.main.async {
                self.arrAllFriends.removeAllObjects()
//                self.viewSearchingDataBG.isHidden = true
//                self.strProducts = "NotSearchingProducts"
           //     self.tblAddFriendsList.reloadData()
                
            }
        }
    }

    
    ///SearchFriends
    @IBAction func methodSearchFriends(_ sender: Any)
    {
    }
    ///TimeLines
    @IBAction func methodTimeline(_ sender: UIButton)
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
    
     ///AllNotifications
    @IBAction func methodNotification(_ sender: UIButton)
    {
        if sender.tag == 1
        {
//            let Group  = TimelineScreen(nibName: "TimelineScreen",bundle:nil)
//            Group.strTabbarClick = "FromNotification"
//            self.navigationController?.pushViewController(Group, animated: true)
            
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
    }
     ///AllInboxMessages
    @IBAction func methodInbox(_ sender: UIButton)
    {
        if sender.tag == 2
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
    }
    
    @IBAction func methodAddFriend(_ sender: UIButton)
    {
        OtherFUserID = (self.arrAllFriends.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)

        if sender.isSelected == false
        {
            if appDelegate.isInternetAvailable() == true
            {
                
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.methodAddFriendApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
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
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }

        }
    }
    
    @IBAction func methodRemoveFriend(_ sender: UIButton)
    {
        OtherFUserID = (self.arrAllFriends.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        
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
      OtherUser.strFromGroup = "fromFriendList"
     OtherUser.strOtherFriendID = (self.arrAllFriends.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }

    ///////End Buttons Method////
    
  // MARK: - UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == arrAllFriends.count
        {
            return 40
        }
        else
        {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.arrAllFriends.count > 0
        {
            if pageCureent < totalPage
            {
                if strSearchingOff == "SearchingOFF"
                {
                    return arrAllFriends.count
                }
                else
                {
                    return arrAllFriends.count + 1
                }
            }
            else
            {
                return arrAllFriends.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == arrAllFriends.count
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

        //    let nib: Array = Bundle.main.loadNibNamed("AddFriendsTblCell", owner: nil, options: nil)!
            cell = nib[0] as? AddFriendsTblCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = UIColor.clear
        }
        cell?.imgFriends.layer.cornerRadius = (cell?.imgFriends.frame.size.width)!/2
        cell?.btnAddFriends.layer.cornerRadius = 15.0
        cell?.imgFriends.layer.masksToBounds = true
            
        cell?.btnAddFriends.tag = indexPath.row
           // self.arrAllFriends
            
            if (arrAllFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
            {
                cell?.lblFriendsName.text = (self.arrAllFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
            }
            else
            {
                let strWorkingPost = (self.arrAllFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "super_user_ic_badge.png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attachmentStr = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                myString.append(attachmentStr)
                cell?.lblFriendsName.attributedText = myString
            }

            if (self.arrAllFriends.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "isFriend") == "0"
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
            cell?.btnAddFriends.addTarget(self, action: #selector(methodAddFriend), for: .touchUpInside)
            let imgUrl = (self.arrAllFriends.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image") as? String
            cell?.imgFriends.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
           cell?.imgFriends.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell?.imgFriends.sd_removeActivityIndicator()
            })
            cell?.btnFriendProfile.tag = indexPath.row
            cell?.btnFriendProfile.addTarget(self, action: #selector(methodOtherUserProfile), for: .touchUpInside)
        return cell!
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if strSearchingOff == "SearchingOFF"
        {
            return
        }
        if(indexPath.item == arrAllFriends.count - 1)
        {
            print (boolGetData)
            if (!boolGetData)
            {
                if(pageCureent != totalPage )
                {
                    boolGetData = true
                    if arrAllFriends.count < totalRecord
                    {

                        pageCureent = pageCureent + 1
                        self.performSelector(inBackground: #selector(methodGetAllFriendListApi), with: nil)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)

                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                        self.onShowAlertController(title: "" , message: "صديق مضاف.")
                    }
                    else
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }


                  self.showActivity(text: "")
                    self.pageCureent = 1
                  self.performSelector(inBackground: #selector(self.methodGetAllFriendListApi), with: nil)
                //    self.tblAddFriendsList.reloadData()

                }
                else
                {
                    print("responseData",responseData!)
                 self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
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
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)
                    if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                    {
                            self.onShowAlertController(title: "" , message: "صديق إزالتها.")
                    }
                    else
                    {
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                    }

                  self.showActivity(text: "")
                    self.pageCureent = 1

                   self.performSelector(inBackground: #selector(self.methodGetAllFriendListApi), with: nil)

                }
                else
                {
                    print("responseData",responseData!)
                    self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                }
            }
        }
    }

    // MARK:- updateProfile API Integration.................
    func GetAllUserParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        
        return dictUser
    }
    
    @objc func methodGetAllFriendListApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAllUsersList, Details: self.GetAllUserParams()) { (responseData, error) in
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    self.strSearchingOff = ""

                    if self.pageCureent == 1
                    {
                        self.arrAllFriends = NSMutableArray()
                    }
                    if responseData?.object(forKey: kUserSavedDetails) != nil && (responseData?.object(forKey: kUserSavedDetails) as! NSArray).count > 0
                    {
                        self.totalPage = (responseData?.object(forKey: "total_page")! as AnyObject).integerValue
                        self.totalRecord = (responseData?.object(forKey: "total_records")! as AnyObject).integerValue
                        
                        if responseData?.object(forKey: kUserSavedDetails) != nil && (responseData?.object(forKey: kUserSavedDetails) as! NSArray).count > 0
                        {
                            self.arrAllFriends.addObjects(from: (responseData?.object(forKey: kUserSavedDetails) as? [AnyObject])!)
                            self.boolGetData = false
                          print(" self.arrAllFriends", self.arrAllFriends)
                        }
                        self.tblAddFriendsList.reloadData()
                    }
                    else
                    {
                    }
                }
                else
                {
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
                self.hideActivity()
            }
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
    // dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
        
        return dictUser
    }
    
    @objc func methodSearchFriendListApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodSearchFriendList, Details: self.SearchAllUserParams()) { (responseData, error) in
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    
                    self.arrAllFriends = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                    if self.pageCureent == 1
                    {
                        self.arrAllFriends = NSMutableArray()
                    }
                    if responseData?.object(forKey: kUserSavedDetails) != nil && (responseData?.object(forKey: kUserSavedDetails) as! NSArray).count > 0
                    {

                        if responseData?.object(forKey: kUserSavedDetails) != nil && (responseData?.object(forKey: kUserSavedDetails) as! NSArray).count > 0
                        {
                            self.arrAllFriends.addObjects(from: (responseData?.object(forKey: kUserSavedDetails) as? [AnyObject])!)
                            self.boolGetData = false
                            self.strSearchingOff = "SearchingOFF"
                        }
                    }
                    else
                    {
                    }
                    self.tblAddFriendsList.reloadData()

                }
                else
                {
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
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
