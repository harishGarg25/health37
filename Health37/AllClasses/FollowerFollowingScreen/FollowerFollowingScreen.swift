//
//  FollowerFollowingScreen.swift
//  Health37
//
//  Created by Ramprasad on 14/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class FollowerFollowingScreen: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblFollowers: UITableView!
    @IBOutlet weak var lblRecordNot: UILabel!
    
    var strFromFollowing = ""
    var strOtherUserID = ""
    var  arrFolloFollowers = NSMutableArray()
    var strStatusFuF = ""
    
    var strOtherFriendID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async
            {

        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.FollowerFollowingListAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kInternetError , message: kInternetErrorMessage.localized)
        }

        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false

        
        self.navigationItem.hidesBackButton = true
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if strFromFollowing == "FromFollowing"
            {
                self.navigationItem.title = "Following".localized
            }
            else
            {
                self.navigationItem.title = "Followers".localized
            }

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
            if strFromFollowing == "FromFollowing"
            {
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    self.navigationItem.title = "Following".localized

                    self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else
                {
                    self.navigationBarWithBackButton(strTitle: "Following".localized, leftbuttonImageName: "white_back")
                }
            }
            else
            {
                if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
                {
                    self.navigationItem.title = "Followers".localized

                     self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                }
                else
                {
                    self.navigationBarWithBackButton(strTitle: "Followers".localized, leftbuttonImageName: "white_back")
                }
            }
        }
    }
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction override func methodBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func methodFollowUnfollowUser(_ sender: UIButton)
    {
    strOtherFriendID = (self.arrFolloFollowers.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
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
    @IBAction func methodFollowerUserDetails(_ sender: UIButton)
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

        OtherUser.strOtherFriendID = (self.arrFolloFollowers.object(at: sender.tag) as! NSDictionary).valueForNullableKey(key: kUserID)
        self.navigationController?.pushViewController(OtherUser, animated: true)
    }

    // MARK: - UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 82
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.arrFolloFollowers.count > 0
        {
            return self.arrFolloFollowers.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier : String = "FollowersTblCell"
        var cell: FollowersTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? FollowersTblCell
        if (cell == nil)
        {
            let nib:Array<Any>!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                nib = Bundle.main.loadNibNamed("FollowersTblCell_AR", owner: nil, options: nil)!
            }
            else
            {
                nib = Bundle.main.loadNibNamed("FollowersTblCell", owner: nil, options: nil)! as [Any]
            }
            cell = nib[0] as? FollowersTblCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = UIColor.clear
        }
        
        
        if (arrFolloFollowers.object(at: indexPath.row) as! NSDictionary).object(forKey: "super_user") as? String == "0"
        {
            cell?.lblFollowerName.text = (arrFolloFollowers.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
        }
        else
        {
            if (arrFolloFollowers.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String != nil
            {
                let strWorkingPost = (arrFolloFollowers.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "super_user_ic_badge.png")
                attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attachmentStr = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: NSString.init(format: "%@ ", strWorkingPost!) as String)
                myString.append(attachmentStr)
                cell?.lblFollowerName.attributedText = myString
            }
        }

        
        let userSelfID = UserDefaults.standard.object(forKey: kUserID)!
        let userIDFollow = (arrFolloFollowers.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: kUserID)
        
        if "\(userSelfID)" == "\(userIDFollow)"
        {
           cell?.btnFollow.isHidden = true
        }
        else
        {
            cell?.btnFollow.isHidden = false
        }
        cell?.btnFollow.tag = indexPath.row
        cell?.btnFollow.addTarget(self, action: #selector(methodFollowUnfollowUser), for: .touchUpInside)

        if (arrFolloFollowers.object(at:indexPath.row) as! NSDictionary).valueForNullableKey(key: "is_following") == "1"
        {
            cell?.btnFollow.isSelected = true
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                cell?.btnFollow.setTitle("UNFOLLOW".localized, for: .selected)
            }

        }
        else
        {
            cell?.btnFollow.isSelected = false
            cell?.btnFollow.setTitle("FOLLOW".localized, for: .normal)

        }

        let imgUrl = (arrFolloFollowers.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image")
        cell?.imgFollwers.sd_addActivityIndicator()
        let url = URL.init(string: "\(imgUrl!)")
        cell?.imgFollwers.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            cell?.imgFollwers.sd_removeActivityIndicator()
        })
        cell?.btnFollowerUserDetails.tag = indexPath.row
     cell?.btnFollowerUserDetails.addTarget(self, action: #selector(methodFollowerUserDetails), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }

    // MARK:- Delete API Integration.................
    func FollowerFollowingParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "other_id" as NSCopying)
        
       dictUser.setObject(strOtherUserID, forKey: kUserID as NSCopying)

        if strFromFollowing == "FromFollowing"
        {
             dictUser.setObject("FOLLOWING", forKey: "type" as NSCopying)
        }
        else
        {
             dictUser.setObject("FOLLOWER", forKey: "type" as NSCopying)
        }
        
        return dictUser
    }
    
    @objc func FollowerFollowingListAPI()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodFollowerFollowing, Details: self.FollowerFollowingParams()) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    self.arrFolloFollowers = (responseData?.object(forKey: "request_data")as!NSArray).mutableCopy() as! NSMutableArray
                    print("Followers",self.arrFolloFollowers)
                    
                    if self.arrFolloFollowers.count > 0
                    {
                      self.lblRecordNot.isHidden = true
                    }
                    else
                    {
                        self.lblRecordNot.isHidden = false
                    }
      
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFollowerCount"), object: nil)

                   self.tblFollowers.reloadData()
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
                    print("FollowUnf",responseData!)
                    
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.FollowerFollowingListAPI), with: nil)

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
