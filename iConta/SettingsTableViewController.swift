//
//  SettingsTableViewController.swift
//  iConta
//
//  Created by Irvin Hernandez on 10/04/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var avatarSwitch: UISwitch!
    
    @IBOutlet weak var avatarCell: UITableViewCell!
    @IBOutlet weak var termsCell: UITableViewCell!
    @IBOutlet weak var privacyCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    
    var avatarSwitchStatus = true
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var firstLoad: Bool?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableHeaderView = HeaderView
        
        imageUser.layer.cornerRadius = imageUser.frame.size.width/2
        imageUser.layer.masksToBounds = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    
    
    @IBAction func didClickAvatarImage(sender: AnyObject) {
        
        changePhoto()
    }

    
    @IBAction func AvatarSwitchValueChaged(switchState: UISwitch) {
        if switchState.on {
            avatarSwitchStatus = true
            
        }   else {
            avatarSwitchStatus = false
            print("it off")
        }
        
        //save userdefaults
        
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { return 3 }
        if section == 1 { return 1 }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ((indexPath.section == 0) && (indexPath.row == 0)) { return privacyCell }
        if ((indexPath.section == 0) && (indexPath.row == 1)) { return termsCell   }
        if ((indexPath.section == 0) && (indexPath.row == 2)) { return avatarCell  }
        if ((indexPath.section == 1) && (indexPath.row == 0)) { return logOutCell  }
        
        return UITableViewCell()
    }
 
   override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if section == 0 {
        return 0
    } else {
        return 25.0
    }
        
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
        
    }
    
    //MARK: Change Photo
    
    func changePhoto() {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takephoto = UIAlertAction(title: "Tomar Foto", style: .Default) { (alert: UIAlertAction!) -> Void in
         //Take Photo
        }
        let sharePhoto = UIAlertAction(title: "Foto de librería", style: .Default) { (alert: UIAlertAction!) -> Void in
            //Choose Photo
        
    }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("Cancelar")
            
        }
        
        optionMenu.addAction(takephoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    
    }
 
    //MARK: UserDefaults
    
    func saveUserDefaults() {
        userDefaults.setBool(avatarSwitchStatus, forKey: kAVATARSTATE)
        userDefaults.synchronize()
        
        
        
    }
    
    func loadUserDefaults() {
        firstLoad = userDefaults.boolForKey(kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.setBool(true, forKey: kFIRSTRUN)
            userDefaults.setBool(avatarSwitchStatus, forKey: kAVATARSTATE)
            userDefaults.synchronize()
        }
        avatarSwitchStatus = userDefaults.boolForKey(kAVATARSTATE)
        
    }
    
    

}
