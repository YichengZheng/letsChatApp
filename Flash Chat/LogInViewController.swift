//
//  LogInViewController.swift
//  Let's Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn
import FBSDKCoreKit
import FacebookLogin
import FBSDKLoginKit

class LogInViewController: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButtons()
        setupFBButtons()
        
//        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
//            print("signed in")
//            self.performSegue(withIdentifier: "goToChat", sender: self)
//        }
    }
    
    fileprivate func setupFBButtons(){
//        let fbButton = LoginButton(readPermissions: [ .publicProfile ])
//        view.addSubview(fbButton)
//        fbButton.frame = CGRect(x: 16, y: 116 + 150 + 56, width: view.frame.width - 32, height: 40)
        let lb = LoginButton(readPermissions: [ .email, .publicProfile ])
        lb.frame = CGRect(x: 16, y: 116 + 150 + 56, width: view.frame.width - 32, height: 40)
        lb.delegate = self
        view.addSubview(lb)
        lb.delegate = self
        
    }
    
    fileprivate func setupGoogleButtons(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 150, width: view.frame.width - 32, height: 40)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print("Error \(error)")
            break
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            loginFireBase()
            showEmailAddress()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatVC")
            present(vc, animated: true, completion: nil)
            
            break
        default: break
            
        }
    }
    
    // show email address of associated FB account
    func showEmailAddress(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{
            (connection, result, err) in
            if err != nil{
                print("failed to start graph request")
                return
            }
            print(result)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("log out")
    }
    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil{
//            print(error)
//            return
//        }
//        self.performSegue(withIdentifier: "goToChat", sender: self)
//        print("Successfully logging into FB")
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("log out")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Login to Firebase after FB Login is successful
     */
    func loginFireBase() {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential, completion:  { (user, error) in
            // ...
            if let error = error {
                print("Unable to sign in Facebook")
                // ...
                return
            }
        })
    }
    
    // regular email log in
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("Log in successful")
                
                SVProgressHUD.dismiss()
//                self.performSegue(withIdentifier: "goToChat", sender: self)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"chatVC")
                let navController = UINavigationController.init(rootViewController: viewController)
                self.present(navController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    
    
}  
