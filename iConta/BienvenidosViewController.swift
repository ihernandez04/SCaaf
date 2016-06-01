//
//  BienvenidosViewController.swift
//  
//
//  Created by Irvin Hernandez on 24/03/16.
//
//

import UIKit

class BienvenidosViewController: UIViewController {
    
    
    @IBOutlet weak var CorreoTextfield: UITextField!
    
    @IBOutlet weak var Passtextfield: UITextField!
    
    let backendless = Backendless.sharedInstance()
    
    var email: String?
    var password: String?
    
    var currentUser: BackendlessUser?

    
    override func viewDidAppear(animated: Bool) {
        backendless.userService.setStayLoggedIn(true)
        
        currentUser = backendless.userService.currentUser
        
        if currentUser != nil {
            
            dispatch_async(dispatch_get_main_queue()) {
                
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            VC.selectedIndex = 0
            
            self.presentViewController(VC, animated: true, completion: nil)
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: IBActions
    
    @IBAction func Loginbutton(sender: UIButton) {
        if CorreoTextfield.text != "" && Passtextfield.text != "" {
            self.email = CorreoTextfield.text
            self.password = Passtextfield.text
            
            //Login User
            loginUser(email! , password: password!)
            
            
        } else {
            //Muestra un error al usuario
            ProgressHUD.showError("Completar Todos los Campos")
        }
        
    }
    
    func loginUser(email: String, password: String){
        backendless.userService.login(email, password: password, response: {(user : BackendlessUser!) -> Void in
            
            self.CorreoTextfield.text = ""
            self.Passtextfield.text = ""
            
            //Segue to recents View
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatVC") as! UITabBarController
            
            VC.selectedIndex = 0
            
            self.presentViewController(VC, animated: true, completion: nil)
            
            
        }) {(fault : Fault!) -> Void in
                print("Usuario no puede entrar \(fault)")}
        
    }

}
