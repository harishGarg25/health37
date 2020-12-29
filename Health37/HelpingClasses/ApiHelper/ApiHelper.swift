//
//  ApiHelper.swift
//  Health37
//
//  Created by Deepak iOS on 09/03/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


func getallApiResultwithGetMethod(strMethodname : String,Details: NSDictionary, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    
    let url = Base_URL + strMethodname
    
    print("CheckUrl: ",url)
    print("CheckParameters: ",Details)
    
    Alamofire.request(url, method: .get, parameters: Details as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
        
        DispatchQueue.main.async {
            completionHandler(response.result.value as? NSDictionary ?? [:] , response.result.error as NSError?)
        }
        
        #if DEBUG
        //print("signUpResponse Debug Data: \(String(describing: response.result.value))")
        #endif
    }
}
func getAllApiResults(Details: NSDictionary,srtMethod : String, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    
    let url = Base_URL + srtMethod
    print("getAllApiResults: ",url)
    print("getAllApiResults: ",Details)
    
    Alamofire.request(url, method: .post, parameters: Details as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
        DispatchQueue.main.async {
            completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
        }
        
        #if DEBUG
        //print("signUpResponse Debug Data: \(String(describing: response.result.value))")
        #endif
    }
}


func getallApiResultwithimagePostMethod(strMethodname : String, imgData : Data, strImgKey : String, Details: NSDictionary, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    
    let url = Base_URL + strMethodname
    
    print("CheckUrl: ",url)
    print("CheckParameters: ",Details)
    
    Alamofire.upload(multipartFormData:
        { multipartFormData in
            if imgData.count > 0
            {
                multipartFormData.append((imgData), withName: strImgKey, fileName: "file.jpg", mimeType: "image/jpg")
                print("strImgKey: && imgData: ",url, imgData)
            }
            for (key, val) in Details {
                multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
    },to: url,method:.post,headers:nil, encodingCompletion:
        { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    DispatchQueue.main.async {
                        completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
    }
    )
}


