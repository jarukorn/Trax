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
    var projects : [Project]?
    
    
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
        
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        let url = "http://traxtfsapi.azurewebsites.net/trax/getprojectlist?userid=\(userID)&accountname=\(accountName!)"
        let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        print(safeURL!)
        Alamofire.request(safeURL!).responseJSON { (response) in
            do {
                let projectList = try JSONDecoder().decode([Project].self, from: response.data!)
                self.projects = projectList
                print("pass")
                self.tableView.reloadData()
                self.activityView.stopAnimating()
            } catch {
                print("error")
            }
        }.resume()
    }
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        
        if let project = projects?[indexPath.row] {
            cell.selectionStyle = .none
            cell.projectName.text = project.ProjectName! + " Project"
            if let taskProgress = project.TaskProgress {
                cell.inCompleteLabel.text = "\(taskProgress.DueTask!) New"
                cell.inProgressLabel.text = "\(taskProgress.DoingTask!) Doing"
                cell.completeLabel.text = "\(taskProgress.DoneTask!) Done"
                DispatchQueue.main.async {
                    let chart = VBPieChart()
                    chart.holeRadiusPrecent = 0
                    cell.graphView.addSubview(chart)
                    chart.frame = CGRect(x: 0 , y: 50, width: 240*0.7, height: 180*0.7)
                    let chartValues = [ ["name":"first", "value": taskProgress.DoneTask ?? 0, "color":UIColor(hexString:"#33AD5F")],
                                        ["name":"second", "value": taskProgress.DueTask ?? 0, "color":UIColor(hexString:"#808080")],
                                        ["name":"third", "value": taskProgress.DoingTask ?? 0, "color":UIColor(hexString:"#FECA5D")]]
                    chart.setChartValues(chartValues as [AnyObject], animation:false)
                }
            }
            var imageList = [UIImage?]()
            
            if let teamMemberList = project.TeamMembers?.Value {
                for member in teamMemberList {
                    if let decodedData = Data(base64Encoded: member.ImageUrl!, options: .ignoreUnknownCharacters) {
                        let image = UIImage(data: decodedData)
                        imageList.append(image)
                    } else {
                        imageList.append(nil)
                    }
                }
                
                if (imageList.count > 4) {
                    cell.managerImageView.image = imageList[0]
                    cell.dev1ImageView.image = imageList[1]
                    cell.dev2ImageView.image = imageList[2]
                    cell.dev3ImageView.image = #imageLiteral(resourceName: "Plus")
                } else {
                    switch imageList.count {
                    case 1:
                        cell.managerImageView.image = imageList[0]
                        cell.dev1ImageView.image = nil
                        cell.dev2ImageView.image = nil
                        cell.dev3ImageView.image = nil
                    case 2:
                        cell.managerImageView.image = imageList[0]
                        cell.dev1ImageView.image = imageList[1]
                        cell.dev2ImageView.image = nil
                        cell.dev3ImageView.image = nil
                    case 3:
                        cell.managerImageView.image = imageList[0]
                        cell.dev1ImageView.image = imageList[1]
                        cell.dev2ImageView.image = imageList[2]
                        cell.dev3ImageView.image = nil
                    case 4:
                        cell.managerImageView.image = imageList[0]
                        cell.dev1ImageView.image = imageList[1]
                        cell.dev2ImageView.image = imageList[2]
                        cell.dev3ImageView.image = imageList[3]
                    default:
                        break
                    }
                    
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
        nextScreen.workItemList = projects?[indexPath.row].TaskProgress?.WorkItemList
        nextScreen.teamMembers =  projects?[indexPath.row].TeamMembers
        nextScreen.projectName = projects?[indexPath.row].ProjectName
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
}

