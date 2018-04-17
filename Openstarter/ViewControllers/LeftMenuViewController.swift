
import UIKit

public class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 5) / 2.0, width: self.view.frame.size.width, height: 54 * 5), style: .plain)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        self.tableView = tableView
        self.view.addSubview(self.tableView!)
    }
    
    // MARK: - <UITableViewDelegate>
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileViewControllerIdentifier")
        
        switch indexPath.row {
        case 0:
            
            //self.present(controller, animated: true, completion: nil)

            //self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerIdentifier").presentationController
            
            /*self.sideMenuViewController!.setContentViewController(self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerIdentifier"), animated: true)*/
            let navToHome = UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "contentViewController"))
            navToHome.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(navToHome, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case 1:
            let navToUserProfile = UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerIdentifier"))
            navToUserProfile.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(navToUserProfile, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case 2:
            let navToGroupProfile = UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "AddProjectViewControllerIdentifier"))
            navToGroupProfile.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(navToGroupProfile, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case 3:
            let navToGroupProfile = UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "FavoriteProjectsViewControllerIdentifier"))
            navToGroupProfile.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(navToGroupProfile, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        case 4:
            let navToGroupProfile = UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "GroupProfileViewControllerIdentifier"))
            navToGroupProfile.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(navToGroupProfile, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            
        default:
            break
        }
    }
    
    // MARK: - <UITableViewDataSource>
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return 6
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = .clear
            cell!.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
            cell!.textLabel?.textColor = .white
            cell!.textLabel?.highlightedTextColor = .lightGray
            cell!.selectedBackgroundView = UIView()
        }
        
        var titles = ["Home", "Profile", "New Project", "Favorites", "Settings", "Log Out"]
        var images = ["IconHome", "IconProfile", "IconProfile", "IconProfile", "IconSettings", "IconEmpty"]
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.imageView?.image = UIImage(named: images[indexPath.row])
        
        return cell!
    }
}
