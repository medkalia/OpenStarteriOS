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

class CollaborationGroupViewController: UIViewController {

    let cs = ConnectionToServer()
    
    @IBOutlet weak var members: UILabel!
    @IBOutlet weak var projects: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var groupList: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addGroup(_ sender: Any) {
        
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
