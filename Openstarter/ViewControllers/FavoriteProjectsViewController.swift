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

class FavoriteProjectsViewController: UITableViewController {
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let cs = ConnectionToServer()
    // var json = JSON()
    //var count :Int = 0
    var projectArray:NSArray = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let parameters: [String: Any] = [
            "email" : "mohamed@gmail.com"
        ]
        
        //fetchProjects(url:cs.url+"/project/getFavoriteProjects", info: parameters)
        
        Alamofire.request(cs.url+"/project/getFavoriteProjects", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("validation succesful")
                print(response.result.value!)
                self.projectArray = response.result.value! as! NSArray
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    /*func fetchProjects(url:String, info: [String: Any]){
        
        
    
        Alamofire.request(cs.url+"/user/login", method: .post, parameters: info, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["loggedIn"] == "true" {
                    print("logged in")
                    self.performSegue(withIdentifier: "toMenu", sender: nil)
                } else if json["loggedIn"] == "false" {
                    print("not loggedin")
                    let message = "wrong password "
                    let alert = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("JSON: \(json)")
                let message = "wrong email "
                let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
        
        
        
        /*Alamofire.request(url).validate().responseJSON(completionHandler:{response in
            switch response.result{
            case .success:
                print("validation succesful")
                print(response.result.value!)
                self.projectArray = response.result.value! as! NSArray
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        } )*/
        
    }*/
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
}

// MARK: - TableView

extension FavoriteProjectsViewController {
    
    
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
        
        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        let nameLbl = cell.viewWithTag(10) as? UILabel
        let projects = projectArray[indexPath.row] as! Dictionary<String,Any>
        nameLbl?.text = projects["name"] as? String
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
}
