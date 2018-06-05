//
//  DeveloperListViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 14/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire

class DeveloperListViewController: UIViewController {
    
    
//    var myDevList: [MyDeveloperList]?
    var devImageList = [UIImage]()
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var projectListFinal = [ProjectFromTFS]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Developer List"
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
//        fetch()
        // Do any additional setup after loading the view.
    }
    
//    func fetch() {
//        let userID = UserDefaults.standard.integer(forKey: "UserID")
//        let accountName = UserDefaults.standard.string(forKey: "accountName")
//        let url = "http://traxtfsapi.azurewebsites.net/trax/getdeveloperlist?userid=\(userID)&accountname=\(accountName!)"
//        let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//        activityView.startAnimating()
//        Alamofire.request(safeURL!).responseJSON { (response) in
//           do {
//                let myDeveloperList = try JSONDecoder().decode([MyDeveloperList].self, from: response.data!)
//                self.myDevList = myDeveloperList
//                print("pass")
//                self.tableView.reloadData()
//                self.activityView.stopAnimating()
//            } catch let error {
//                print("\(error)")
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DeveloperListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myDevList?.count ?? 0
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dev_cell", for: indexPath) as! DeveloperTableViewCell
        cell.selectionStyle = .none
//        let developer = myDevList?[indexPath.row]
//        if (developer?.ImageUrl == nil) {
//             cell.developerPic.image = #imageLiteral(resourceName: "user")
//        } else {
//            cell.developerPic.image = {
//                if let decodedData = Data(base64Encoded: (developer?.ImageUrl)!, options: .ignoreUnknownCharacters) {
//                    if let image = UIImage(data: decodedData) {
//                        devImageList.append(image)
//                        return image
//                    } else {
//                        devImageList.append(#imageLiteral(resourceName: "user"))
//                        return #imageLiteral(resourceName: "user")
//                    }
//
//                } else {
//                    devImageList.append(#imageLiteral(resourceName: "user"))
//                    return #imageLiteral(resourceName: "user")
//                }
//            }()
//        }
//        cell.developerName.text = developer?.DisplayName
//        cell.doingProgessLabel.text = "\(developer?.TaskProgress?.DoingTask ?? 0)"
//        cell.doneProgressLabel.text = "\(developer?.TaskProgress?.DoneTask ?? 0)"
//        cell.remainningProgessLabel.text = "\(developer?.TaskProgress?.DueTask ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dev_vc = storyboard?.instantiateViewController(withIdentifier: "dev_vc") as! DeveloperViewController
        
//        let developer = myDevList?[indexPath.row]
//        dev_vc.dev = {
//           let dev = Developer(DisplayName: developer?.DisplayName,
//                               WorkItemIDs: developer?.TaskProgress?.WorkItemList,
//                               Done: developer?.TaskProgress?.DoneTask,
//                               Doing: developer?.TaskProgress?.DoingTask,
//                               Due: developer?.TaskProgress?.DueTask)
//            return dev
//        }()
//        dev_vc.devImage = devImageList[indexPath.row]
        navigationController?.pushViewController(dev_vc, animated: true)
    }
    
}
