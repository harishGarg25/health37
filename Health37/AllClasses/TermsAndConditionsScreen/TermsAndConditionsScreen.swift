//
//  TermsAndConditionsScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class TermsAndConditionsScreen: UIViewController {

    ////IBoutlets
    @IBOutlet var scrollingBar: UIScrollView!
    @IBOutlet var viewTermsAndConditions: UIView!
    @IBOutlet var viewHeader: UIView!

    @IBOutlet var lblTermsConditions: UILabel!
    @IBOutlet var lblHeaderTitle: UILabel!
    
    @IBOutlet var btnTimeLine: UIButton!
    @IBOutlet var btnNotification: UIButton!
    @IBOutlet var btnInbox: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
        }

        viewTermsAndConditions.layer.cornerRadius = 6.0
        viewTermsAndConditions.layer.borderWidth = 1.0
        viewTermsAndConditions.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        DispatchQueue.main.async {
            self.scrollingBar.contentSize = CGSize.init(width: self.view.frame.size.width, height: 543)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
      //  self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "back-white")
        self.navigationItem.titleView = viewHeader
      //  self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "settng"), style: .done, target: self, action: #selector(methodSettings(_:)))

      //  self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back-white"), style: .done, target: self, action: #selector(methodBack(_:)))
        
        self.navigationItem.hidesBackButton = true
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = nil
              //  self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(methodBack(_:)))

            }
            else
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(methodBack(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(methodBack(_:)))

              //  self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(BackTo(_:)))
            }
            else
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(methodBack(_:)))
            }
        }

    }

    // MARK: - UIButtonsMethod
    ///SettingsScreenOpen
    @IBAction override func methodBack(_ sender: UIButton)
    {
        
        self.menuContainerViewController.toggleLeftSideMenuCompletion
            { () -> Void in
        }
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

}
