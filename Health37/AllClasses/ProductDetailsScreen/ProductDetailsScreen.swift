//
//  ProductDetailsScreen.swift
//  Health37
//
//  Created by Ramprasad on 15/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ProductDetailsScreen: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblProductDtls: UITableView!
    var  dicAllPosts = NSDictionary()
    var strPostID = ""
    var strActionSet = ""
    var  arrExpendedRow = NSMutableArray()
    var strLikeValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dicAllPosts",dicAllPosts)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        
        //        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        //        {
        //            self.navigationItem.leftBarButtonItem = nil
        //                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
        //            self.navigationItem.title = "\(dicAllPosts.object(forKey: "user_fullname")!)"
        //
        //        }
        //        else
        //        {
        //            self.navigationBarWithBackButton(strTitle: "\(dicAllPosts.object(forKey: "user_fullname")!)", leftbuttonImageName: "white_back")
        //        }
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
                
                self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "white_back")
            }
        }
        self.navigationItem.title = "\(dicAllPosts.object(forKey: "user_fullname")!)"
    }
    // MARK: - UIBUttonsMethod
    
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func methodLikeUnlikePost(_ sender: UIButton)
    {
        
        if appDelegate.isInternetAvailable() == false
        {
            self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
            return
        }
        
        let dicLike = NSMutableDictionary.init(dictionary: dicAllPosts)
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
        
        
        let inDexPath = IndexPath.init(row: sender.tag, section: 0)
        let cellLike = tblProductDtls.cellForRow(at: inDexPath) as? ProductDetailsTblCell
        
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
    ///TableView Scrolling method
    func methodTableIndexReload()
    {
        let indexitem = NSIndexPath.init(item: 0, section: 0)
        self.tblProductDtls.scrollToRow(at: indexitem as IndexPath, at: UITableViewScrollPosition.top, animated: false)
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
        
        //   let Notifi  = NotificationAddComment(nibName: "NotificationAddComment",bundle:nil)
        Notifi.strPostID = dicAllPosts.valueForNullableKey(key: "post_id")
        Notifi.strFromTimeLine = "FromTimeLine"
        self.navigationController?.pushViewController(Notifi, animated: true)
    }
    ///SharingSocialPopupShow
    @IBAction func methodSharingonSocialPopup(_ sender: UIButton)
    {
        strPostID = dicAllPosts.valueForNullableKey(key: "post_id")
        
        let strPostImage = dicAllPosts.valueForNullableKey(key: "post_image")
        var strPostContent = dicAllPosts.valueForNullableKey(key: "post_content")
        
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
    
    // MARK: - UITableViewMethods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if dicAllPosts.count > 0
        {
            var height: CGFloat = 80.0 + 70.0
            
            let stringImage = dicAllPosts.object(forKey: "post_image") as! String
            let stringDes = dicAllPosts.object(forKey: "post_content") as! String
            let decodedString = stringDes.decode() ?? ""

            if stringImage != ""
            {
                height = height +  260.0
            }
            if decodedString != ""
            {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
        if dicAllPosts.count > 0
        {
            let ratingCount = dicAllPosts.valueForNullableKey(key: "rating")
            
            cell?.viewRating.contentMode = UIViewContentMode.scaleAspectFit
            cell?.viewRating.maxRating = 5
            cell?.viewRating.minRating = Int(ratingCount) ?? 0
            cell?.viewRating.editable = false
            // cell?.viewRating.halfRatings = true
            // cell?.viewRating.floatRatings = false
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                cell?.viewRating.transform = CGAffineTransform(scaleX: -1, y: 1);
            }
            
            cell?.btnDelete.tag = indexPath.row
            
            cell?.btnDelete.isHidden = true
            cell?.btnInformation.isHidden = true
            
            cell?.lblNameTimeline.text = dicAllPosts.object(forKey: "user_fullname") as? String
            
            
            if dicAllPosts.object(forKey: "post_image") as! String != ""
            {
                let imgUrl = dicAllPosts.object(forKey: "post_image")
                cell?.imgPost.sd_addActivityIndicator()
                //                let url = URL.init(string: "\(imgUrl!)")
                //                cell?.imgPost.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                //                    cell?.imgPost.sd_removeActivityIndicator()
                //                })
                cell?.imgPost.sd_setImage(with: URL(string: "\(imgUrl!)"), placeholderImage: UIImage(named: "cover_place_holder.png"))
                
            }
            if dicAllPosts.object(forKey: "post_content") as! String != ""
            {
                let str =  dicAllPosts.object(forKey: "post_content") as! String
                if let decodedString : String = str.decode() {
                    cell?.lblPostDetails.text = decodedString
                }
                else
                {
                    cell?.lblPostDetails.text = str
                }
                
            }
            
            let stringImage = dicAllPosts.object(forKey: "post_image") as! String
            
            let stringDes = dicAllPosts.object(forKey: "post_content") as! String
            
            if stringDes != ""
            {
                cell?.lblPostDetails.isHidden = false
                let decodedString = stringDes.decode()
                let hh = getLabelHeight(text: decodedString, width: ScreenSize.SCREEN_WIDTH - 48, font: UIFont.init(name: "Lato-Regular", size: 13)!)
                
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
                if let decodedString : String = stringDes.decode() {
                    cell?.lblPostDetails.text = decodedString
                }
                else
                {
                    cell?.lblPostDetails.text = stringDes
                }
                
                
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
            
            let imgUrlUser = dicAllPosts.object(forKey: "user_avatar")
            cell?.imgTimeline.sd_addActivityIndicator()
            let url1 = URL.init(string: "\(imgUrlUser!)")
            cell?.imgTimeline.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url1) in
                cell?.imgTimeline.sd_removeActivityIndicator()
            })
            //            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            //            {
            //                cell?.lblTimeAgo.text = dicAllPosts.object(forKey: "time_count_ar")as? String
            //            }
            //            else
            //            {
            
            if dicAllPosts.object(forKey: "time")as? String != nil
            {
                let formateSearch = DateFormatter()
                formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if  formateSearch.date(from: (dicAllPosts.object(forKey: "time")as? String)!) != nil
                {
                    let  strBookingDate = formateSearch.date(from: (dicAllPosts.object(forKey: "time")as? String)!)
                    
                    let str = formateSearch.string(from: strBookingDate!)
                    let datebooking = formateSearch.date(from: str)
                    
                    formateSearch.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let timesPost = formateSearch.string(from: datebooking!)
                    print("timesPost",timesPost)
                    // let strTime = UTCToLocal(date: timesPost)
                    
                    //                        let newdatebooking = formateSearch.date(from: timesPost)
                    //
                    //                        let   strSendtime = (timeAgo(strBookingDate!))
                    
                    cell?.lblTimeAgo.text = timesPost//UTCToLocal(date: timesPost)
                }
            }
            else
            {
                cell?.lblTimeAgo.text = dicAllPosts.object(forKey: "time_count")as? String
            }
            // }
            
        }
        ////Date Format
        
        cell?.btnSharing.tag = indexPath.row
        
        cell?.btnSharing.addTarget(self, action: #selector(methodSharingonSocialPopup), for: .touchUpInside)
        
        cell?.btnComments.tag = indexPath.row
        cell?.btnComments.addTarget(self, action: #selector(methodAllComments), for: .touchUpInside)
        
        cell?.lblComment.text = String.init(format: "(%@)", dicAllPosts.object(forKey: "comments") as! CVarArg)
        
        var myInt = Int(NSString(format: "%@", dicAllPosts.valueForNullableKey(key: "likes")).intValue)
        print("likeCount",myInt)
        if strLikeValue == "1"
        {
            myInt = myInt + 1
            cell?.lblLikeCount.text = String.init(format: "(%d)", myInt)
        }
        else
        {
            cell?.lblLikeCount.text = String.init(format: "(%@)", dicAllPosts.object(forKey: "likes") as! CVarArg) as? String
        }
        
        if  dicAllPosts.object(forKey: "is_like") as! String  == "1"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if  dicAllPosts.object(forKey: "post_image") as! String != ""
        {
            let ProductD  = ProductImageDtlsScreen(nibName: "ProductImageDtlsScreen",bundle:nil)
            ProductD.dicAllPosts = dicAllPosts
            self.navigationController?.pushViewController(ProductD, animated: true)
        }
    }
    
    @objc func LikeUnlikePostAPI(dicLike : NSMutableDictionary)
    {
        getallApiResultwithGetMethod(strMethodname: kMethodLikeUnlike, Details: dicLike) { (responseData, error) in
            DispatchQueue.main.async {
                self.hideActivity()
                if error == nil
                {
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        //                    if responseData?.object(forKey: "is_like")! as! String == "ALREADY_LIKED"
                        //                    {
                        //                      self.strLikeValue = "0"
                        //                    }
                        //                    else
                        //                    {
                        //                        self.strLikeValue = "1"
                        //                    }
                        print("responseData",responseData!)
                        
                        //    self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLikeUnlike"), object: nil)
                        
                    }
                    else
                    {
                        print("responseData",responseData!)
                        //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                    }
                    // self.tblProductDtls.reloadData()
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
    
    func timeAgo(_ compareDate: Date) -> String
    {
        let timeInterval: TimeInterval = -compareDate.timeIntervalSinceNow
        var temp: Int = 0
        var result: String
        
        
        
        if timeInterval < 60 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let str = dateFormatter.string(from: compareDate)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "HH:mm"
            let newdatebooking = dateFormatter.date(from: str)
            
            result = "\(dateFormatter.string(from: newdatebooking!))"          //less than a minute
        }
        else
        {
            temp = Int(timeInterval / 60.0)
            
            if temp < 60
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                
                let str = dateFormatter.string(from: compareDate)
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "HH:mm"
                let newdatebooking = dateFormatter.date(from: str)
                result = "\(dateFormatter.string(from: newdatebooking!))"
            }
            else
            {
                temp = temp / 60
                
                if temp < 24 {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    
                    let str = dateFormatter.string(from: compareDate)
                    dateFormatter.timeZone = TimeZone.current
                    dateFormatter.dateFormat = "HH:mm"
                    let newdatebooking = dateFormatter.date(from: str)
                    
                    result = "\(dateFormatter.string(from: newdatebooking!))" //7 days ago
                }
                else
                {
                    temp = temp / 24
                    
                    if temp < 7
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEEE, HH:mm"
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        
                        let str = dateFormatter.string(from: compareDate)
                        dateFormatter.timeZone = TimeZone.current
                        dateFormatter.dateFormat = "EEEE, HH:mm"
                        let newdatebooking = dateFormatter.date(from: str)
                        
                        result = "\(dateFormatter.string(from: newdatebooking!))" //7 days ago
                    }
                    else
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, HH:mm"
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        
                        let str = dateFormatter.string(from: compareDate)
                        dateFormatter.timeZone = TimeZone.current
                        dateFormatter.dateFormat = "MMMM, dd, HH:mm"
                        let newdatebooking = dateFormatter.date(from: str)
                        
                        result = "\(dateFormatter.string(from: newdatebooking!))" //7 days ago
                    }
                }
            }
        }
        return result
    }}
