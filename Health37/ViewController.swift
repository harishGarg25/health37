//
//  ViewController.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let array = [1,5,3,7,9]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...10 {
            debugPrint(i)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

