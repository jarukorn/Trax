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
    
    struct DevProgress {
        var name: String?
        var imageURL: String?
        var image : UIImage?
        var new = 0
        var doing = 0
        var done = 0
        var workItemList: [WorkItemFromTFS]?
    }
    
    //    var myDevList: [MyDeveloperList]?

    var projectListFinal = [ProjectFromTFS]()
    var tempTeamMember = [TeamMemberTFS]()
    var teamMember = [TeamMemberTFS]()
    var devProgressList = [DevProgress]()
    var todayTask: [WorkItemFromTFS]?
    var allTasks = [WorkItemFromTFS]()
    var devImageList = [UIImage]()
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var nameList = [String]()
    var devImage: UIImage?
    var projectName :[String] = []
    var checkerTasks = 0
    var checkerBugs = 0
    let account = UserDefaults.standard.string(forKey: "accountName")
    let token = UserDefaults.standard.string(forKey: "Token")
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Developer List"
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
        getDeveloperList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getDeveloperList() {
        var iteration1 = 0
        var iteration2 = 0
        var iteration3 = 0
        getTeamList(accountName: account!, token: token!) { (teams) in
            for i in teams {
                iteration1 = iteration1 + 1
                getTeamMember(accountName: self.account!, token: self.token!, projectID: i.projectID!, teamID: i.teamID!, result: { (members) in
                    iteration2 = iteration2 + 1
                    iteration3 = 0
                    for member in members {
                        iteration3 = iteration3 + 1
                        self.tempTeamMember.append(member)
                        if(!(self.nameList.contains(member.name))) {
                             self.nameList.append(member.name)
                        }
                        if iteration1 == teams.count && iteration2 == teams.count && iteration3 == members.count {
                            self.createTeamWithoutDuplication()
                        }
                    }
                })
            }
        }
    }
    var temp = [String]()
    func createTeamWithoutDuplication() {
        for member in tempTeamMember {
            if (!(temp.contains(member.name))) {
                if((self.nameList.contains(member.name))) {
                    self.teamMember.append(member)
                    temp.append(member.name)
                }
            }
            
        }
        getTaskFromDev()
    }
    
    
    func getTaskFromDev() {
        print(teamMember.count)
        checkerTasks = 0
        checkerBugs = 0
        todayTask = []
        allTasks = []
        activityView.startAnimating()
        var iteration4 = 0
        var iteration5 = 0
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        for member in teamMember {
            iteration4 = iteration4 + 1
            var progress = DevProgress()
            getTodayTask(accountName: accountName!, developerName: member.name, token: token!) { (workItemNumberList) in
                var workItemStr = ""
                iteration5 = iteration5 + 1
                print(workItemNumberList.count)
                if workItemNumberList.count != 0 {
                    for j in 0...workItemNumberList.count-1 {
                        workItemStr = workItemStr + "\(workItemNumberList[j])"
                        if (j != workItemNumberList.count-1) {
                            workItemStr = workItemStr + ","
                        }
                    }
                    print(workItemStr)
                    getTaskFromWorkItemID(token: self.token!, id: workItemStr, accountName: accountName!, resume: { (workItems) in
                        self.todayTask = workItems
                        for task in self.todayTask! {
                            self.allTasks.append(task)
                            progress.name = member.name
                            progress.imageURL = member.imageURL
                            progress.workItemList = workItems
                           
                        }
//                        if iteration4 == self.teamMember.count && iteration5 == workItemNumberList.count {
                            print(self.allTasks)
                            self.modifyPresenter()
//                        }
                        
                    })
                } else {
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                }
            }
        }
    }
    
    func modifyPresenter() {
        print(allTasks.count)
        print(teamMember.count)
        devProgressList = []
        for team in teamMember {
           
            let dev = DevProgress(name: team.name, imageURL: team.imageURL, image: nil, new: 0, doing: 0, done: 0, workItemList: [WorkItemFromTFS]())
            devProgressList.append(dev)
        }
        
        for task in allTasks {
            for i in 0...devProgressList.count-1 {
                let list = task.assignedTo?.split(separator: "<", maxSplits: 1, omittingEmptySubsequences: true)
                let temp = String(list![0].dropLast())
                if temp == devProgressList[i].name {
                    switch task.state {
                    case "Done":
                        devProgressList[i].done = devProgressList[i].done + 1
                    case "Closed":
                        devProgressList[i].done = devProgressList[i].done + 1
                    case "In Progress":
                        devProgressList[i].doing = devProgressList[i].doing + 1
                    case "Active":
                        devProgressList[i].doing = devProgressList[i].doing + 1
                    case "To Do":
                        devProgressList[i].new = devProgressList[i].new + 1
                    case "New":
                        devProgressList[i].new = devProgressList[i].new + 1
                    default:
                        break
                    }
                    devProgressList[i].workItemList?.append(task)
                }
            }
        }
        getPic()
    }
    
    func getPic() {
        var iteration = 0
        for i in 0...devProgressList.count - 1 {
            if let imageLink = devProgressList[i].imageURL {
                getImage(imageUrl: imageLink, token: self.token!) { (image) in
                    iteration = iteration + 1
                    self.devProgressList[i].image = image
                    if (iteration == self.devProgressList.count) {
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
    
}

extension DeveloperListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devProgressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dev_cell", for: indexPath) as! DeveloperTableViewCell
        cell.selectionStyle = .none
        cell.developerName.text = devProgressList[indexPath.row].name
        cell.doneProgressLabel.text = "\(devProgressList[indexPath.row].done)"
        cell.doingProgessLabel.text = "\(devProgressList[indexPath.row].doing)"
        cell.remainningProgessLabel.text = "\(devProgressList[indexPath.row].new)"
        cell.imageView?.layer.cornerRadius = 30
        cell.imageView?.clipsToBounds = true
        if let image = resizeImage(image: devProgressList[indexPath.row].image!, newWidth: 60) {
            cell.imageView?.image = image
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dev_vc = storyboard?.instantiateViewController(withIdentifier: "dev_vc") as! DeveloperViewController
        let dev = devProgressList[indexPath.row]
        let teamMemberTFS = TeamMemberTFS(name: dev.name!, imageURL: dev.imageURL ?? "", image: dev.image!)
        let taskProgress = TaskProgress(complete: dev.done, doing: dev.doing, new: dev.new)
        var tasks:[WorkItemFromTFS] = []
        var bugs:[WorkItemFromTFS] = []
        for task in dev.workItemList! {
            if task.type == "Task" {
                tasks.append(task)
            } else if task.type == "Bug" {
                bugs.append(task)
            }
        }
        dev_vc.dev = MemberTaskInformation(teamMember: teamMemberTFS,
                                           taskProgress: taskProgress,
                                           task: tasks,
                                           bug: bugs)
        navigationController?.pushViewController(dev_vc, animated: true)
    }
    
}

