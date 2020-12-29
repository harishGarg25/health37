//
//  WebViewScreen.swift
//  nSiight
//
//  Created by Ramprasad on 11/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class WebViewScreen: UIViewController {

    @IBOutlet weak var webViewUrl: UIWebView!
    var strWebURLFrom = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if strWebURLFrom == "PrivacyPolicy"
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                let url = URL (string: "\(Base_DOMAIN)post/privacy-policy-ar.php")
                let requestObj = URLRequest(url: url!)
                webViewUrl.loadRequest(requestObj)

            }
            else
            {
                let url = URL (string: "\(Base_DOMAIN)post/privacy-policy.php")
                let requestObj = URLRequest(url: url!)
                webViewUrl.loadRequest(requestObj)
            }
        }
        else
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                let url = URL (string: "\(Base_DOMAIN)post/terms-condition-ar.php")
                let requestObj = URLRequest(url: url!)
                webViewUrl.loadRequest(requestObj)
            }
            else
            {
                let url = URL (string: "\(Base_DOMAIN)post/terms-condition.php")
                let requestObj = URLRequest(url: url!)
                webViewUrl.loadRequest(requestObj)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false

        self.navigationItem.hidesBackButton = true

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.navigationItem.leftBarButtonItem = nil

            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(self.backButtonAction(_:)))
            }
            else
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(self.backButtonAction(_:)))
            }
        }
        else
        {
            if  (UserDefaults.standard.object(forKey: "applanguageArabic") as? String ?? "") == "ArabicDevice"
            {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(self.backButtonAction(_:)))
            }
            else
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(self.backButtonAction(_:)))
            }
       }

    }
//    @IBAction func methodBack(_ sender: Any)
//    {
//        self.menuContainerViewController.toggleLeftSideMenuCompletion
//            { () -> Void in
//        }
//
//    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
     //   self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc func backButtonAction(_ sender: UIBarButtonItem)
    {
            self.navigationController?.popViewController(animated:true)
    }

    //// Mobile No = 10 Time: 0000000000
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
