//
//  ProjectDetailsViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 3/29/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProjectDetailsViewController: UIViewController , UIScrollViewDelegate{

    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var currentBudget: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var finishDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var nameProject: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var contentWith:CGFloat = 0.0
    @IBOutlet weak var imageToDisplay: UIImageView!
    var images = [UIImage]()
    let cs = ConnectionToServer()
    var id:Int = 0
    var colors: [UIColor] = [UIColor(hue: 0.5444, saturation: 0.8, brightness: 0.54, alpha: 1.0), UIColor(hue: 0.5667, saturation: 0.99, brightness: 0.72, alpha: 1.0),UIColor(hue: 0.5833, saturation: 0.25, brightness: 0.27, alpha: 1.0), UIColor(hue: 0.8583, saturation: 0.16, brightness: 0.5, alpha: 1.0)]
    //color codes : "#1C6E8C", "#826C7F", "#016FB9"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        //self.startAnimation(index: 0)
       // print("projectId",id)
        images = [#imageLiteral(resourceName: "photo") , #imageLiteral(resourceName: "Balloon") , #imageLiteral(resourceName: "photo"),]
        
        for image1 in 0..<images.count{
            //let ima = UIImage(named: "\(image1).png")
            let imageView = UIImageView()
            imageView.image = images[image1]
            contentWith += viewImage.frame.width
            scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: viewImage.frame.width / 4, y: viewImage.frame.height / 4 , width: 200, height: 150)
   
        }
        scrollView.contentSize = CGSize(width: contentWith, height: viewImage.frame.height)
        
        //get data
        
        let parameters: [String: Any] = [
            "id" : self.id
        ]
        
        Alamofire.request(cs.url+"/project/getById", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                    print("mawwww",value)
                print("alolo",self.id)
                //print(json)
                  //self.fullName.text = json["firstName"].string!
                self.nameProject.text = json[0]["name"].stringValue
                self.startDate.text = json[0]["startDate"].stringValue
                self.finishDate.text = json[0]["finishDate"].stringValue
                self.budget.text = json[0]["budget"].stringValue
                self.currentBudget.text = json[0]["currentBudget"].stringValue
                self.desc.text = json[0]["description"].stringValue
               
            case .failure(let error):
                print(error)
               
            }
        }
                    

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
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

   


}
