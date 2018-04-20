//
//  CompleteRegisterViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 3/29/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import DateTimePicker
import Alamofire
import SwiftyJSON

class CompleteRegisterViewController: UIViewController {
    
    let cs = ConnectionToServer()
    var colors: [UIColor] = [UIColor(hue: 0.5444, saturation: 0.8, brightness: 0.54, alpha: 1.0), UIColor(hue: 0.5667, saturation: 0.99, brightness: 0.72, alpha: 1.0),UIColor(hue: 0.5833, saturation: 0.25, brightness: 0.27, alpha: 1.0), UIColor(hue: 0.8583, saturation: 0.16, brightness: 0.5, alpha: 1.0)]

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var bio: UITextField!
    @IBOutlet weak var birthdateLabel: UILabel!
    
    let email = UserDefaults.standard.string(forKey: "userEmail")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation(index: 0)
        
        
        //UserDefaults.standard.removeObject(forKey: "Key")  to remove !!
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func openPicker(_ sender: Any) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            // do something after tapping done
            print(date)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd hh:mm:ss +zzzz"
            let myString = formatter.string(from: date)
            print(myString)
            //let myDate = formatter.date(from: myString)
            //let mys =
            self.birthdateLabel.text = myString
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
    

    @IBAction func submit(_ sender: Any) {
        let parameters: [String: Any] = [
            "email" : email as Any,
            "firstname" : firstName.text as Any,
            "lastname" : lastName.text as Any,
            "birthdate" : "1994/10/10 00:00:00" as Any,
            "bio" : bio.text as Any,
            ]
        
        Alamofire.request(cs.url+"/user/update", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["type"] == "success" {
                    print("registred")
                    self.performSegue(withIdentifier: "completeRegsiterToMenu", sender: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
