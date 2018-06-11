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
        var new = 0
        var doing = 0
        var done = 0
        var workItemList: [WorkItemFromTFS]?
    }
    
    //    var myDevList: [MyDeveloperList]?

    var projectListFinal = [ProjectFromTFS]()
    var tempTeamMember = [TeamMemberTFS]()
    var teamMember = [TeamMemberTFS]()
    var devProgress = [DevProgress]()
    var todayTask: [WorkItemFromTFS]?
    var tasks = [WorkItemFromTFS]()
    var bugs = [WorkItemFromTFS]()
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
        tasks = []
        bugs = []
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
                            if task.type == "Task" {
                                self.tasks.append(task)
                            } else if task.type == "Bug" {
                                self.bugs.append(task)
                            }
                            progress.name = member.name
                            progress.imageURL = member.imageURL
                            progress.workItemList = workItems
                           
                        }
                        if iteration4 == self.teamMember.count && iteration5 == workItemNumberList.count {
                            print(self.tasks)
                            self.modifyPresenter()
                        }
                        
                    })
                } else {
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                }
            }
        }
    }
    
    func modifyPresenter() {
        print(tasks.count)
        print(bugs.count)
        print(teamMember.count)
//        for k in workItems {
//            if (k.state == "New") {
//                progress.new = progress.new + 1
//            } else if(k.state == "To Do") {
//                progress.new = progress.new + 1
//            } else if(k.state == "In Progress") {
//                progress.doing = progress.doing + 1
//            } else if(k.state == "Active") {
//                progress.doing = progress.doing + 1
//            } else if(k.state == "Done") {
//                progress.done = progress.done + 1
//            } else if(k.state == "Closed") {
//                progress.done = progress.done + 1
//            }
//        }
//        if self.devProgress.count == 0 {
//            self.devProgress.append(progress)
//        } else {
//            for i in 0...self.devProgress.count - 1 {
//                if member.name == self.devProgress[i].name {
//                    self.devProgress[i].done = self.devProgress[i].done + progress.done
//                    self.devProgress[i].doing = self.devProgress[i].doing + progress.doing
//                    self.devProgress[i].new = self.devProgress[i].new + progress.new
//                } else {
//                    self.devProgress.append(progress)
//                }
//            }
//        }
//        if iteration4 == self.teamMember.count && iteration6 == (self.todayTask?.count)! {
//            self.tableView.reloadData()
//            self.activityView.stopAnimating()
//        }
    }
    
    
    
//    func getDevList() {
//        let account = UserDefaults.standard.string(forKey: "accountName")
//        let token = UserDefaults.standard.string(forKey: "Token")
//        getTeamList(accountName: account!, token: token!) { (teams) in
//            print(teams.count)
//            var interationA = 0
//            var interationB = 0
//            for i in teams {
//                interationA = interationA + 1
//                getTeamMember(accountName: account!, token: token!, projectID: i.projectID!, teamID: i.teamID!) { (memberList) in
//                    //                    print(memberList.count)
//                    //                    self.teamMember.append(contentsOf: memberList)
//                    //                    print(self.teamMember.count)
//                    //                    self.tableView.reloadData()
//                    for j in memberList {
//                        interationB = interationB + 1
//                        getWorkItemOfEachDev(accountName: account!, devName: j.name, token: token!) { (workItemArray) in
//                            print("workItem: \(workItemArray.count)")
//                            var workItemStr = ""
//                            print(workItemArray.count)
//                            if workItemArray.count != 0 {
//                                for j in 0...workItemArray.count-1 {
//                                    workItemStr = workItemStr + "\(workItemArray[j])"
//                                    if (j != workItemArray.count-1) {
//                                        workItemStr = workItemStr + ","
//                                    }
//                                }
//                                getTaskFromWorkItemID(token: token!, id: workItemStr, accountName: account!, resume: { (workItems) in
//                                    var progress = DevProgress()
//                                    progress.name = j.name
//                                    progress.imageURL = j.imageURL
//                                    progress.workItemList = workItems
//                                    for k in workItems {
//                                        if (k.state == "New") {
//                                            progress.new = progress.new + 1
//                                        } else if(k.state == "Active") {
//                                            progress.doing = progress.doing + 1
//                                        } else if(k.state == "Closed") {
//                                            progress.done = progress.done + 1
//                                        }
//                                    }
//                                    self.devProgress.append(progress)
//                                    if interationA == teams.count-1 && interationB == workItemArray.count - 1 {
//                                        self.tableView.reloadData()
//                                    }
//                                })
//                            } else {
//                                self.tableView.reloadData()
//                                self.activityView.stopAnimating()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        //        for i in projects {
//        //
//        //            getTeamID(accountName: account!, token: token!, projectID: i.id!) { (teamID) in
//        //                print(teamID)
//        //                getTeamMember(accountName: account!, token: token!, projectID: i.id!, teamID: teamID) { (memberList) in
//        //                    print(memberList.count)
//        //                    self.teamMember.append(contentsOf: memberList)
//        //                    print(self.teamMember.count)
//        //                    self.tableView.reloadData()
//        //                }
//        //            }
//        //        }
//    }
//
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
        let dev = devProgress
        print(dev.count)
        return dev.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dev_cell", for: indexPath) as! DeveloperTableViewCell
        cell.selectionStyle = .none
        let progress = devProgress
        cell.developerName.text = progress[indexPath.row].name
        print(cell.developerName.text ?? 0)
        cell.doingProgessLabel.text = String(progress[indexPath.row].doing)
        cell.remainningProgessLabel.text = String(progress[indexPath.row].new)
        let token = UserDefaults.standard.string(forKey: "Token")
        getImage(imageUrl: progress[indexPath.row].imageURL!, token: token!) { (image) in
            cell.developerPic.image = image
            self.devImageList.append(image)
        }
        
        
        
        
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

