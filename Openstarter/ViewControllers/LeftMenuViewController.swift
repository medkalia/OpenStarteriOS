
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
        switch indexPath.row {
        case 0:
            self.sideMenuViewController!.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerIdentifier")
            
            /*self.sideMenuViewController!.setContentViewController(self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewControllerIdentifier"), animated: true)*/
            
            /*self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewController")), animated: true)*/
            self.sideMenuViewController!.hideMenuViewController()
            
        case 1:
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewController")), animated: true)
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
        return 3
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
        
        var titles = ["Profile", "Settings", "Log Out"]
        var images = ["IconProfile", "IconSettings", "IconEmpty"]
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.imageView?.image = UIImage(named: images[indexPath.row])
        
        return cell!
    }
}
