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
    
    
    @IBAction func tappedStringPickerButton(_ sender: UIButton) {
        /// Replace a string with the string to be display.
        
        //let numberWords = ["one", "two", "three"]
        
        
        
        
        let displayStringFor:((String?)->String?)? = { string in
            if let s = string {
                switch(s){
                case "value 1":
                    return "😊"
                case "value 2":
                    return "😏"
                case "value 3":
                    return "😓"
                default:
                    return s
                }
            }
            return nil
        }
        
        /// Create StringPickerPopover:
        let p = StringPickerPopover(title: "StringPicker", choices: ["value 1","value 2","value 3"])
            .setDisplayStringFor(displayStringFor)
            .setFont(UIFont.boldSystemFont(ofSize: 14))
            .setFontColor(.blue)
            .setDoneButton(
                action: {  popover, selectedRow, selectedString in
                    print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
        
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
            })
            .appear(originView: sender, baseViewController: self)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}

