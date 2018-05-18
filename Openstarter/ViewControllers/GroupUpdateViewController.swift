//
//  GroupUpdateViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 4/29/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupUpdateViewController: UIViewController {

    let cs = ConnectionToServer()
    var json : JSON = []
    var colors: [UIColor] = [UIColor(hue: 0.5444, saturation: 0.8, brightness: 0.54, alpha: 1.0), UIColor(hue: 0.5667, saturation: 0.99, brightness: 0.72, alpha: 1.0),UIColor(hue: 0.5833, saturation: 0.25, brightness: 0.27, alpha: 1.0), UIColor(hue: 0.8583, saturation: 0.16, brightness: 0.5, alpha: 1.0)]
    
    let email = UserDefaults.standard.string(forKey: "userEmail")
    
    var oldName : String! 
    
    
    @IBOutlet weak var groupName: UITextField!
    
    @IBAction func updateGroup(_ sender: Any) {
        
        let updateParameters: [String: Any] = [
            "oldName" : oldName as Any,
            "newName" : groupName.text as Any,
            
            ]
        
        Alamofire.request(cs.url+"/collaborationGroup/updateName", method: .post, parameters: updateParameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["type"] == "success" {
                    print("updated")
                    self.dismiss(animated: true, completion: nil)
                    //self.performSegue(withIdentifier: "completeRegsiterToMenu", sender: nil)
                }
                print("JSON: \(json)")
                let message = "something went wrong"
                let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation(index: 0)
        
        print("passed string :"+oldName)
        
        groupName.text = oldName
        
        let getParameters: [String: Any] = [
            "email" : email as Any
        ]
        
        Alamofire.request(cs.url+"/collaborationGroup/getByUser", method: .post, parameters: getParameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for groupItem in self.json.arrayValue {
                    print("print : "+groupItem["name"].string!)
                    if groupItem["name"].string == self.oldName{
                        
                        
                        self.groupName.text = json["name"].string!
                        
                        
                    }
                    else if json["type"] == "group not found" {
                        print("User not found")
                        let message = "there's a problem"
                        let alert = UIAlertController(title: "User not found", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
                
                
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
