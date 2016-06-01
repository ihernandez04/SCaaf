//
//  ChooseUserViewController.swift
//  iConta
//
//  Created by Irvin Hernandez on 25/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import UIKit

protocol ChooseUserDelegate {
    func chreatChatroom(withUser: BackendlessUser)
}

class ChooseUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ChooseUserDelegate!
    var users: [BackendlessUser] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     LoadUsers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableviewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        
        
        return cell
        
        
    }
    
    // MARK: UITableviewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = users[indexPath.row]
        
        delegate.chreatChatroom(user)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: IBactions
    
    @IBAction func Cancelbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Load Backendless User
    
    func LoadUsers() {
        
        // Muestra usuarios por tipo de usuario: 0 = Consultor, 1 = Asesor
        let whereClause = "TipoUsuario = '1'"
        
        //Muestra solo un usuario específico
        /*
        let whereClause = "objectId = 'C41A00D2-461B-C1CB-FF69-49BEBCC3FE00'"
        */
        //Muestra 2 o mas usuarios específicos
        /*
        let whereClause =   "objectId in ('C41A00D2-461B-C1CB-FF69-49BEBCC3FE00','DA9FB372-670A-734D-FF18-885A50F42700')"
        */
        //Muestra todos los usuarios registrados
        /*
        let whereClause = "objectId != '\(currentUser.objectId)'"
        */
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: {( users: BackendlessCollection!) -> Void in
          
            self.users = users.data as! [BackendlessUser]
            self.tableView.reloadData()
            
            /*
            for user in users.data {
                let u = user as! BackendlessUser
                print(u.name)
                
            }*/
            
        }) { (fault : Fault!) -> Void in
            print("Error, No se pudo recuperar usuarios: \(fault)")
        
        
        
    }
        
    }

}











