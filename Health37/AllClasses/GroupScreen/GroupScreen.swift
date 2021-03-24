//
// GroupScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 10/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class GroupScreen: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    ///IBoutlets
    @IBOutlet var tblGroups: UITableView!
    @IBOutlet var viewHeader: UIView!

    @IBOutlet var sepratorMyG: UILabel!
    @IBOutlet var sepratorAllG: UILabel!
    
    var refreshControl = UIRefreshControl()
    var boolGetData:Bool!
    var pageCureent:Int!,totalRecord:Int!,totalPage:Int!,NoOFPageRecord:Int!

    var  arrAllGroups = NSMutableArray()
    @IBOutlet  var viewTxtFBG: UIView!
    var strGroupID = ""
    var strIsMine = ""

    var strSearch:String! = ""

    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!
    @IBOutlet var btnAllGroups: UIButton!
    @IBOutlet var btnMyGroups: UIButton!
    @IBOutlet var txtSearchGroup: UITextField!
    
    @IBOutlet var lblNotificationCount: UILabel!
    
    @IBOutlet var viewNotificationCount: UIView!

    var kStrJoinLeaveKey = "joinGroup"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewNotificationCount.layer.cornerRadius = viewNotificationCount.frame.size.width/2
        viewNotificationCount.layer.masksToBounds = true

        viewTxtFBG.layer.cornerRadius = 18.0
        viewTxtFBG.layer.borderWidth = 1.0
        viewTxtFBG.layer.borderColor = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.pageCureent = 1
                    self.strIsMine = "0"
                    self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
        }

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            btnAllGroups.setTitle("All Groups".localized, for: .normal)
            btnMyGroups.setTitle("My Groups".localized, for: .normal)
            txtSearchGroup.placeholder = "Search....".localized
        }
        
        refreshControl.addTarget(self, action: #selector(PullRefresh), for:UIControlEvents.valueChanged)
        self.refreshControl.isHidden = true
        tblGroups.addSubview(refreshControl)

        NotificationCenter.default.addObserver(self, selector: #selector(updateGroupData), name: NSNotification.Name(rawValue: "updateGroupUsers"), object: nil)

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

    @objc func updateGroupData()
    {
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
    }

    //PoolRefresh
    @objc func PullRefresh()
    {
        
        self.pageCureent = 1
        self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
        refreshControl.isHidden = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        })
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

    

    // MARK: - UITextFieldMethod
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
        // MARK: - UIButtonsMethod
    //MARK: - textFiledDidChangedNotification
    
    @objc func textDidChanged(_ noti: Notification)
    {
        let textFiled = noti.object as! UITextField
        
        let strKeyword = textFiled.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    // NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.SearchKeywordreload), object: strKeyword)
//        print("strKeyword",strKeyword)
//
       strSearch = strKeyword
//
//        print("strSearch",strSearch)
        if strSearch != ""
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.arrAllGroups.removeAllObjects()
                self.performSelector(inBackground: #selector(self.methodSearchGroupListApi), with: nil)
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
                arrAllGroups.removeAllObjects()
                self.pageCureent = 1
                self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
                textFiled.resignFirstResponder()
            }
            else
            {
                self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            }

            
        }
    }
    ///TableView Scrolling method
    func methodTableIndexReload()
    {
        let indexitem = NSIndexPath.init(item: 0, section: 0)
        self.tblGroups.scrollToRow(at: indexitem as IndexPath, at: UITableViewScrollPosition.top, animated: false)
    }

    @IBAction func methodAllandMyGroups(_ sender: UIButton)
    {
        if sender.tag == 0
        {
        sepratorAllG.isHidden = false
        sepratorMyG.isHidden = true
        strIsMine = "0"
        }
        else
        {
         sepratorAllG.isHidden = true
        sepratorMyG.isHidden = false
            strIsMine = "1"
        }
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.pageCureent = 1
            self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
        }
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
    ///Open ChangeTitles
    @IBAction func methodChangeButtonTitle(_ sender: UIButton)
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

     strGroupID = (arrAllGroups.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: "groupID")
        
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.JoinLeaveGroupsAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
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
        OtherU.dicGroupDetails = (self.arrAllGroups.object(at: sender.tag) as! NSDictionary)
        self.navigationController?.pushViewController(OtherU, animated: true)
    }
    
    // MARK: - UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == arrAllGroups.count
        {
            return 0
        }
        else
        {
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  self.arrAllGroups.count > 0
        {
            if pageCureent < totalPage
            {
                return arrAllGroups.count
            }
            else
            {
                return arrAllGroups.count + 1
            }
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == arrAllGroups.count
        {
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            spinner.frame = CGRect(x: (UIScreen .main.bounds.size.width - 20)/2, y: 12, width: 20, height: 20)
            cell.addSubview(spinner)
            spinner.startAnimating()
            spinner.stopAnimating()
            return cell
        }
        else
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
        
        if (self.arrAllGroups.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "joined") == "approved_member"
        {
            cell?.btnJoin.isSelected = true
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                cell?.btnJoin.setTitle("غادر", for: .selected)
            }
        }
        else
        {
            cell?.btnJoin.isSelected = false
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                cell?.btnJoin.setTitle("انضم", for: .normal)
            }
        }
         cell?.btnJoin.tag = indexPath.row
        cell?.btnJoin.addTarget(self, action: #selector(methodJoinLeaveGroups), for: .touchUpInside)
        
        
        let imgUrl = (self.arrAllGroups.object(at: indexPath.row) as! NSDictionary).object(forKey: "groupImage") as? String
        cell?.imgUsers.sd_addActivityIndicator()
        let url = URL.init(string: "\(imgUrl!)")
        print("imgUrl&&&URL", imgUrl!)
        cell?.imgUsers.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            cell?.imgUsers.sd_removeActivityIndicator()
        })
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            cell?.lblTitle.text = (arrAllGroups.object(at: indexPath.row) as! NSDictionary).object(forKey: "groupNameArabic") as? String
            cell?.lblSubtitle.text = "\((arrAllGroups.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "groupUserCount"))" + " أفراد"
        }
        else
        {
            cell?.lblTitle.text = (arrAllGroups.object(at: indexPath.row) as! NSDictionary).object(forKey: "groupName") as? String
            cell?.lblSubtitle.text = "\((arrAllGroups.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "groupUserCount"))" + " Members"
        }

        cell?.btnGroupDtls.tag = indexPath.row
        cell?.btnGroupDtls.addTarget(self, action: #selector(methodGroupDetails), for: .touchUpInside)
        return cell!
    }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if(indexPath.row == arrAllGroups.count - 1)
        {
            print (boolGetData)
            if (!boolGetData)
            {
                if(pageCureent != totalPage )
                {
                    boolGetData = true
                    if arrAllGroups.count < totalRecord
                    {
                        
                        pageCureent = pageCureent + 1
                        self.performSelector(inBackground: #selector(AllGroupsListAPI), with: nil)
                    }
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
                    
                //    self.arrAllGroups = (responseData?.object(forKey: "groups_data")as!NSArray).mutableCopy() as! NSMutableArray

                    if self.pageCureent == 1
                    {
                        self.arrAllGroups = NSMutableArray()
                    }
                    if responseData?.object(forKey: "groups_data") != nil && (responseData?.object(forKey: "groups_data") as! NSArray).count > 0
                    {
                        self.totalPage = (responseData?.object(forKey: "total_page")! as AnyObject).integerValue
                        self.totalRecord = (responseData?.object(forKey: "total_records")! as AnyObject).integerValue

                        if responseData?.object(forKey: "groups_data") != nil && (responseData?.object(forKey: "groups_data") as! NSArray).count > 0
                        {
                            self.arrAllGroups.addObjects(from: (responseData?.object(forKey: "groups_data") as? [AnyObject])!)
                            self.boolGetData = false
                            print("self.arrAllGroups",self.arrAllGroups)
                            print("ArrayCount",self.arrAllGroups.count)

                        }
                    }
                    //   self.methodTableIndexReload()
                    self.tblGroups.reloadData()

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
                    
                    print("JoinLeave",responseData!)
                    self.showActivity(text: "")
                    self.pageCureent = 1
                    self.performSelector(inBackground: #selector(self.AllGroupsListAPI), with: nil)
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
    
    // MARK:- updateProfile API Integration.................
    func SearchGroupsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if strSearch != ""
        {
            dictUser.setObject(strSearch, forKey: kKeyWord as NSCopying)
        }
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
//        dictUser.setObject(pageCureent, forKey: kPageNo as NSCopying)
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
    
    @objc func methodSearchGroupListApi()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodSearchGroupList, Details: self.SearchGroupsParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                 
                     print("Groups",self.arrAllGroups)
//                    self.arrAllGroups = (responseData?.object(forKey: "groups_data")as!NSArray).mutableCopy() as! NSMutableArray
//                   print("Groups",self.arrAllGroups)
                    
//                    if self.pageCureent == 1
//                    {
//                        self.arrAllGroups = NSMutableArray()
//                    }
                    if responseData?.object(forKey: "groups_data") != nil && (responseData?.object(forKey: "groups_data") as! NSArray).count > 0
                    {
                        self.arrAllGroups = (responseData?.object(forKey: "groups_data") as! NSArray).mutableCopy() as! NSMutableArray
//                            self.arrAllGroups.addObjects(from: (responseData?.object(forKey: "groups_data") as? [AnyObject])!)
                         print("Groups",self.arrAllGroups)
//                            self.boolGetData = false
                        //    self.strSearchingOff = "SearchingOFF"
                    }
                    else
                    {
                        
                    }
                   self.tblGroups.reloadData()
                    
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
