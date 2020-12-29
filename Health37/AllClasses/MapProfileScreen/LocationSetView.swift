//
//  LocationSetView.swift
//  Health37
//
//  Created by Ramprasad on 25/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class LocationSetView: UIViewController {

    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblHeaderTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 4
        self.view.clipsToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - MethodButtons
    @IBAction func methodSaveRemove(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            
        }
        else
        {
            
        }
        self.navigationController?.popViewController(animated: true)
    }



}
