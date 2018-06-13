//
//  API.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 30/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct ProjectFromTFS {
    var id: String?
    var name: String?
    var task: [WorkItemFromTFS]?
    var teamList: [TeamMemberTFS]?
    var taskProgress = TaskProgress()
}

struct TaskProgress {
    var complete = 0
    var doing = 0
    var new = 0
}

struct Account {
    var id: String?
    var name: String?
}

struct TeamMemberTFS {
    var name:String
    var imageURL: String
    var image: UIImage?
}

struct WorkItemFromTFS {
    var ID: Int?
    var type: String?
    var title: String?
    var description: String?
    var assignedTo: String?
    var state: String?
    var createdDate: String?
    var createBy: String?
    var priority: Int?
    var projectName: String?
    var comment: [CommentFromTFS]?
    
    var stateValue: Int {
        if state == "New" {
            return 0
        } else if state == "To Do" {
            return 1
        } else if state == "Active" {
            return 2
        } else if state == "In Progress" {
            return 3
        } else if state == "Done" {
            return 4
        } else if state == "Closed" {
            return 5
        }
        return 10
    }
    
}

struct CommentFromTFS {
    var commenterName: String?
    var description: String?
    var imageURL: String?
    var CreatedDateTime: String?
}

let apiVersion = "2.0"

func get64(token:String) -> String {
    
    let loginData = String(format: "%@:%@", "", "\(token)").data(using: String.Encoding.utf8)!
    let base64LoginData = loginData.base64EncodedString()
    
    return base64LoginData
}

func getProjectList(accountName: String, token: String, result: @escaping ([ProjectFromTFS]) -> Void) {
    let url = URL(string: "https://\(accountName).visualstudio.com/DefaultCollection/_apis/projects?api-version=\(apiVersion)")
    var projectList = [ProjectFromTFS]()
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    Alamofire.request(url!, headers: headers).responseJSON { (response) in
        if (response.result.value != nil) {
            if let json = response.result.value as? [String:AnyObject] {
                let value = json["value"] as? [[String:AnyObject]]
                for obj in value! {
                    let id = obj["id"] as? String
                    let name = obj["name"] as? String
                    let projectTemp = ProjectFromTFS(id: id, name: name, task: [WorkItemFromTFS](), teamList: [TeamMemberTFS](), taskProgress: TaskProgress())
                    projectList.append(projectTemp)
                }
                result(projectList)
            }
        }
    }.resume()
}

func getWorkItemNumber(accountName: String, projectName: String,token : String, resume: @escaping ([Int]) -> Void) {
    let url = "https://\(accountName).visualstudio.com/DefaultCollection/\(projectName)/_apis/wit/wiql?api-version=1.0"
    print(url)
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let pjson =
    """
    {
    "query": "Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.WorkItemType] = 'Task' and [System.TeamProject] = '\(projectName)' or [System.WorkItemType] = 'Bug' and [System.TeamProject] = '\(projectName)' "
    }
    """
    let data = (pjson.data(using: .utf8))! as Data
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    request.httpMethod = "POST"
    request.httpBody = data
    request.allHTTPHeaderFields = headers
    
    Alamofire.request(request).responseJSON { (response) in
        if let json = response.result.value as? [String:AnyObject] {
            if let workItems = json["workItems"] as? [[String:AnyObject]] {
                var workItemList = [Int]()
                for i in workItems {
                    if let id = i["id"] as? Int {
                        workItemList.append(id)
                    }
                }
                resume(workItemList)
            }
        }
    }
}



func getTaskFromWorkItemID(token: String, id: String, accountName: String,resume: @escaping ([WorkItemFromTFS]) -> Void) {
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    print("https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/WorkItems?ids=\(id)")
    Alamofire.request("https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/WorkItems?ids=\(id)",headers: headers).responseJSON { (response) in
        if let json = response.result.value as? [String:AnyObject] {
            if let value = json["value"] as? [[String:AnyObject]] {
                var workItemList = [WorkItemFromTFS]()
                for workItem in value {
                    if let fields = workItem["fields"] as? [String:AnyObject] {
                        let id = workItem["id"] as? Int
                        let projectName = fields["System.TeamProject"] as? String
                        let workItemType = fields["System.WorkItemType"] as? String
                        let state = fields["System.State"] as? String
                        let assignTo = fields["System.AssignedTo"] as? String
                        let createDate = fields["System.CreatedDate"] as? String
                        let title = fields["System.Title"] as? String
                        let description = fields["System.Description"] as? String
                        let createBy = fields["System.CreatedBy"] as? String
                        let priority = fields["Microsoft.VSTS.Common.Priority"] as? Int
                        
                        let workItemTemp = WorkItemFromTFS(ID: id, type: workItemType, title: title, description: description, assignedTo: assignTo, state: state, createdDate: createDate, createBy: createBy, priority: priority, projectName: projectName, comment: [CommentFromTFS]())
                        
                        workItemList.append(workItemTemp)
                    }
                }
                resume(workItemList)
            }
        }
        }.resume()
}

func getComment(accountName:String, token:String, task: WorkItemFromTFS, resume: @escaping ([CommentFromTFS]) -> Void) {
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    let group = DispatchGroup()
    Alamofire.request("https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/workItems/\(task.ID!)/comments",headers: headers).responseJSON { (response) in
        group.enter()
        print("https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/workItems/\(task.ID!)/comments")
        if let json = response.result.value as? [String:AnyObject] {
            if let comments = json["comments"] as? [[String:AnyObject]] {
                var commentList = [CommentFromTFS]()
                for comment in comments {
                    if let revisedBy = comment["revisedBy"] as? [String:AnyObject] {
                        let description = comment["text"] as? String
                        let commenterName = revisedBy["displayName"] as? String
                        let imageURL = revisedBy["imageUrl"] as? String
                        let createDate = comment["revisedDate"] as? String
                        let commentTemp = CommentFromTFS(commenterName: commenterName, description: description, imageURL: imageURL, CreatedDateTime: createDate)
                        commentList.append(commentTemp)
                    }
                }
                resume(commentList)
            }
        }
        }.resume()
}


func completeWorkItem(accountName: String, token: String,witID: Int, result: @escaping (Bool) -> Void) {
    let urltfs = "https://\(accountName).visualstudio.com/_apis/wit/workitems/\(witID)?api-version=\(apiVersion)"
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)", "Content-Type": "application/json-patch+json"]
    let json = """
    [ { "op": "add",
        "path": "/fields/System.State",
        "value": "Closed" } ]
    """
    let url = URL(string: urltfs)!
    let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = headers
    request.httpMethod = "PATCH"
    request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    Alamofire.request(request).responseJSON{(response) in
        if (response.result.value != nil) {
            if let json = response.result.value as? [String:AnyObject] {
                if let value = json["fields"] as? [String:AnyObject] {
                    let state = value["System.State"] as? String
                    if (state == "Closed") {
                        result(true)
                    } else {
                        result(true)
                    }
                }
            } else {
                result(true)
            }
        } else {
            result(true)
        }
        }.resume()
}

func getTeamMember(accountName: String, token: String, projectID: String, teamID:String, result: @escaping ([TeamMemberTFS]) -> Void ) {
    let url = URL(string: "https://\(accountName).visualstudio.com/DefaultCollection/_apis/projects/\(projectID)/teams/\(teamID)/members?")
    var teamMemberList = [TeamMemberTFS]()
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    Alamofire.request("\(url!)api-version=\(apiVersion)", headers:headers).responseJSON { (response) in
        if (response.result.value != nil) {
            if let json = response.result.value as? [String:AnyObject] {
                let value = json["value"] as? [[String:AnyObject]]
                for obj in value! {
                    let name = obj["displayName"] as? String
                    let image = obj["imageUrl"] as? String
                    let member = TeamMemberTFS(name: name!, imageURL:image!, image: nil)
                    teamMemberList.append(member)
                }
                result(teamMemberList)
            } else {
                
            }
        } else {
            
        }
        }.resume()
}

func getImage(imageUrl: String,token: String, result: @escaping (UIImage) -> Void) {
    let url = URL(string: imageUrl)
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    var tfs = UIImage()
    Alamofire.request(url!, method:.get, headers: headers).responseImage { response in
        
        if let image = response.result.value {
            tfs = image
        } else {
            tfs = #imageLiteral(resourceName: "user")
        }
        
        result(tfs)
        }.resume()
}

func getTeamID(accountName: String,token:String,projectID:String,result: @escaping (String) -> Void)  {
    let url = URL(string: "https://\(accountName).visualstudio.com/DefaultCollection/_apis/projects/\(projectID)/teams?")
    let base64LoginData = get64(token: token)
    let headers : HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    print(url!)
    Alamofire.request("\(url!)api-version=\(apiVersion)", headers: headers).responseJSON { (response) in
        if (response.result.value != nil) {
            if let json = response.result.value as? [String:AnyObject] {
                if let value = json["value"] as? [[String:AnyObject]] {
                    let value1 = value[0]
                    let teamID = value1["id"] as? String
                    result(teamID!)
                }
            }
        }
        }.resume()
}


//Not Use
func getAccountList(tfs_id: String, token: String, resume: @escaping ([Account]) -> Void)  {
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    
    Alamofire.request("https://app.vssps.visualstudio.com/_apis/Accounts?memberId=\(tfs_id)&api-version=3.2-preview",headers: headers).responseJSON { (response) in
        var accountList = [Account]()
        if let json = response.result.value as? [String:AnyObject] {
            if let value = json["value"] as? [[String:AnyObject]] {
                for account in value {
                    let accountID = account["accountId"] as? String
                    let accountName = account["accountName"] as? String
                    let accountTemp = Account(id: accountID, name: accountName)
                    accountList.append(accountTemp)
                }
                resume(accountList)
            }
        }
        }.resume()
}

func getTodayTask(accountName:String, developerName: String, token : String, resume: @escaping ([Int]) -> Void) {
    let url = URL(string: "https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/wiql?api-version=1.0")
    var request = URLRequest(url: url!)
    let pjson =
    """
    {
    "query": "Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.WorkItemType] = 'Task' and [System.AssignedTo] = '\(developerName)' or [System.WorkItemType] = 'Bug' and [System.AssignedTo] = '\(developerName)' "
    }
    """
    let data = (pjson.data(using: .utf8))! as Data
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    
    request.httpMethod = HTTPMethod.post.rawValue
    request.httpMethod = "POST"
    request.httpBody = data
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.allHTTPHeaderFields = headers
    Alamofire.request(request).responseJSON { (response) in
        if let json = response.result.value as? [String:AnyObject] {
            if let workItems = json["workItems"] as? [[String:AnyObject]] {
                var workItemList = [Int]()
                for i in workItems {
                    if let id = i["id"] as? Int {
                        workItemList.append(id)
                    }
                }
                resume(workItemList)
            }
        }
        }.resume()
    
}

struct TeamList {
    var projectID: String?
    var teamID: String?
}

func getTeamList(accountName: String, token: String, result: @escaping ([TeamList]) -> Void ) {
    let url = URL(string: "https://\(accountName).visualstudio.com/_apis/teams?api-version=4.1-preview.2")
    var teamList = [TeamList]()
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    Alamofire.request(url!, headers:headers).responseJSON { (response) in
        if (response.result.value != nil) {
            if let json = response.result.value as? [String:AnyObject] {
                let value = json["value"] as? [[String:AnyObject]]
                for obj in value! {
                    let projectID = obj["projectId"] as? String
                    let teamid = obj["id"] as? String
                    let member = TeamList(projectID: projectID, teamID: teamid)
                    teamList.append(member)
                }
                result(teamList)
            } else {
                
            }
        } else {
            
        }
        }.resume()
}

func getWorkItemOfEachDev(accountName: String, devName: String,token : String, resume: @escaping ([Int]) -> Void) {
    let url = "https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/wiql?api-version=1.0"
    print(url)
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let pjson = """
    {
    "query": "Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.WorkItemType] = 'Task'  and [System.AssignedTo] = '\(devName)' or [System.WorkItemType] = 'Bug' and [System.AssignedTo] = '\(devName)' " }
    """
    let data = (pjson.data(using: .utf8))! as Data
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    request.httpMethod = "POST"
    request.httpBody = data
    request.allHTTPHeaderFields = headers
    
    Alamofire.request(request).responseJSON { (response) in
        if let json = response.result.value as? [String:AnyObject] {
            if let workItems = json["workItems"] as? [[String:AnyObject]] {
                var workItemList = [Int]()
                for i in workItems {
                    if let id = i["id"] as? Int {
                        workItemList.append(id)
                    }
                }
                resume(workItemList)
            }
        }
    }
}
