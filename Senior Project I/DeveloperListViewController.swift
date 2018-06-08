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
    var devImageList = [UIImage]()
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var projectListFinal = [ProjectFromTFS]()
    var teamMember = [TeamMemberTFS]()
    var devProgress = [DevProgress]()
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
        getDevList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func getDevList() {
        let account = UserDefaults.standard.string(forKey: "accountName")
        let token = UserDefaults.standard.string(forKey: "Token")
        getTeamList(accountName: account!, token: token!) { (teams) in
            print(teams.count)
            var interationA = 0
            var interationB = 0
            for i in teams {
                interationA = interationA + 1
                getTeamMember(accountName: account!, token: token!, projectID: i.projectID!, teamID: i.teamID!) { (memberList) in
                    //                    print(memberList.count)
                    //                    self.teamMember.append(contentsOf: memberList)
                    //                    print(self.teamMember.count)
                    //                    self.tableView.reloadData()
                    for j in memberList {
                        interationB = interationB + 1
                        getWorkItemOfEachDev(accountName: account!, devName: j.name, token: token!) { (workItemArray) in
                            print("workItem: \(workItemArray.count)")
                            var workItemStr = ""
                            print(workItemArray.count)
                            if workItemArray.count != 0 {
                                for j in 0...workItemArray.count-1 {
                                    workItemStr = workItemStr + "\(workItemArray[j])"
                                    if (j != workItemArray.count-1) {
                                        workItemStr = workItemStr + ","
                                    }
                                }
                                getTaskFromWorkItemID(token: token!, id: workItemStr, accountName: account!, resume: { (workItems) in
                                    var progress = DevProgress()
                                    progress.name = j.name
                                    progress.imageURL = j.imageURL
                                    progress.workItemList = workItems
                                    for k in workItems {
                                        if (k.state == "New") {
                                            progress.new = progress.new + 1
                                        } else if(k.state == "Active") {
                                            progress.doing = progress.doing + 1
                                        } else if(k.state == "Closed") {
                                            progress.done = progress.done + 1
                                        }
                                    }
                                    self.devProgress.append(progress)
                                    if interationA == teams.count-1 && interationB == workItemArray.count - 1 {
                                        self.tableView.reloadData()
                                    }
                                })
                            } else {
                                self.tableView.reloadData()
                                self.activityView.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
        //        for i in projects {
        //
        //            getTeamID(accountName: account!, token: token!, projectID: i.id!) { (teamID) in
        //                print(teamID)
        //                getTeamMember(accountName: account!, token: token!, projectID: i.id!, teamID: teamID) { (memberList) in
        //                    print(memberList.count)
        //                    self.teamMember.append(contentsOf: memberList)
        //                    print(self.teamMember.count)
        //                    self.tableView.reloadData()
        //                }
        //            }
        //        }
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

