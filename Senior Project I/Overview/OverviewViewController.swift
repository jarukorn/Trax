//
//  OverviewViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var workItemList: String?
    var workList: WorkItemList?
    var teamMembers: TeamMembers?
    var imageList = [UIImage]()
    var taskImageList = [UIImage]()
    var bugImageList = [UIImage]()
    var projectName : String?
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var numberofCompleteLabel: UILabel!
    @IBOutlet weak var numberofDoingLabel: UILabel!
    @IBOutlet weak var numberofRemainingLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Project Overview"
        fetch()
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        
        
        
    }
    
    func fetch() {
        activityView.startAnimating()
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        let url = "http://traxtfsapi.azurewebsites.net/trax/getworkItemlist?workitemlist=\(workItemList!)&userid=\(userID)&accountname=\(accountName!)"
        let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(safeURL!).responseJSON { (response) in
            do {
                let workList = try JSONDecoder().decode(WorkItemList.self, from: response.data!)
                self.workList = workList
                print("pass")
                self.projectNameLabel.text = "\(self.projectName!)"
                self.numberofDoingLabel.text = "\(workList.Doing ?? 0)"
                self.numberofCompleteLabel.text = "\(workList.Done ?? 0)"
                self.numberofRemainingLabel.text = "\(workList.Due ?? 0)"
                self.table.reloadData()
                self.activityView.stopAnimating()
            } catch {
                print("error")
            }
        }.resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.title = "Project Overview"
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return workList?.MemberList?.count ?? 0
        case 1:
            return workList?.TaskList?.count ?? 0
        case 2:
            return workList?.BugList?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dev_cell", for: indexPath) as! DeveloperTableViewCell
            cell.selectionStyle = .none
            
            for member in teamMembers!.Value! {
                if (member.DisplayName == workList?.MemberList?[indexPath.row].DisplayName) {
                    if (member.ImageUrl == nil) {
                        cell.developerPic.image = #imageLiteral(resourceName: "user")
                        imageList.append(#imageLiteral(resourceName: "user"))
                    } else {
                        let encodedImageData = member.ImageUrl
                        if let decodedData = Data(base64Encoded: encodedImageData!, options: .ignoreUnknownCharacters) {
                            if let image = UIImage(data: decodedData) {
                                cell.developerPic.image = image
                                imageList.append(image)
                            } else {
                                cell.developerPic.image = #imageLiteral(resourceName: "user")
                                imageList.append(#imageLiteral(resourceName: "user"))
                            }
                            
                        }
                    }
                }
            }
            
            cell.developerName.text = workList?.MemberList?[indexPath.row].DisplayName
            cell.doingProgessLabel.text = "\(workList?.MemberList?[indexPath.row].Doing ?? 0)"
            cell.doneProgressLabel.text = "\(workList?.MemberList?[indexPath.row].Done ?? 0)"
            cell.remainningProgessLabel.text = "\(workList?.MemberList?[indexPath.row].Due ?? 0)"
            return cell
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell", for: indexPath) as! TaskTableViewCell
            cell.selectionStyle = .none
            var taskandBugInstance = WorkItem()
            switch segmentControl.selectedSegmentIndex {
            case 1:
                taskandBugInstance = (workList?.TaskList![indexPath.row])!
            case 2:
                taskandBugInstance = (workList?.BugList![indexPath.row])!
            default:
                break
            }

            for member in teamMembers!.Value! {
                switch segmentControl.selectedSegmentIndex {
                case 1:
                    if (member.DisplayName == workList?.TaskList![indexPath.row].MemberName) {
                        if (member.ImageUrl == nil) {
                            cell.devPic.image = #imageLiteral(resourceName: "user")
                            taskImageList.append(#imageLiteral(resourceName: "user"))
                        } else {
                            let encodedImageData = member.ImageUrl
                            if let decodedData = Data(base64Encoded: encodedImageData!, options: .ignoreUnknownCharacters) {
                                if let image = UIImage(data: decodedData) {
                                    cell.devPic.image = image
                                    taskImageList.append(image)
                                } else {
                                    cell.devPic.image = #imageLiteral(resourceName: "user")
                                    taskImageList.append(#imageLiteral(resourceName: "user"))
                                }
                                
                            }
                        }
                    }
                case 2:
                    if (member.DisplayName == workList?.BugList![indexPath.row].MemberName) {
                        if (member.ImageUrl == nil) {
                            cell.devPic.image = #imageLiteral(resourceName: "user")
                            bugImageList.append(#imageLiteral(resourceName: "user"))
                        } else {
                            let encodedImageData = member.ImageUrl
                            if let decodedData = Data(base64Encoded: encodedImageData!, options: .ignoreUnknownCharacters) {
                                if let image = UIImage(data: decodedData) {
                                    cell.devPic.image = image
                                    bugImageList.append(image)
                                } else {
                                    cell.devPic.image = #imageLiteral(resourceName: "user")
                                    bugImageList.append(#imageLiteral(resourceName: "user"))
                                }
                                
                            }
                        }
                    }
                default:
                    break
                }

                
            }
            
            
            cell.taskTitle.text = taskandBugInstance.WorkItemName
            var temp = ""
            switch taskandBugInstance.Priority {
            case 1:
                temp = "High"
            case 2:
                temp = "Medium"
            case 3:
                temp = "Low"
            case 4:
                temp = "Very Low"
            default:
                break
            }
            cell.pirorityLabel.text = temp
            
            switch taskandBugInstance.Status {
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

//            if (taskandBugInstance.Priority == 3 || taskandBugInstance.Priority == 4) {
//                cell.colorPirority.backgroundColor = #colorLiteral(red: 0.1439316273, green: 0.6425683498, blue: 0.9966294169, alpha: 1)
//            } else  if (taskandBugInstance.Priority == 2) {
//                cell.colorPirority.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//            } else  if (taskandBugInstance.Priority == 1) {
//                cell.colorPirority.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//            }

            cell.numberCommentLabel.text = "\(taskandBugInstance.CommentCount ?? 0)"
            
            var startDate = ""
            if let date = taskandBugInstance.StartDateTime {
                startDate  = String(date.prefix(10))
            }

            cell.dateLabel.text = startDate
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "dev_vc") as! DeveloperViewController
            vc.dev = workList?.MemberList![indexPath.row]
            vc.devImage = imageList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = workList?.TaskList![indexPath.row]
            vc.navigationItem.title = "Task Detail"
            vc.devImage = taskImageList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = workList?.BugList![indexPath.row]
            vc.navigationItem.title = "Bug Detail"
            vc.devImage = bugImageList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch segmentControl.selectedSegmentIndex {
        case 0,1,2:
            return 90
        default:
            return 0
        }
    
    }
    
    @IBAction func changedBar(_ sender: Any) {
        table.reloadData()
    }

        @IBAction func segmentHasSwitch(_ sender: Any) {
        table.reloadData()
    }

}
