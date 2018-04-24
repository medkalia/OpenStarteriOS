//
//  AddProjectViewController.swift
//  Openstarter
//
//  Created by tarek on 03/04/2018.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyPickerPopover


class AddProjectViewController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var json : JSON = []
    var groupId : String = ""
    @IBOutlet weak var nameProject: LoginTextField!
    
    @IBOutlet weak var budhget: UITextField!
    
    @IBOutlet weak var desc: LoginTextField!
    @IBOutlet weak var shortDesc: LoginTextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var finishDate: UITextField!
    @IBOutlet weak var selectedGroup: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet weak var pickerCategorie: UIPickerView!
    var dataCategorie: [String] = [String]()
    
    let cs = ConnectionToServer()
   
     let email = UserDefaults.standard.string(forKey: "userEmail")
    var category : String = ""
    
    
    override func viewDidLoad() {
        
        pickerCategorie.dataSource=self
        pickerCategorie.delegate=self
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        fetchGroups()
        dataCategorie = ["Sport", "Art", "Health"]
        
        
        
        createDatePicker()
        createDatePickerTwo()
       
        
    }
    
    @IBAction func didTapStringPickerWithTextField(_ sender: UITextField) {
        var names : [String] = []
        for groupName in json.arrayValue {
            names.append(groupName["name"].string!)
            print(groupName["id"])
            print(groupName["name"])
        }
        
        StringPickerPopover(title: "Groups", choices: names)
            .setDoneButton(action: { popover, selectedRow, selectedString in
                //sender.text = selectedString
                self.selectedGroup.text = selectedString
                
                for groupItem in self.json.arrayValue {
                    if groupItem["name"].string == selectedString {
                       // self.groupId = groupItem["id"].string!
                       
                        self.groupId = groupItem["id"].stringValue
                        print("intern",self.groupId)
                    }
                    
                }
                
                //self.groupId = selectedString
            })
            .appear(originView: sender, baseViewController: self)
        
    }
    
    @IBAction func addProject(_ sender: Any) {
        
        let parameters: [String: Any] = [
           
            "name" : nameProject.text! as String,
            "startDate" : "2018/01/13 08:59:06",
            "finishDate" : "2019/01/13 08:59:06",
            "description" : desc.text! as String,
            "shortDescription" : shortDesc.text! as String,
            "budget" : budhget.text! as String,
            "id_category" : "1",
            "id_group" : self.groupId,
            "servicesList" : "",
            "equipementsList" : ""
            
        ]
        
        print(parameters)
        
        Alamofire.request(cs.url+"/project/create", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
        
    }
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(getDateStart))
        toolbar.setItems([doneButton], animated: false)
        startDate.inputAccessoryView = toolbar
        startDate.inputView = datePicker
        
    }
    func createDatePickerTwo(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(getDateFinish))
        toolbar.setItems([doneButton], animated: false)
        
        finishDate.inputAccessoryView = toolbar
        finishDate.inputView = datePicker
    }
    
    @objc func getDateStart(){
        startDate.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    @objc func getDateFinish(){
        finishDate.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    
    func fetchGroups(){
        let getParameters: [String: Any] = [
            "email" :  self.email!
            
        ]
        Alamofire.request(cs.url+"/collaborationGroup/getByUser", method: .post, parameters: getParameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
      return dataCategorie.count
        }
        
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     if (pickerView == pickerCategorie){
            
            let titleRow = dataCategorie[row]
            return titleRow
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView == pickerCategorie){
            print(dataCategorie[row])
            category = dataCategorie[row]
        }
        
    }
    
    
    
    
    
    
    
}


