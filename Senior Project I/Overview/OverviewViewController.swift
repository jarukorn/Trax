//
//  OverviewViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire

struct MemberTaskInformation {
    var teamMember: TeamMemberTFS?
    var taskProgress = TaskProgress()
    var task: [WorkItemFromTFS]?
    var bug: [WorkItemFromTFS]?
}

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var project: ProjectFromTFS?
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var tasks = [WorkItemFromTFS]()
    var bugs = [WorkItemFromTFS]()
    var memberTaskList = [MemberTaskInformation]()
    let imageCache = NSCache<NSString, UIImage>()
    
    
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
        activityView.center = self.view.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
        
       
        numberofCompleteLabel.text = "\(project!.taskProgress.complete)"
        numberofDoingLabel.text = "\(project!.taskProgress.doing)"
        numberofRemainingLabel.text = "\(project!.taskProgress.new)"
        
    }
    
    func fetch() {
        activityView.startAnimating()
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        let token = UserDefaults.standard.string(forKey: "Token")

        if let projectTemp = project {
            self.projectNameLabel.text = project?.name
            self.numberofDoingLabel.text = "\(projectTemp.taskProgress.doing)"
            self.numberofCompleteLabel.text = "\(projectTemp.taskProgress.complete)"
            self.numberofRemainingLabel.text = "\(projectTemp.taskProgress.new)"
           

//            for developer in projectTemp.teamList! {
//                print("Developer name is \(developer.name)")
//            }
            
            for developer in projectTemp.teamList! {
                var memberTask = MemberTaskInformation(teamMember: developer, taskProgress: TaskProgress(), task: [WorkItemFromTFS](), bug: [WorkItemFromTFS]())
//                 print("Developer name is \(developer.name)")
                for task in projectTemp.task! {
//                    print("This task assign to \(task.assignedTo ?? "")")
                    if task.assignedTo != nil {
                        let list = task.assignedTo?.split(separator: "<", maxSplits: 1, omittingEmptySubsequences: true)
                        let temp = list![0].dropLast()
//                        print("Convert to \(temp)")
                        
                        if (temp == developer.name) {
//                            print("It is the same.")
                            if (task.type == "Task") {
                                memberTask.task?.append(task)
                            } else if (task.type == "Bug") {
                                memberTask.bug?.append(task)
                            }
                            
                            switch task.state {
                            case "Done":
                                memberTask.taskProgress.complete = memberTask.taskProgress.complete + 1
                            case "Closed":
                                memberTask.taskProgress.complete = memberTask.taskProgress.complete + 1
                            case "In Progress":
                                memberTask.taskProgress.doing = memberTask.taskProgress.doing + 1
                            case "Active":
                                memberTask.taskProgress.doing = memberTask.taskProgress.doing + 1
                            case "To Do":
                                memberTask.taskProgress.new = memberTask.taskProgress.new + 1
                            case "New":
                                memberTask.taskProgress.new = memberTask.taskProgress.new + 1
                            case .some(_):
                                break
                            default:
                                break
                            }

                        }
                    }
                }
                memberTaskList.append(memberTask)
            }
            
        }
        var interation = 0
        for i in 0...self.project!.task!.count-1 {
            getComment(accountName: accountName!, token: token!, task: project!.task![i]) { (CommentList) in
                self.project!.task![i].comment = CommentList
                interation = interation + 1
                if (interation == self.project!.task!.count-1) {
                    self.tasks = (self.project?.task?.filter({ (workitem) -> Bool in
                        return workitem.type == "Task"
                    }))!
                    
                    self.bugs = (self.project?.task?.filter({ (workitem) -> Bool in
                        return workitem.type == "Bug"
                    }))!
                    
                    self.tasks.sort { (firstItem, secondItem) -> Bool in
                        firstItem.stateValue < secondItem.stateValue
                    }
                    self.bugs.sort { (firstItem, secondItem) -> Bool in
                        firstItem.stateValue < secondItem.stateValue
                    }
                    self.table.reloadData()
                    self.activityView.stopAnimating()
                }
            }
            
        }
        
        print(memberTaskList.count)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.title = "Project Overview"
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return project?.teamList?.count ?? 0
        case 1:
            return tasks.count
        case 2:
            return bugs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dev_cell", for: indexPath) as! DeveloperTableViewCell
            cell.selectionStyle = .none
            
            cell.developerName.text = memberTaskList[indexPath.row].teamMember?.name
            cell.doingProgessLabel.text = "\(memberTaskList[indexPath.row].taskProgress.doing)"
            cell.doneProgressLabel.text = "\(memberTaskList[indexPath.row].taskProgress.complete)"
            cell.remainningProgessLabel.text = "\(memberTaskList[indexPath.row].taskProgress.new)"
            
            
            cell.developerPic.image = {
                if memberTaskList[indexPath.row].teamMember?.image == nil {
                    return #imageLiteral(resourceName: "user")
                } else {
                    return memberTaskList[indexPath.row].teamMember?.image
                }
            }()
            
            return cell
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell", for: indexPath) as! TaskTableViewCell
            cell.selectionStyle = .none
            var taskandBugInstance = [WorkItemFromTFS]()
            switch segmentControl.selectedSegmentIndex {
            case 1:
                taskandBugInstance = tasks
            case 2:
                taskandBugInstance = bugs
            default:
                break
            }
            
            if taskandBugInstance[indexPath.row].assignedTo != nil {
                let list = taskandBugInstance[indexPath.row].assignedTo?.split(separator: "<", maxSplits: 1, omittingEmptySubsequences: true)
                let temp = list![0].dropLast()
                cell.assignToLabel.text = "\(temp)"
            } else {
                cell.assignToLabel.text = ""
            }
            
//            if cell.devPic.image != nil {
//                cell.devPic.image = #imageLiteral(resourceName: "user")
//            }
            
            switch taskandBugInstance[indexPath.row].state {
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
            
            cell.taskTitle.text = taskandBugInstance[indexPath.row].title
            var temp = ""
            switch taskandBugInstance[indexPath.row].priority {
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
            cell.numberCommentLabel.text = "\(taskandBugInstance[indexPath.row].comment!.count)"
            
            var startDate = ""
            if let date = taskandBugInstance[indexPath.row].createdDate {
                startDate  = String(date.prefix(10))
            }

            cell.dateLabel.text = startDate
            
//
//            for member in teamMembers!.Value! {
//                switch segmentControl.selectedSegmentIndex {
//                case 1:
//                    if (member.DisplayName == workList?.TaskList![indexPath.row].MemberName) {
//                        if (member.ImageUrl == nil) {
//                            cell.devPic.image = #imageLiteral(resourceName: "user")
//                            taskImageList.append(#imageLiteral(resourceName: "user"))
//                        } else {
//                            let encodedImageData = member.ImageUrl
//                            if let decodedData = Data(base64Encoded: encodedImageData!, options: .ignoreUnknownCharacters) {
//                                if let image = UIImage(data: decodedData) {
//                                    cell.devPic.image = image
//                                    taskImageList.append(image)
//                                } else {
//                                    cell.devPic.image = #imageLiteral(resourceName: "user")
//                                    taskImageList.append(#imageLiteral(resourceName: "user"))
//                                }
//
//                            }
//                        }
//                    }
//                case 2:
//                    if (member.DisplayName == workList?.BugList![indexPath.row].MemberName) {
//                        if (member.ImageUrl == nil) {
//                            cell.devPic.image = #imageLiteral(resourceName: "user")
//                            bugImageList.append(#imageLiteral(resourceName: "user"))
//                        } else {
//                            let encodedImageData = member.ImageUrl
//                            if let decodedData = Data(base64Encoded: encodedImageData!, options: .ignoreUnknownCharacters) {
//                                if let image = UIImage(data: decodedData) {
//                                    cell.devPic.image = image
//                                    bugImageList.append(image)
//                                } else {
//                                    cell.devPic.image = #imageLiteral(resourceName: "user")
//                                    bugImageList.append(#imageLiteral(resourceName: "user"))
//                                }
//
//                            }
//                        }
//                    }
//                default:
//                    break
//                }
//
//
//            }
//
//
//            cell.taskTitle.text = taskandBugInstance.WorkItemName
//            var temp = ""
//            switch taskandBugInstance.Priority {
//            case 1:
//                temp = "High"
//            case 2:
//                temp = "Medium"
//            case 3:
//                temp = "Low"
//            case 4:
//                temp = "Very Low"
//            default:
//                break
//            }
//            cell.pirorityLabel.text = temp
//
//            switch taskandBugInstance.Status {
//            case "Closed":
//                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.2316122055, green: 0.7209670544, blue: 0.4477117658, alpha: 1)
//            case "Active":
//                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//            case "New":
//                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//            case .none:
//                break
//            case .some(_):
//                break
//            }
//
////            if (taskandBugInstance.Priority == 3 || taskandBugInstance.Priority == 4) {
////                cell.colorPirority.backgroundColor = #colorLiteral(red: 0.1439316273, green: 0.6425683498, blue: 0.9966294169, alpha: 1)
////            } else  if (taskandBugInstance.Priority == 2) {
////                cell.colorPirority.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
////            } else  if (taskandBugInstance.Priority == 1) {
////                cell.colorPirority.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
////            }
//
//            cell.numberCommentLabel.text = "\(taskandBugInstance.CommentCount ?? 0)"
//
//            var startDate = ""
//            if let date = taskandBugInstance.StartDateTime {
//                startDate  = String(date.prefix(10))
//            }

//            cell.dateLabel.text = startDate
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
            vc.dev = memberTaskList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = tasks[indexPath.row]
            vc.navigationItem.title = "Task Detail"
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = bugs[indexPath.row]
            vc.navigationItem.title = "Bug Detail"
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
