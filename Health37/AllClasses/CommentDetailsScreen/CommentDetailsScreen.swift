//
//  CommentDetailsScreen.swift
//  Health37
//
//  Created by Ramprasad on 14/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CommentDetailsScreen: UIViewController, UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var tblUserDetails: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationBarWithBackButton(strTitle: "Acer", leftbuttonImageName: "back-white")
    }

    
    @IBAction override func methodBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 385
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier : String = "AllPostTblCell"
        var cell: AllPostTblCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? AllPostTblCell
        if (cell == nil)
        {
            let nib: Array = Bundle.main.loadNibNamed("AllPostTblCell", owner: nil, options: nil)!
            cell = nib[0] as? AllPostTblCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = UIColor.clear
        }
        cell?.btnDelete.isHidden = true
        cell?.btnHide.isHidden = true

        // Required float rating view params
        cell?.viewRating.emptyImage = UIImage(named: "greystar.png")
        cell?.viewRating.fullImage = UIImage(named: "starBig.png")
        // Optional params
        cell?.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        cell?.viewRating.maxRating = 5
        cell?.viewRating.minRating = 3
        cell?.viewRating.editable = true
      //  cell?.viewRating.halfRatings = true
      //  cell?.viewRating.floatRatings = false

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }


}
