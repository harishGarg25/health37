//
//  Extensions.swift
//  WLAppleCalendar
//
//  Created by willard on 2017/9/16.
//  Copyright © 2017年 willard. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

extension Array {
    func randomValue() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if categories[key] == nil {
                categories[key] = [element]
            }
            else {
                categories[key]?.append(element)
            }
        }
        
        return categories
    }
}

extension Date {
    func isThisMonth() -> Bool {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyy MM"
        
        let dateString = monthFormatter.string(from: self)
        let currentDateString = monthFormatter.string(from: Date())
        return dateString == currentDateString
    }
}

extension UIButton
{
    func disableButton()  {
        self.alpha = 0.6
        self.isUserInteractionEnabled = false
    }
    
    func enableButton()  {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
    }
    
    func setAccessibilityLabel(label : String)  {
        self.accessibilityLabel = label
    }
}



extension NSDictionary
{
    func valueForNullableKey(key : String) -> String
    {
        if self.value(forKey: key) == nil
        {
            return ""
        }
        if self.value(forKey: key) is NSNull
        {
            return ""
        }
        if self.value(forKey: key) is NSNumber
        {
            return String(describing: self.value(forKey: key) as! NSNumber)
        }
        else
        {
            return self.value(forKey: key) as! String
        }
    }
    
    
}

extension String
{
    func height() -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 80, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = UIFont.init(name: "Lato-Regular", size: 17)!
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label.frame.height
    }
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
          let disallowedCharacterSet =  CharacterSet(charactersIn:matchCharacters).inverted
          return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
      }
    
    func convertToStringDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            dateFormatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }
        else
        {
            dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "hh:mm a"
        if date != nil
        {
            return dateFormatter.string(from: date!)
        }
        return self
    }
    
    func convertToUnixTimestamp() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let date = dateFormatter.date(from: self)
        if date != nil
        {
            let myTimeStamp = date!.timeIntervalSince1970
            debugPrint(Int(myTimeStamp))
            return "\(Int(myTimeStamp))"
        }
        return self
    }
    
    func convertUnixToDate() -> String? {
        if let timeResult = (self as? Double) {
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
        return self
    }
    
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decode() -> String {
        let data = self.data(using: .utf8)!
        let string =  String(data: data, encoding: .nonLossyASCII) ?? ""
        if string.count > 0
        {
            return string
        }
        else
        {
            let trimmedStr = self.replacingOccurrences(of: "\\s", with: " ", options: .regularExpression)
            let wI = NSMutableString(string: trimmedStr)
            CFStringTransform(wI , nil, "Any-Hex/Java" as NSString, true )
            let decoded = wI as String
            return decoded.removeMultipleNewlinesFromMiddle()
        }
    }
    
    func removeMultipleNewlinesFromMiddle() -> String {
        let returnString = self.replacingOccurrences(of: "\\n", with: "\n", options: .literal, range: nil)
        let String = returnString.replacingOccurrences(of: "\\t", with: " ", options: .literal, range: nil)
        let Stringr = String.replacingOccurrences(of: "\\r", with: " ", options: .literal, range: nil)
        let Stringe = Stringr.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        let Stringf = Stringe.replacingOccurrences(of: "\\", with: " ", options: .literal, range: nil)
        return Stringf
    }
    
    var localized: String
    {
        if  UserDefaults.standard.string(forKey: "applanguage") == nil
        {
            //let preferredLanguage = NSLocale.preferredLanguages[0] as String
            let langCode = Locale.current.languageCode
            //print(preferredLanguage)
            UserDefaults.standard.set(langCode, forKey: "applanguage")
            UserDefaults.standard.synchronize()
        }
        
        let lang = UserDefaults.standard.string(forKey: "applanguage")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
    
    func GetutfString() -> String {
        return String(cString:self.cString(using: String.Encoding.isoLatin1)!, encoding: String.Encoding.utf8)!
    }
    
    func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }
}

extension UIApplication
{
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension URL {
    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        if let parameters = url.queryItems {
            return parameters.first(where: { $0.name == queryParam })?.value
        } else if let paramPairs = url.fragment?.components(separatedBy: "?").last?.components(separatedBy: "&") {
            for pair in paramPairs where pair.contains(queryParam) {
                return pair.components(separatedBy: "=").last
            }
            return nil
        } else {
            return nil
        }
    }
}


extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
