//
//  RegistroViewController.swift
//  iConta
//
//  Created by Irvin Hernandez on 24/03/16.
//  Copyright © 2016 Irvin Hernandez. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var Usertextfield: UITextField!
    
    
    @IBOutlet weak var emailtextfield: UITextField!
    
    @IBOutlet weak var passtextfield: UITextField!
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var username: String?
    var email: String?
    var password: String?
    var avatarImage: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        newUser = BackendlessUser()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 //MARK: IBActions
    
    @IBAction func Registerbutton(sender: UIButton) {
        if emailtextfield.text != "" && Usertextfield.text != "" && passtextfield.text != "" {
            
            ProgressHUD.show("Registrando...")
            
            username = Usertextfield.text
            email = emailtextfield.text
            password = passtextfield.text
            
            register(self.username!, email: self.email!, password: self.password!, avatarImage: self.avatarImage)
            
        } else {
            // Advertencia al Usuario
            ProgressHUD.showError("Completar Todos los Campos")
            
        }
        
        
    }
    
   //MARK: Backendless User Registration 
    func register(username: String, email: String, password: String, avatarImage: UIImage?){
        if avatarImage == nil {
            newUser!.setProperty("Avatar", object: "")
        }
        
      newUser!.name = username
      newUser!.email = email
      newUser!.password = password
        
    
        
    backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) -> Void in
        
        ProgressHUD.dismiss()
        
        //Login new User
        self.loginUser(username, email: email, password: password)
        
        self.Usertextfield.text = ""
        self.passtextfield.text = ""
        self.emailtextfield.text = ""
        
        
        
        }) { (fault : Fault!) -> Void in
            print("El Servidor reporta un error, no pudo registrar el nuevo usuario: \(fault)")
            
        }
        
    }
    
    func loginUser(username: String, email: String, password: String){
    backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
        
        //Here Segue a Recents VC
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
        VC.selectedIndex = 0
        
        self.presentViewController(VC, animated: true, completion: nil)
        
      
    }) {(fault : Fault!) -> Void in
         print("El Servidor reporta un error: \(fault)")
        
        }
        
    }
    

}
