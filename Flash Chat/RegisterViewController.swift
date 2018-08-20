//
//  RegisterViewController.swift
//  Let's Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        // Firebase authentication
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("Registraion Successful!")
                SVProgressHUD.dismiss()
                // call method inside a closure
                // closure is only called once the user registration has been completed
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
    } 
    
    
}
