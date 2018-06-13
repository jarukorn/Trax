//
//  SelectProjectViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var accountName: String?
    var projectListFinal = [ProjectFromTFS]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
        accountName = UserDefaults.standard.string(forKey: "accountName")
        fetch()

        if (accountName != nil) {
            navigationItem.title = accountName!
        } else {
            navigationItem.title = "Projects List"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func fetch() {
        let token = UserDefaults.standard.string(forKey: "Token")
        print(token!)
        var iteration = 0
        var iteration2 = 0
        var checker = 0
        getProjectList(accountName: self.accountName!, token: token!) { (projectList) in
            
            self.projectListFinal = projectList
            
            for i in 0...self.projectListFinal.count-1 {
                getWorkItemNumber(accountName: self.accountName!, projectName: self.projectListFinal[i].name!, token: token!, resume: { (workItemArray) in
                    var workItemStr = ""
                    print(workItemArray.count)
                    if workItemArray.count != 0 {
                        for j in 0...workItemArray.count-1 {
                            workItemStr = workItemStr + "\(workItemArray[j])"
                            if (j != workItemArray.count-1) {
                                workItemStr = workItemStr + ","
                            }
                        }
                        
                        getTaskFromWorkItemID(token: token!, id: workItemStr, accountName: self.accountName!, resume: { (workItems) in
                            self.projectListFinal[i].task = workItems
                        })
                        
                        getTeamID(accountName: self.accountName!, token: token!, projectID: projectList[i].id! , result: { (teamID) in
                            getTeamMember(accountName: self.accountName!, token: token!, projectID: projectList[i].id!, teamID: teamID, result: { (TeamMemberTemp) in
                                self.projectListFinal[i].teamList = TeamMemberTemp
                                
                                for k in 0...TeamMemberTemp.count-1 {
                                    DispatchQueue.main.async(execute: {
                                        getImage(imageUrl: TeamMemberTemp[k].imageURL, token: token!, result: { (Image) in
                                            iteration = iteration + 1
                                            self.projectListFinal[i].teamList![k].image = Image
                                            iteration2 = iteration2 + 1
//                                            if iteration2 == TeamMemberTemp.count {
                                                DispatchQueue.main.async(execute: {
                                                    self.tableView.reloadData()
                                                    self.activityView.stopAnimating()
                                                })
//                                            }
                                        })
                                    })
                                   
                                }
                            })
                        })
                    } else {
                        print("No work item.")
                    }
                })
            }
        }
    }
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectListFinal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        var project = projectListFinal[indexPath.row]
        var complete = 0
        var doing = 0
        var new = 0
        
        cell.selectionStyle = .none
        cell.projectName.text = project.name! + " Project"
        for task in project.task! {
            switch task.state {
            case "Done":
                complete = complete + 1
            case "Closed":
                complete = complete + 1
            case "In Progress":
                doing = doing + 1
            case "Active":
                doing = doing + 1
            case "To Do":
                new = new + 1
            case "New":
                new = new + 1
            case .some(_):
                break
            default:
                break
            }
        }
        
        project.taskProgress.complete = complete
        project.taskProgress.doing = doing
        project.taskProgress.new = new
        self.projectListFinal[indexPath.row].taskProgress = project.taskProgress
        cell.inCompleteLabel.text = "\(new) New"
        cell.inProgressLabel.text = "\(doing) Doing"
        cell.completeLabel.text = "\(complete) Done"
        let chart = VBPieChart()
        chart.holeRadiusPrecent = 0
        cell.graphView.addSubview(chart)
        if (complete == 0 && doing == 0 && new == 0) {
            chart.frame = CGRect(x: 0 , y: 50, width: 240*0.7, height: 180*0.7)
            let chartValues = [ ["name":"first", "value": 0, "color":UIColor(hexString:"#33AD5F")],
                                ["name":"second", "value": 10, "color":UIColor(hexString:"#808080")],
                                ["name":"third", "value": 0, "color":UIColor(hexString:"#FECA5D")]]
            chart.setChartValues(chartValues as [AnyObject], animation:false)
        } else {
            chart.frame = CGRect(x: 0 , y: 50, width: 240*0.7, height: 180*0.7)
            let chartValues = [ ["name":"first", "value": complete, "color":UIColor(hexString:"#33AD5F")],
                                ["name":"second", "value": new, "color":UIColor(hexString:"#808080")],
                                ["name":"third", "value": doing, "color":UIColor(hexString:"#FECA5D")]]
            chart.setChartValues(chartValues as [AnyObject], animation:false)
            
        }
        
        if (complete == 0 && doing == 0 && new == 0) {
            cell.managerImageView.image = nil
            cell.dev1ImageView.image = nil
            cell.dev2ImageView.image = nil
            cell.dev3ImageView.image = nil
        } else {
            if (self.projectListFinal[indexPath.row].teamList?.count)! > 4 {
                cell.managerImageView.image = projectListFinal[indexPath.row].teamList?[0].image
                cell.dev1ImageView.image = projectListFinal[indexPath.row].teamList?[1].image
                cell.dev2ImageView.image = projectListFinal[indexPath.row].teamList?[2].image
                cell.dev3ImageView.image = #imageLiteral(resourceName: "Plus")
                if (cell.managerImageView.image == nil || cell.dev1ImageView.image == nil || cell.dev2ImageView.image == nil || cell.dev3ImageView.image == nil) {
                    tableView.reloadData()
                }
            } else {
                switch (self.projectListFinal[indexPath.row].teamList?.count)! {
                case 1:
                    cell.managerImageView.image = projectListFinal[indexPath.row].teamList?[0].image
                    cell.dev1ImageView.image = nil
                    cell.dev2ImageView.image = nil
                    cell.dev3ImageView.image = nil
                case 2:
                    cell.managerImageView.image = projectListFinal[indexPath.row].teamList?[0].image
                    cell.dev1ImageView.image = projectListFinal[indexPath.row].teamList?[1].image
                    cell.dev2ImageView.image = nil
                    cell.dev3ImageView.image = nil
                case 3:
                    cell.managerImageView.image = projectListFinal[indexPath.row].teamList?[0].image
                    cell.dev1ImageView.image = projectListFinal[indexPath.row].teamList?[1].image
                    cell.dev2ImageView.image = projectListFinal[indexPath.row].teamList?[2].image
                    cell.dev3ImageView.image = nil
                case 4:
                    cell.managerImageView.image = projectListFinal[indexPath.row].teamList?[0].image
                    cell.dev1ImageView.image = projectListFinal[indexPath.row].teamList?[1].image
                    cell.dev2ImageView.image = projectListFinal[indexPath.row].teamList?[2].image
                    cell.dev3ImageView.image = projectListFinal[indexPath.row].teamList?[3].image
                default:
                    break
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextScreen = storyboard?.instantiateViewController(withIdentifier: "overview_vc") as! OverviewViewController
        nextScreen.project = self.projectListFinal[indexPath.row]
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
}



