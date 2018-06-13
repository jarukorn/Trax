//
//  MyTaskViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 18/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire

class MyTaskViewController: UIViewController {

    var todayTask: [WorkItemFromTFS]?
    var tasks = [WorkItemFromTFS]()
    var bugs = [WorkItemFromTFS]()
    var devImage: UIImage?
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var projectName :[String] = []
    var checkerTasks = 0
    var checkerBugs = 0
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    func fetch() {
        checkerTasks = 0
        checkerBugs = 0
        todayTask = []
        tasks = []
        bugs = []
        activityView.startAnimating()
        let token = UserDefaults.standard.string(forKey: "Token")
        let displayName = UserDefaults.standard.string(forKey: "DisplayName")
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        getTodayTask(accountName: accountName!, developerName: displayName!, token: token!) { (workItemNumberList) in
            var workItemStr = ""
            print(workItemNumberList.count)
            if workItemNumberList.count != 0 {
                for j in 0...workItemNumberList.count-1 {
                    workItemStr = workItemStr + "\(workItemNumberList[j])"
                    if (j != workItemNumberList.count-1) {
                        workItemStr = workItemStr + ","
                    }
                }
                print(workItemStr)
                getTaskFromWorkItemID(token: token!, id: workItemStr, accountName: accountName!, resume: { (workItems) in
                    self.todayTask = workItems
                    var interation = 0
                    for task in self.todayTask! {
                        interation = interation + 1
                        if task.type == "Task" {
                            self.tasks.append(task)
                        } else if task.type == "Bug" {
                            self.bugs.append(task)
                        }
                        if interation == (self.todayTask?.count)!-1 {
                            self.tableView.reloadData()
                            self.activityView.stopAnimating()
                        }
                    }
                    
                })
            } else {
                self.activityView.stopAnimating()
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
            return tasks.count
        case 1:
            return bugs.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell") as!  TaskTableViewCell
        cell.selectionStyle = .none
        
        var workitem = WorkItemFromTFS()
        switch segmentControl.selectedSegmentIndex {
        case 0:
            workitem = tasks[indexPath.row]
        case 1:
            workitem = bugs[indexPath.row]
        default:
            break
        }

        cell.taskTitle.text = workitem.title
        cell.pirorityLabel.text = {
            switch workitem.priority {
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
        
        switch workitem.state {
        case "Done":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.2, green: 0.6784313725, blue: 0.3725490196, alpha: 1)
        case "Closed":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.2, green: 0.6784313725, blue: 0.3725490196, alpha: 1)
        case "In Progress":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 1, green: 0.8254478574, blue: 0.4373552203, alpha: 1)
        case "Active":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 1, green: 0.8254478574, blue: 0.4373552203, alpha: 1)
        case "To Do":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        case "New":
            cell.statusColorView.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        default:
            cell.statusColorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        cell.projectName.text = workitem.projectName
        
        cell.numberCommentLabel.text = "\(workitem.comment?.count ?? 0)"
        cell.dateLabel.text = String((workitem.createdDate?.prefix(10))!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            
            vc.task = tasks[indexPath.row]
            vc.navigationItem.title = "Task Detail"
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = bugs[indexPath.row]
            vc.navigationItem.title = "Bug Detail"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    
}
