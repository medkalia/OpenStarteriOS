//
//  LoginViewController.swift
//  LoginScreen
//
//  Created by Florian Marcu on 1/15/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import FacebookCore
import FacebookLogin
import TwitterKit
import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {


    let cs = ConnectionToServer()
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    // Facebook login permissions
    // Add extra permissions you need
    // Remove permissions you don't need
    
    var colors: [UIColor] = [UIColor(hue: 0.5444, saturation: 0.8, brightness: 0.54, alpha: 1.0), UIColor(hue: 0.5667, saturation: 0.99, brightness: 0.72, alpha: 1.0),UIColor(hue: 0.5833, saturation: 0.25, brightness: 0.27, alpha: 1.0), UIColor(hue: 0.8583, saturation: 0.16, brightness: 0.5, alpha: 1.0)]
    
    
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation(index: 0)
        usernameTextField.text = "mohamed.kalia@esprit.tn"
        passwordTextField.text = "1234"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func startAnimation(index: Int) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.view.backgroundColor = self.colors[index]
        }) { (finished) in
            var currentIndex = index + 1
            if currentIndex == self.colors.count { currentIndex = 0 }
            self.startAnimation(index: currentIndex)
        }
    }

    @IBAction func didTapLoginButton(_ sender: LoginButton) {
        // Regular login attempt. Add the code to handle the login by email and password.
        guard let email = usernameTextField.text, let pass = passwordTextField.text else {
            // It should never get here
            return
        }
        
        let parameters: [String: Any] = [
            "email" : usernameTextField.text as Any,
            "password" : passwordTextField.text as Any
        ]
        didLogin(method: "email and password", info: parameters)
    }

    @IBAction func didTapFacebookLoginButton(_ sender: FacebookLoginButton) {
        // Facebook login attempt
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }

    @IBAction func didTapGoogleLoginButton(_ sender: GoogleLoginButton) {
        // Twitter login attempt
        /*TWTRTwitter.sharedInstance().logIn(completion: { session, error in
            if let session = session {
                // Successful log in with Twitter
                print("signed in as \(session.userName)");
                let info = "Username: \(session.userName) \n User ID: \(session.userID)"
                self.didLogin(method: "Twitter", info: info)
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })*/
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            //didLoginWithFacebook()
            print("fb")
        case .failed(_): break
        default: break
        }
    }

    /*private func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let _ = facebookUser.email {
                    //let info = "First name: \(facebookUser.firstName!) \n Last name: \(facebookUser.lastName!) \n Email: \(facebookUser.email!)"
                    let parameters: [String: Any] = [
                        "email" : usernameTextField.text as Any,
                        "password" : passwordTextField.text as Any
                    ]
                    self.didLogin(method: "Facebook", info: parameters)
                }
            })
        }
    }*/

    private func didLogin(method: String, info: [String: Any]) {
        /*let message = "Successfully logged in with \(method). " + info
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)*/
        
       // let storyboard = UIStoryboard(name: "Home", bundle: nil)
        //let MainVC = storyboard.instantiateViewController(withIdentifier: "MainTableViewController")
        //self.present(MainVC, animated: true, completion: nil)
        
        
        /*Alamofire.request(cs.url+"/project/getAll", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }*/
        
        //let jsonLogin = JSON()
        
        
        
        Alamofire.request(cs.url+"/user/login", method: .post, parameters: info, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["loggedIn"] == "true" {
                    print("logged in")
                    UserDefaults.standard.set(self.usernameTextField.text, forKey: "userEmail")
                    self.performSegue(withIdentifier: "toMenu", sender: nil)
                } else if json["loggedIn"] == "false" {
                    print("not loggedin")
                    let message = "wrong password "
                    let alert = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("JSON: \(json)")
                let message = "wrong email "
                let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
        //fetchProjects(url: cs.url+"/user/getAll")
    }
    
    
    
    /*func fetchProjects(url:String){
        Alamofire.request(url).validate().responseJSON(completionHandler:{response in
            switch response.result{
            case .success:
                print("validation succesful")
                print(response.result.value!)
//                self.moviesArray = response.result.value! as! NSArray
//                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        } )
        
    }*/
}
