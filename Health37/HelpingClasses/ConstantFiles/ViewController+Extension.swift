//
//  ViewController+Extension.swift
//  Health37
//
//  Created by Deepak iOS on 22/02/18.
//  Copyright © 2018 Nine Hertz India. All rights reserved.

import Foundation
import UIKit
import NotificationBannerSwift

extension UIViewController {
    
    var appDelegate : AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func navigationBarWithBackButton(strTitle : String, leftbuttonImageName : String)
    {
        self.navigationItem.title = strTitle
        self.navigationController?.navigationBar.isHidden = false
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 152/255, blue: 159/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        var sel: Selector!
        if (leftbuttonImageName == "back-white") || (leftbuttonImageName == "white_back")
        {
            sel = #selector(methodBack(_:))
        }
        else
        {
            sel = #selector(methodSideMenu(_:))
        }
        let menuButton : UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: leftbuttonImageName)!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: sel)
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func methodBack(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func methodSideMenu(_ sender : UIButton)
    {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion
            { () -> Void in
    }
    }


    // show alert controller //onShowAlertControllerAction
    func onShowAlertControllerAction(title : String?,message : String?) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) in
            // self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    // show alert controller
    func onShowAlertController(title : String?,message : String?) {
        
        // Basic Danger Notification
        let banner = NotificationBanner(title: "" ,subtitle: message ,style: .danger)
        // banner.delegate = self
        
        banner.duration = 1.0
        banner.show(queuePosition: .front, bannerPosition: .top)
        
    }
    
    func showLog(text : Any , type : String) {
        print("\(type) : \(text)")
    }

    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showActivity(text : String)
    {
        let viewTemp = activityView()
        viewTemp.frame = self.view.bounds
        viewTemp.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        viewTemp.showHudFor(view: viewTemp, withText: text)
        self.view.addSubview(viewTemp)
    }
    
    func hideActivity()
    {
        for view in self.view.subviews {
            
            if view is activityView {
                
                view.removeFromSuperview()
            }
            
        }
    }
    func Method_HeightCalculation(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let rect =  CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        let label:UILabel = UILabel(frame: rect)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    // MARK:- HeightCalculate Lable
    func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.font = font
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.sizeToFit()
        return lbl.frame.size.height
    }

    class activityView: UIView
    {
        
        func showHudFor(view:UIView, withText strText:String)
        {
            
            
            let viewContainer : UIView = UIView.init(frame: CGRect.init(x: 30, y: (ScreenSize.SCREEN_HEIGHT/2) - 100, width: (ScreenSize.SCREEN_WIDTH) - 60, height: 200))
            
            let rectFrame : CGRect = CGRect.init(x: (viewContainer.frame.size.width/2)-30, y: (viewContainer.frame.size.height/2)-58, width: 60, height: 60)
            
            let objAJProgressView = AJProgressView()
            
            
            // Pass your image here which will come in centre of ProgressView
            
            // Pass the colour for the layer of progressView
            objAJProgressView.firstColor = UIColor.white
            
            // If you  want to have layer of animated colours you can also add second and third colour
            objAJProgressView.secondColor = UIColor.white
            objAJProgressView.thirdColor = UIColor.white
            
            // Set duration to control the speed of progressView
            objAJProgressView.duration = 3.0
            
            // Set width of layer of progressView
            objAJProgressView.lineWidth = 4.0
            
            //Set backgroundColor of progressView
            objAJProgressView.bgColor =  UIColor.black.withAlphaComponent(0.2)
            
            objAJProgressView.show()
            
            viewContainer.backgroundColor = UIColor.white
            
            self.addSubview(objAJProgressView)
        }
        
    }

    // MARK: - ************  Image Orientation ************
    
    func fixedOrientation(img : UIImage) -> UIImage {
        
        
        if img.imageOrientation == UIImageOrientation.up {
            return img
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch img.imageOrientation
        {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: img.size.width, y: img.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: img.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch img.imageOrientation
        {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: img.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: img.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height), bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0, space: img.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch img.imageOrientation
        {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(img.cgImage!, in: CGRect(origin: CGPoint.zero, size: img.size))
        default:
            ctx.draw(img.cgImage!, in: CGRect(origin: CGPoint.zero, size: img.size))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
  }



extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    @IBInspectable var corner: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
               layer.masksToBounds = newValue > 0
           }
       }
       
       @IBInspectable var shadowRadius: CGFloat {
           get {
               return layer.shadowRadius
           }
           set {
               layer.shadowRadius = newValue
           }
       }
}

extension Int
{
    func getArabicWeekDay() -> String {
        var week = ""
        switch (self) {
            case 1:
                week = "الأحد";
                break;
            case 2:
                week = "الاثنين";
                break;
            case 3:
                week = "الثلاثاء";
                break;
            case 4:
                week = "الأربعاء";
                break;
            case 5:
                week = "الخميس";
                break;
            case 6:
                week = "الجمعة";
                break;
            case 7:
                week = "السبت";
                break;
        default:
            week = "";
            break;
        }
        return week;
    }
    
    func getArabicMonth() -> String {
        var month = ""
        switch (self) {
            case 0:
                month = "يناير";
                break;
            case 1:
                month = "فبراير";
                break;
            case 2:
                month = "مارس";
                break;
            case 3:
                month = "ابريل";
                break;
            case 4:
                month = "مايو";
                break;
            case 5:
                month = "يونيو";
                break;
            case 6:
                month = "يوليو";
                break;
            case 7:
                month = "اغسطس";
                break;
            case 8:
                month = "سبتمبر";
                break;
            case 9:
                month = "أكتوبر";
                break;
            case 10:
                month = "نوفمبر";
                break;
            case 11:
                month = "ديسمبر";
                break;
        default:
            month = "";
            break;
        }
        return month;
    }
}
