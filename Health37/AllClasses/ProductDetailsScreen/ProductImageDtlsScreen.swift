//
//  ProductImageDtlsScreen.swift
//  Health37
//
//  Created by Ramprasad on 15/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ProductImageDtlsScreen: UIViewController, UIScrollViewDelegate {

    var  dicAllPosts = NSDictionary()

    @IBOutlet var imgProducts: UIImageView!
    var strFromChat = ""
    
    @IBOutlet var scrollView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       // let vWidth = self.view.frame.width
      //  let vHeight = self.view.frame.height
        
        scrollView.delegate = self
      //  scrollView.frame = CGRect.init(x: 0, y: 0, width: vWidth, height: vHeight)
        
       // scrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        self.view.addSubview(scrollView)
        
        scrollView!.layer.cornerRadius = 11.0
        scrollView!.clipsToBounds = false
        scrollView.addSubview(imgProducts!)

        
        print("dicAllPosts",dicAllPosts)
        if strFromChat == "FromChat"
        {
            let imgUrl = dicAllPosts.object(forKey: "image")
            imgProducts.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
            imgProducts.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.imgProducts.sd_removeActivityIndicator()
            })
        }
        else
        {
            let imgUrl = dicAllPosts.object(forKey: "post_image")
            imgProducts.sd_addActivityIndicator()
            let url = URL.init(string: "\(imgUrl!)")
            imgProducts.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.imgProducts.sd_removeActivityIndicator()
            })
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgProducts
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
//            
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "white_back"), style: .done, target: self, action: #selector(self.backButtonAction(_:)))
//        }
//        else
//        {
//            self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "white_back")
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

    }
    @objc func BackTo(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func backButtonAction(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated:true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
