//
//  TabbarViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectCompany_vc = storyboard?.instantiateViewController(withIdentifier: "selectCompany_vc") as! SelectCompanyViewController
        let selectProject_vc = storyboard?.instantiateViewController(withIdentifier: "selectproject_vc") as! SelectProjectViewController
        let devList_vc = storyboard?.instantiateViewController(withIdentifier: "devList_vc") as! DeveloperListViewController
        let mytask_vc = storyboard?.instantiateViewController(withIdentifier: "mytask_vc") as! MyTaskViewController
        let profile_vc = storyboard?.instantiateViewController(withIdentifier: "profile_vc") as! ProfileViewController
        let accountList_vc = storyboard?.instantiateViewController(withIdentifier: "accountList_vc") as! AccountListViewController
        
        
        if let user_role = UserDefaults.standard.string(forKey: "Role") {
            switch user_role {
            case "CEO":
                selectProject_vc.tabBarItem = UITabBarItem(title: "Task", image: #imageLiteral(resourceName: "task"), tag: 0)
                devList_vc.tabBarItem = UITabBarItem(title: "Developer List", image: #imageLiteral(resourceName: "Developer"), tag: 1)
                profile_vc.tabBarItem = UITabBarItem(title: "Profile", image: resizeImage(image: #imageLiteral(resourceName: "user"), newWidth: 32), tag: 2)
                viewControllers = [UINavigationController(rootViewController: selectProject_vc), UINavigationController(rootViewController: devList_vc), UINavigationController(rootViewController: profile_vc)]
                
            case "ProjectManager":
                mytask_vc.tabBarItem = UITabBarItem(title: "My Task", image: #imageLiteral(resourceName: "Task-1"), tag: 0)
                selectProject_vc.tabBarItem = UITabBarItem(title: "Project", image: #imageLiteral(resourceName: "task"), tag: 1)
                profile_vc.tabBarItem = UITabBarItem(title: "Profile", image: resizeImage(image: #imageLiteral(resourceName: "user"), newWidth: 32), tag: 2)
                viewControllers = [UINavigationController(rootViewController: mytask_vc), UINavigationController(rootViewController: selectProject_vc), UINavigationController(rootViewController: profile_vc)]
            case"Developer":
                mytask_vc.tabBarItem = UITabBarItem(title: "My Task", image: #imageLiteral(resourceName: "Task-1"), tag: 0)
                profile_vc.tabBarItem = UITabBarItem(title: "Profile", image: resizeImage(image: #imageLiteral(resourceName: "user"), newWidth: 32), tag: 2)
                 viewControllers = [UINavigationController(rootViewController: mytask_vc),  UINavigationController(rootViewController: profile_vc)]
            default:
                break
            }
           
        }
        
        
        
        
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
