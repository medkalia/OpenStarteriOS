//
//  ContentMenuViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 3/24/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import FoldingCell
import UIKit
import Alamofire
import SwiftyJSON

class ContentMenuViewController: UITableViewController {
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let cs = ConnectionToServer()
   // var json = JSON()
    //var count :Int = 0
    var projectArray:NSArray = []
    var idProject:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       fetchProjects(url:cs.url+"/project/getAll")
       
    }
    func fetchProjects(url:String){
        Alamofire.request(url).validate().responseJSON(completionHandler:{response in
            switch response.result{
            case .success:
                print("validation succesful")
                print(response.result.value!)
                self.projectArray = response.result.value! as! NSArray
                
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        } )
        
    }
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
}

// MARK: - TableView

extension ContentMenuViewController {
    
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return projectArray.count
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
 
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
       // cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        let nameLbl_out = cell.viewWithTag(10) as? UILabel
        let descLbl_out = cell.viewWithTag(11) as? UILabel
        let followsLbl_out = cell.viewWithTag(12) as? UILabel
        let pledgesLbl_out = cell.viewWithTag(13) as? UILabel
        let goalLbl_out = cell.viewWithTag(14) as? UILabel
        let namelbl = cell.viewWithTag(15) as? UILabel
        let pourcntagelbl = cell.viewWithTag(16) as? UILabel
        let followslbl = cell.viewWithTag(17) as? UILabel
        let pledgeslbl = cell.viewWithTag(18) as? UILabel
        let goallbl = cell.viewWithTag(19) as? UILabel
        let desclbl = cell.viewWithTag(20) as? UILabel
        let fromlbl = cell.viewWithTag(21) as? UILabel
        let tolbl = cell.viewWithTag(22) as? UILabel
        let deadlinelbl = cell.viewWithTag(23) as? UILabel
        let projects = projectArray[indexPath.row] as! Dictionary<String,Any>
       // self.idProject = String(describing: projects["id"]!)
        nameLbl_out?.text = projects["name"] as? String
        descLbl_out?.text =  projects["shortDescription"]  as? String
        followsLbl_out?.text = projects["followCount"] as? String
        let budget : Double = (projects["budget"]  as? Double)!
        let Currentbudget : Double = (projects["currentBudget"]  as? Double)!
        pledgesLbl_out?.text =  String(Currentbudget)+"$"
        goalLbl_out?.text = String(budget)+"$"
        namelbl?.text = projects["name"] as? String
        pourcntagelbl?.text = "20%"
        followslbl?.text = projects["followCount"] as? String
        pledgeslbl?.text =  String(Currentbudget)+"$"
        goallbl?.text = String(budget)+"$"
        desclbl?.text =  projects["shortDescription"]  as? String
        fromlbl?.text = projects["startDate"] as? String
        tolbl?.text = projects["finishDate"] as? String
        deadlinelbl?.text = "4days"
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",self.idProject)
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
      
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        let projects = projectArray[indexPath.row] as! Dictionary<String,Any>
        print(projects["id"]!)
        self.idProject = projects["id"]! as! Int
        
        if cellIsCollapsed {
            
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
            
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }, completion: nil)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details"{
            if let destinationVC = segue.destination as? ProjectDetailsViewController {
                destinationVC.id = self.idProject
                print(self.idProject)
            }
        }
    }
}
