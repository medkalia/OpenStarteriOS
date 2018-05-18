//
//  MemberListViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 4/29/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MemberListViewController: UITableViewController{

    let cs = ConnectionToServer()
    var membersArray:NSArray = []
    var json : JSON = []
    
    var oldName : String!
    
    @IBOutlet var memberList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(oldName)
        //fetchMembers(url:cs.url+"")
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return membersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let parameters:Parameters=[
            "groupName" : oldName
        ]
        
        Alamofire.request(self.cs.url+"/membership/getByGroupName", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                
                print("test")
                
                if self.json[0]["id"] != JSON.null {
                    print("members :")
                    //print(self.json)
                    self.membersArray = self.json.arrayValue as NSArray
                    print(self.membersArray)
                    
                } else {
                    print("JSON: \(self.json)")
                    let message = "no group"
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell")
        let fullName = cell?.viewWithTag(101) as? UILabel
        let memberEmail = cell?.viewWithTag(100) as? UILabel
        let member = membersArray[indexPath.row] as! Dictionary<String,String>
        
        fullName?.text = member["firstName"]!+" "+member["lastName"]!
        memberEmail?.text = member["email"]
        print("email :", member["email"])
        
        return cell!
    }
    
    

}
