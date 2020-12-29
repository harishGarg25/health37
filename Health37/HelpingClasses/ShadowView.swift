//
//  ShadowView.swift
//  Health37
//
//  Created by Deepak iOS on 07/04/17.
//  Copyright © 2017 Deepak. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var cornerRad: CGFloat = 0.0
    @IBInspectable var borderCol: UIColor = UIColor.black
    @IBInspectable var borderWid: CGFloat = 0.5
    private var customBackgroundColor = UIColor.white
    override var backgroundColor: UIColor?{
        didSet {
            customBackgroundColor = backgroundColor!
            super.backgroundColor = UIColor.clear
        }
    }
    
    func setup() {
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5.0;
        layer.shadowOpacity = 0.5;
        super.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func draw(_ rect: CGRect) {
        customBackgroundColor.setFill()
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRad).fill()
        
        let borderRect = bounds.insetBy(dx: borderWid/2, dy: borderWid/2)
        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRad - borderWid/2)
        borderCol.setStroke()
        borderPath.lineWidth = borderWid
        borderPath.stroke()
        
        // whatever else you need drawn
    }
}


