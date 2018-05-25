//
//  MyTaskViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 18/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MyTaskViewController: UIViewController {

    var myTask: MyTask?
    var devImage: UIImage?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()

    }
    
    func fetch() {
        SVProgressHUD.show(withStatus: "Fetching")
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        let url = "http://traxtfsapi.azurewebsites.net/tfs/GetTodayTasks?userid=\(userID)&accountname=\(accountName!)"
        let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        print(safeURL!)
        Alamofire.request(safeURL!).responseJSON { (response) in
            if response.result.isSuccess {
                do {
                    self.myTask = try JSONDecoder().decode(MyTask.self, from: response.data!)
                    self.tableView.reloadData()
                    
                    print("Pass")
                } catch {
                    print("Error")
                }
                SVProgressHUD.dismiss()
                
            }
            
            
            
            
            
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeSegment(_ sender: Any) {
        tableView.reloadData()
    }
}

extension MyTaskViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return myTask?.TaskList?.count ?? 0
        case 1:
            return myTask?.BugList?.count ?? 0
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell") as!  TaskTableViewCell
        cell.selectionStyle = .none
        
        var workitem = WorkItemForMyTask()
        switch segmentControl.selectedSegmentIndex {
        case 0:
            workitem = (myTask?.TaskList?[indexPath.row])!
        case 1:
            workitem = (myTask?.BugList?[indexPath.row])!
        default:
            break
        }

        cell.taskTitle.text = workitem.WorkItemName
        cell.pirorityLabel.text = {
            switch workitem.Priority {
            case 1:
                return "High"
            case 2:
                return "Medium"
            case 3:
                return "Low"
            case 4:
                return "Very Low"
            default:
                break
            }
            return ""
        }()
        switch workitem.Status {
        case "Closed":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.2316122055, green: 0.7209670544, blue: 0.4477117658, alpha: 1)
        case "Active":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case "New":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .none:
            break
        case .some(_):
            break
        }

//        if (workitem.Priority == 4 || workitem.Priority == 3) {
//            cell.colorPirority.backgroundColor = #colorLiteral(red: 0.1439316273, green: 0.6425683498, blue: 0.9966294169, alpha: 1)
//        } else  if (workitem.Priority == 2) {
//            cell.colorPirority.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        } else  if (workitem.Priority == 1) {
//            cell.colorPirority.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        }
        cell.devPic.image = {
            let picData = UserDefaults.standard.string(forKey: "ImageUrl")
            
            if let decodedData = Data(base64Encoded: picData!, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                self.devImage = image
                return image
            } else {
                self.devImage = #imageLiteral(resourceName: "user")
                return #imageLiteral(resourceName: "user")
            }
        }()
        cell.numberCommentLabel.text = "\(workitem.CommentCount!)"
        var startDate = ""
        if let date = workitem.StartDateTime {
            startDate  = String(date.prefix(10))
        }

        cell.dateLabel.text = startDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = {
                let w = myTask?.TaskList?[indexPath.row]
                let workItem = WorkItem(WorkItemID: w?.WorkItemID, WorkItemType: w?.WorkItemType, WorkItemName: w?.WorkItemName, Description: w?.Description, MemberName: w?.MemberName, Status: w?.Status, StartDateTime: w?.StartDateTime, Priority: w?.Priority, CommentCount: w?.CommentCount)
                return workItem
            }()
            vc.devImage = devImage
            vc.navigationItem.title = "Task Detail"
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = {
                let w = myTask?.BugList?[indexPath.row]
                let workItem = WorkItem(WorkItemID: w?.WorkItemID, WorkItemType: w?.WorkItemType, WorkItemName: w?.WorkItemName, Description: w?.Description, MemberName: w?.MemberName, Status: w?.Status, StartDateTime: w?.StartDateTime, Priority: w?.Priority, CommentCount: w?.CommentCount)
                return workItem
            }()
            vc.devImage = devImage
            vc.navigationItem.title = "Bug Detail"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    
}
