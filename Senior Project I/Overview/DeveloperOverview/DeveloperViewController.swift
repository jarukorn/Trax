//
//  DeveloperViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 28/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
class DeveloperViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var devImageView: UIImageView!
    @IBOutlet weak var devNameLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var doingLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!

    var dev : Developer?
    var devImage : UIImage?
    var workList: WorkItemList?
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Developer Overview"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        devNameLabel.text = dev!.DisplayName ?? ""
        devImageView.image = devImage
        doneLabel.text = "\(dev?.Done ?? 0)"
        doingLabel.text = "\(dev?.Doing ?? 0)"
        leftLabel.text = "\(dev?.Due ?? 0)"
        if (dev?.WorkItemIDs != nil) {
            fetch()
        }
    }
    
    func fetch() {
        activityView.startAnimating()
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        let url = "http://traxtfsapi.azurewebsites.net/trax/getworkItemlist?workitemlist=\(dev!.WorkItemIDs!)&userid=\(userID)&accountName=\(accountName!)"
        let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(safeURL!).responseJSON { (response) in
            do {
                let workList = try JSONDecoder().decode(WorkItemList.self, from: response.data!)
                self.workList = workList
                print("pass")
                self.tableViewList.reloadData()
                self.activityView.stopAnimating()
            } catch {
                print("error")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return workList?.TaskList?.count ?? 0
        case 1:
            return workList?.BugList?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segmentControl.selectedSegmentIndex {
        case 0,1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell", for: indexPath) as! TaskTableViewCell
            cell.selectionStyle = .none
            var taskandBugInstance = WorkItem()
            switch segmentControl.selectedSegmentIndex {
            case 0:
                taskandBugInstance = (workList?.TaskList![indexPath.row])!
            case 1:
                taskandBugInstance = (workList?.BugList![indexPath.row])!
            default:
                break
            }
            
            cell.devPic.image = devImage
            
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
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = workList?.TaskList?[indexPath.row]
            vc.navigationItem.title = "Task Detail"
            vc.devImage = devImage ?? nil
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = workList?.BugList?[indexPath.row]
            vc.navigationItem.title = "Bug Detail"
            vc.devImage = devImage ?? nil
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func changedSegment(_ sender: Any) {
        tableViewList.reloadData()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
