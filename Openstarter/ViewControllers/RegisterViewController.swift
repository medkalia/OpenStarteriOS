//
//  RegisterViewController.swift
//  Openstarter
//
//  Created by tarek on 26/03/2018.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    var colors: [UIColor] = [UIColor(hue: 0.5444, saturation: 0.8, brightness: 0.54, alpha: 1.0), UIColor(hue: 0.5667, saturation: 0.99, brightness: 0.72, alpha: 1.0),UIColor(hue: 0.5833, saturation: 0.25, brightness: 0.27, alpha: 1.0), UIColor(hue: 0.8583, saturation: 0.16, brightness: 0.5, alpha: 1.0)]

    let cs = ConnectionToServer()
    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    @IBOutlet weak var confirmPassword: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation(index: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func signup(_ sender: Any) {
        if (password.text == confirmPassword.text){
            
            let parameters: [String: Any] = [
                "email" : email.text as Any,
                "password" : password.text as Any
            ]
            
            Alamofire.request(cs.url+"/user/create", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["resp"] == "didSignUp" {
                        print("user created")
                        UserDefaults.standard.set(self.email.text, forKey: "userEmail") // userDefaults
                        self.performSegue(withIdentifier: "toCompleteRegister", sender: nil)
                    } else if json["resp"] == "existentUser" {
                        print("existent User")
                        let message = "existent User"
                        let alert = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print(error)
                    let message = "something went wrong or cannot reach server"
                    let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                }
            }
            
        }else{
            print("password not matching")
            
            let message = "password not matching "
            let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert2, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
