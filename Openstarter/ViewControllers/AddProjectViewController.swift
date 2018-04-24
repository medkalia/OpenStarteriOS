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


class AddProjectViewController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var nameProject: LoginTextField!
    
    @IBOutlet weak var budhget: UITextField!
   
    @IBOutlet weak var desc: LoginTextField!
    @IBOutlet weak var shortDesc: LoginTextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var finishDate: UITextField!
    
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var pickerGroups: UIPickerView!
   
    @IBOutlet weak var pickerCategorie: UIPickerView!
    var dataCategorie: [String] = [String]()
    var dataGroup = [String]()
    let cs = ConnectionToServer()
    var groupArray: [[String : AnyObject]] = [[String : AnyObject]]()
    
    var category : String = ""
    
    
    override func viewDidLoad() {
        pickerGroups.dataSource=self
        pickerGroups.delegate=self
        pickerCategorie.dataSource=self
        pickerCategorie.delegate=self
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
         fetchGroups()
         dataCategorie = ["Sport", "Art", "Health"]
        
      
     
        createDatePicker()
        createDatePickerTwo()
        print(self.groupArray.count)
        
    }
    
    @IBAction func addProject(_ sender: Any) {
        
        let parameters: [String: Any] = [
            "email" :  "mohamed.kalia@esprit.tn",
            "name" : nameProject.text! as String,
            "startDate" : startDate.text! as String,
            "finishDate" : finishDate.text! as String,
            "description" : desc.text! as String,
            "shortDescription" : shortDesc.text! as String,
            "budget" : budhget.text! as String,
            "category" : category,
            "collaborationGroup" : ""
            
        ]
        
        print(parameters)
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
        let parameters: [String: Any] = [
            "email" :  "mohamed.kalia@esprit.tn"
            
        ]
        Alamofire.request(cs.url+"/collaborationGroup/getByAdminUser", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler:{response in
            switch response.result{
            case .success:
                print("validation succesful")
                print(response.result.value!)
                self.groupArray = (response.result.value! as! [[String : AnyObject]] )
                print(self.groupArray.count)
                print(self.groupArray[0]["name"]!)
                print("heeyyyyy")
                for station in self.groupArray{
                    self.dataGroup = [station["name"]  as! String]
                }
                print(self.dataGroup,self.dataGroup.count)
               
            case .failure(let error):
                print("leeeeeee")
                print(error)
            }
            
        } )
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var nbr : Int = dataGroup.count
        print( "aaa",groupArray.count)
        if(pickerView == pickerCategorie){
            nbr = dataCategorie.count
        }
        
        return nbr
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerGroups){
           
          let titleRow = dataGroup[row]
           print("mamamamamamamamamaaaa"+titleRow)
            
        }
        else if (pickerView == pickerCategorie){
           
            let titleRow = dataCategorie[row]
            return titleRow
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView == pickerGroups){
             //print(dataGroup[row])
        }
        else if (pickerView == pickerCategorie){
           print(dataCategorie[row])
            category = dataCategorie[row]
        }
        
    }
    
    
   
    
 
    

}


