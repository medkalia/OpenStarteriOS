//
//  UserProfileViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 3/29/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileViewController: UIViewController {

    let cs = ConnectionToServer()
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var contributions: UILabel!
    @IBOutlet weak var collaborations: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var medal: UIImageView!
    
    
    let email = UserDefaults.standard.string(forKey: "userEmail")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //data load
        
        let parameters: [String: Any] = [
            "email" : email as Any
        ]
        
        Alamofire.request(cs.url+"/user/getProjectsCount", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["id"] != nil {
                    print(value)
                    
                    self.fullName.text = json["firstName"].string!+" "+json["lastName"].string!
                    //var x = json["contributions"]
                    //var y = json["projectsCount"]
                    self.contributions.text = "\(json["contributions"])"
                    self.collaborations.text = "\(json["projectsCount"])"
                    self.birthdate.text = json["birthDate"].string!
                    self.bio.text = json["bio"].string!
                    
                    
                    if json["contributions"].int! == 0 {
                        
                        self.medal.image = UIImage(named: "bronze")
                        
                    } else if json["contributions"].int! == 1 {
                        
                        self.medal.image = UIImage(named: "silver")
                        
                    } else if json["contributions"].int! >= 2 {
                        
                        self.medal.image = UIImage(named: "gold")
                    
                    }
                    
                    
                    
                    print(json["firstName"].string!)

                    
                    //self.performSegue(withIdentifier: "toMenu", sender: nil)
                } else if json["type"] == "User not found" {
                    print("User not found")
                    let message = "wrong password "
                    let alert = UIAlertController(title: "User not found", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
