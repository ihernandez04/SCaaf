//
//  RecentTableViewCell.swift
//  iConta
//
//  Created by Irvin Hernandez on 25/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    
    
    let backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var lastmessagelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var avatarimageview: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(recent: NSDictionary) {
        avatarimageview.layer.cornerRadius = avatarimageview.frame.size.width/2
        avatarimageview.layer.masksToBounds = true
        
        self.avatarimageview.image = UIImage(named: "Icon")
        
        let withUserId = (recent.objectForKey("withUserUserId") as? String)!
        
        // get the backenless user and download avatar
        
        let whereClaus = "objectId = '\(withUserId)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClaus
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        
        dataStore.find(dataQuery, response: { ( users : BackendlessCollection!) -> Void in
            let withUser = users.data.first as! BackendlessUser
            
            //User withUser to get our avatar
            
        }) { (fault: Fault!) -> Void in
            print("Error, no se pudo obtener imagen: \(fault)")
        
        }
        
        namelabel.text = recent["withUserUsername"] as? String
        lastmessagelabel.text = recent["lastMessage"] as? String
        countlabel.text = ""
        
        if (recent["counter"] as? Int)! != 0 {
            countlabel.text = "\(recent["counter"]!) Nuevo"
        }
        
        let date = dateFormatter().dateFromString((recent["date"] as? String)!)
        let seconds = NSDate().timeIntervalSinceDate(date!)
        
        datelabel.text = TimeElapsed(seconds)
        
        
    }
    
    func TimeElapsed(seconds: NSTimeInterval) -> String {
        let elapsed: String?
        
        if (seconds < 60) {
            elapsed = "Justo ahora"
        } else if (seconds < 60 * 60) {
            let minutes = Int(seconds / 60)
            
            var minText = "minuto"
            if minutes > 1 {
                minText = "minutos"
            }
            elapsed = "\(minutes) \(minText)"
            
            
        } else if (seconds < 24 * 60 * 60) {
            let hours = Int(seconds / (60 * 60))
            var hourText = "hora"
            if hours > 1 {
                hourText = "horas"
                
            }
            elapsed = "\(hours) \(hourText)"
            
        } else {
            let days = Int(seconds / (24 * 60 * 60))
            var dayText = "día"
            if days > 1 {
                dayText = "días"
            }
            elapsed = "\(days) \(dayText)"
        }
        return elapsed!
        
    }
    
    

    
}













