//
//  RateAndReviewScreen.swift
//  Health37

//  Created by Ramprasad on 21/11/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class RateAndReviewScreen: UIViewController, FloatRatingViewDelegate,UITextViewDelegate, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var ratingReviews: FloatRatingView!
    var sltRating : Double = 0
    var delegate: FloatRatingViewDelegate?
    @IBOutlet var toolBar: UIToolbar!

    @IBOutlet var tblRateReview: UITableView!
    @IBOutlet var viewHeaderRateReview: UIView!
    @IBOutlet var viewRateReviewBG: UIView!
    @IBOutlet var txtEnterReview: SZTextView!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnNoThanks: UIButton!

    var  arrRatingList = NSArray()

    var strOtherFriendID = ""
    var strFromRating = ""
    var strIsRated = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEnterReview.inputAccessoryView = toolBar
        tblRateReview.estimatedRowHeight = 120
        tblRateReview.rowHeight = UITableViewAutomaticDimension

        viewRateReviewBG.layer.cornerRadius = 6.0
        viewRateReviewBG.layer.borderWidth = 1.0
        viewRateReviewBG.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        ratingReviews.delegate = self

        ratingReviews.emptyImage = UIImage(named: "greystar.png")
        ratingReviews.fullImage = UIImage(named: "starBig.png")
        ratingReviews.backgroundColor = UIColor.clear
        ratingReviews.contentMode = UIViewContentMode.scaleAspectFit
        ratingReviews.rating = sltRating
        ratingReviews.editable = true
        
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
           // btnSubmit.setTitle("SUBMIT".localized, for: .normal)
            btnNoThanks.setTitle("NO, THANKS".localized, for: .normal)
            txtEnterReview.placeholderString = "Enter your reviews here...".localized

        }
        DispatchQueue.main.async
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.GetOtherUserRatingsAPICall), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }
        }

    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
//             self.navigationItem.title = "معدل ومراجعات"
            self.navigationItem.title = "تقييم ومراجعة"

            self.navigationItem.leftBarButtonItem = nil
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
              
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
        }
        else
        {
             self.navigationItem.title = "Rates and Review"
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
               txtEnterReview.textAlignment = .left
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationBarWithBackButton(strTitle: "Rate & Reviews", leftbuttonImageName: "white_back")
            }
        }

        
    }
    
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @objc override func methodSideMenu(_ sender : UIButton)
    {
        self.view.endEditing(true)
       self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //method Signin & Signup
    @IBAction func methodKeyPadDone(_ sender: Any)
    {
        self.view.endEditing(true)
        
    }
    // MARK:- Check RatingSubmit Validation................
    
    func CheckValidation() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txtEnterReview.text == ""
        {
            isGo = false
            errorMessage = kEnterRatingError.localized
        }
        
        if !isGo
        {
            onShowAlertController(title: "Error" , message: errorMessage)
        }
        
        return isGo
        
    }

    //method Signin & Signup
    @IBAction func methodKeyPadCancel(_ sender: Any)
    {
        self.view.endEditing(true)
        
    }
    @IBAction func methodSubmitNoThanks(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            if CheckValidation()
            {
                if appDelegate.isInternetAvailable() == true
                {
                    self.showActivity(text: "")
                    
                    self.performSelector(inBackground: #selector(self.AddRatingsAPICall), with: nil)
                }
                else
                {
                    self.onShowAlertController(title: kInternetError.localized , message: kInternetErrorMessage.localized)
                }

            }
        }
    }
    
     // MARK: - Floating Delegate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print("asdfsdf")
    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double)
    {
        print("asdfasdf", rating)
        sltRating = rating
        print("sltRating", sltRating)
    }
    @objc public enum FloatRatingViewType: Int {
        /// Integer rating
        case wholeRatings
        /// Double rating in increments of 0.5
        case halfRatings
        /// Double rating
        case floatRatings
        
        /// Returns true if rating can contain decimal places
        func supportsFractions() -> Bool {
            return self == .halfRatings || self == .floatRatings
        }
    }
    
    // MARK: - UITextViewMethods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (textView.text == "" && text == " ") ||  (textView.text == "" && text == "/n")//(textView.text == "" && text == " ")
        {
            return false
        }
        let newLength = textView.text!.characters.count + text.characters.count - range.length
        
        return newLength >  250 ? false : true
    }
    // MARK: - UIButtonsMethod
    @IBAction func methodSetting(_ sender: Any)
    {
//        self.menuContainerViewController.toggleRightSideMenuCompletion
//            { () -> Void in
//        }
    }
    
    //MARK:- UITableView DataSource And Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if  "\(UserDefaults.standard.object(forKey: kUserID)!)" == "\(strOtherFriendID)" || strIsRated == "1"
        {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if  "\(UserDefaults.standard.object(forKey: kUserID)!)" == "\(strOtherFriendID)" || strIsRated == "1"
        {
            if  arrRatingList.count > 0
            {
                return arrRatingList.count
            }
            return 0
        }
        else
        {
            if arrRatingList.count > 0
            {
                return arrRatingList.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return UITableViewAutomaticDimension
       // return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let identifier: String = "ReviewListCell"
            var cell: ReviewListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReviewListCell
            if (cell == nil)
            {
              //  let nib: Array = Bundle.main.loadNibNamed("ReviewListCell", owner: nil, options: nil)!
                let nib:Array<Any>!
                if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
                {
                    nib = Bundle.main.loadNibNamed("ReviewListCell_AR", owner: nil, options: nil)!
                }
                else
                {
                    nib = Bundle.main.loadNibNamed("ReviewListCell", owner: nil, options: nil)! as [Any]
                } //ReviewListCell_AR

                cell = nib[0] as? ReviewListCell
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = UIColor.clear
            }
        cell?.nameLabel.text = (arrRatingList.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_fullname") as? String
        cell?.descriptionLabel.text = (arrRatingList.object(at: indexPath.row) as! NSDictionary).object(forKey: "review") as? String
        let ratingCount = (arrRatingList.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "rating")
        
        cell?.ratingReviews.emptyImage = UIImage(named: "greystar.png")
        cell?.ratingReviews.fullImage = UIImage(named: "starBig.png")
        cell?.ratingReviews.backgroundColor = UIColor.clear
        cell?.ratingReviews.contentMode = UIViewContentMode.scaleAspectFit
        cell?.ratingReviews.rating = Double(ratingCount)!
        cell?.ratingReviews.editable = false

        let imgUrl = (arrRatingList.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image")
        cell?.userImageView.sd_addActivityIndicator()
        let url = URL.init(string: "\(imgUrl!)")
        cell?.userImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            cell?.userImageView.sd_removeActivityIndicator()
        })
            return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if  "\(UserDefaults.standard.object(forKey: kUserID)!)" != "\(strOtherFriendID)" && strIsRated == "0"
        {
            return viewHeaderRateReview
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if  "\(UserDefaults.standard.object(forKey: kUserID)!)" != "\(strOtherFriendID)" && strIsRated == "0"
        {
           return 270
        }
        else
        {
            return 0
        }
    }

    // MARK:- GetRatings API Integration.................
    func GetRatingsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
       // dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
         dictUser.setObject(strOtherFriendID, forKey: "other_id" as NSCopying)
        
        return dictUser
    }
    
    @objc func GetOtherUserRatingsAPICall()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodGetRatingList, Details: self.GetRatingsParams()) { (responseData, error) in
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                 //   print("arrAllRate",responseData!)
                    self.arrRatingList = responseData?.object(forKey: "request_data") as? NSArray ?? NSArray()
                    if self.arrRatingList.count > 0
                    {
                      //  self.viewHeaderRateReview.isHidden = true
                    }
                    else
                    {
                      //  self.viewHeaderRateReview.isHidden = false
                    }
                     self.viewHeaderRateReview.isHidden = false
                    self.tblRateReview.reloadData()

                }
                else
                {
                    self.viewHeaderRateReview.isHidden = false
                    
                    if responseData?.object(forKey: "message") as? String == "User not exist."
                    {
                        self.appDelegate.logoutAndClearDefaults()
                    }
                //    self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                }
                self.tblRateReview.reloadData()
            }
            self.hideActivity()
        }
    }
    
    // MARK:- AddRatings API Integration.................
    func AddRatingsParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        
       dictUser.setObject("\(txtEnterReview.text!)", forKey: "review" as NSCopying)
        dictUser.setObject(sltRating, forKey: "rating" as NSCopying)
        
         dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: "from_id" as NSCopying)
        dictUser.setObject(strOtherFriendID, forKey: "to_id" as NSCopying)

        return dictUser
    }
    
    @objc func AddRatingsAPICall()
    {
        getallApiResultwithGetMethod(strMethodname: kMethodAddRating, Details: self.AddRatingsParams()) { (responseData, error) in
            if error == nil
            {
                self.hideActivity()
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFollowerCount"), object: nil)

                    self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)

                }
                else
                {
                    if responseData?.object(forKey: "message") as? String == "User not exist."
                    {
                        self.appDelegate.logoutAndClearDefaults()
                    }
                    //    self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
                }
                self.tblRateReview.reloadData()
            }
            self.hideActivity()
        }
    }

}
