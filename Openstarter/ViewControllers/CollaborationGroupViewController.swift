//
//  CollaborationGroupViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 4/20/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyPickerPopover

class CollaborationGroupViewController: UIViewController {
    var json : JSON = []
    public typealias PopoverType = StringPickerPopover
    public var popover: PopoverType?

    let cs = ConnectionToServer()
    let email = UserDefaults.standard.string(forKey: "userEmail")
    @IBOutlet weak var members: UILabel!
    @IBOutlet weak var projects: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var selectedGroup: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getParameters: [String: Any] = [
            "email" : email as Any,
            ]
        
        
        Alamofire.request(cs.url+"/collaborationGroup/getByUser", method: .post, parameters: getParameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                
                if self.json[0]["id"] != JSON.null {
                    self.name.text = self.json[0]["name"].string
                    self.selectedGroup.text = self.json[0]["name"].string
                    self.projects.text = self.json[0]["projectsCount"].string
                    self.members.text = self.json[0]["countMembers"].string
                    self.creationDate.text = self.json[0]["creationDate"].string
                    
                } else {
                    print("JSON: \(self.json)")
                    let message = "this use has no groups"
                    let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert2.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func didTapStringPickerWithTextField(_ sender: UITextField) {
        var names : [String] = []
        for groupName in json.arrayValue {
            names.append(groupName["name"].string!)
            print(groupName["name"])
        }
        
        StringPickerPopover(title: "Groups", choices: names)
            .setDoneButton(action: { popover, selectedRow, selectedString in
                //sender.text = selectedString
                self.selectedGroup.text = selectedString
                
                for groupItem in self.json.arrayValue {
                    if groupItem["name"].string == selectedString {
                        // self.groupId = groupItem["id"].string!
                        
                        self.name.text = groupItem["name"].stringValue
                        self.members.text = groupItem["countMembers"].stringValue
                        self.projects.text = groupItem["projectsCount"].stringValue
                        self.creationDate.text = groupItem["creationDate"].stringValue
                        
                        //print("intern",self.groupId)
                    }
                    
                }
                
            })
            .appear(originView: sender, baseViewController: self)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdateGroup" {
            if let destinationVC = segue.destination as? GroupUpdateViewController {
                destinationVC.oldName = self.selectedGroup.text
            }
        } else if segue.identifier == "toMembers" {
            if let destinationVC = segue.destination as? MemberListViewController {
                destinationVC.oldName = self.selectedGroup.text
            }
        }
    }
    
    @IBAction func editGroup(_ sender: Any) {
        performSegue(withIdentifier: "toUpdateGroup", sender: UIButton.self)
    }
    

    
    @IBAction func members(_ sender: Any) {
        performSegue(withIdentifier: "toMembers", sender: UIButton.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addGroup(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add a new group", message: "", preferredStyle: .alert)
        
        
        
        //2. Add the text field. You can configure it however you need.
        
        alert.addTextField { (textField) in
            
            textField.text = ""
            
        }
        
        
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        
        
        
        alert.addAction(UIAlertAction(title: "Add group", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            //print("Text field: \(textField?.text)")
            
            //EZLoadingActivity.show("Sending ...", disableUI: false)
            
            let parameters:Parameters=[
                "name" : textField?.text,
                "creatorEmail": self.email
            ]
            
            Alamofire.request(self.cs.url+"/collaborationGroup/new", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.json = JSON(value)
                    
                    if self.json["type"] == "success" {
                        print("group addded")
                        
                    } else {
                        print("JSON: \(self.json)")
                        let message = "this use has no groups"
                        let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert2, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print(error)
                    let message = "cannot reach server "
                    let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert2.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                }
            }
            
            
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        
        
        // 4. Present the alert.
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

