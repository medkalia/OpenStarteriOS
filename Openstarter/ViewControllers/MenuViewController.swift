//
//  RootViewController.swift
//  Openstarter
//
//  Created by Mohamed Kalia on 3/23/18.
//  Copyright © 2018 Mohamed Kalia. All rights reserved.
//

import Foundation
import AKSideMenu

class MenuViewController: AKSideMenu, AKSideMenuDelegate {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "contentViewController")
        self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "leftMenuViewController")
        //self.rightMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "rightMenuViewController")
        self.backgroundImage = UIImage(named: "Stars-1")
        self.delegate = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - <AKSideMenuDelegate>
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
        //self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
}
