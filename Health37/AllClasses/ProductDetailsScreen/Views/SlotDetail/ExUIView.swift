//
//  ExUIView.swift
//  Appt
//
//  Created by user on 03/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import UIKit
extension UIView{
    
    @IBInspectable var cornerRadius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor{
        get{
            UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set{
            layer.borderColor = newValue.cgColor
        }
    }
    
}
