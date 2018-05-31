//
//  API.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 30/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation
import Alamofire

struct ProjectFromTFS {
    var id: String?
    var name: String?
}

struct Account {
    var id: String?
    var name: String?
}

let apiVersion = "2.0"

func get64(token:String) -> String {
    
    let loginData = String(format: "%@:%@", "", "\(token)").data(using: String.Encoding.utf8)!
    let base64LoginData = loginData.base64EncodedString()
    
    return base64LoginData
}

func getProjectList(accountName: String,token:String,result: @escaping ([ProjectFromTFS]) -> Void) {
    let url = URL(string: "https://\(accountName).visualstudio.com/DefaultCollection/")
    var projectList = [ProjectFromTFS]()
    
    let base64LoginData = get64(token: token)
    
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    Alamofire.request("\(url!)_apis/projects?api-version=\(apiVersion)",headers: headers).responseJSON { (response) in
        if (response.result.value != nil) {
            if let json = response.result.value as? [String:AnyObject] {
                let value = json["value"] as? [[String:AnyObject]]
                for obj in value! {
                    let id = obj["id"] as? String
                    let name = obj["name"] as? String
                    let projectTemp = ProjectFromTFS(id: id, name: name)
                    projectList.append(projectTemp)
                }
                result(projectList)
            } else {

            }

        } else {

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
    }
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
  "query": "Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.WorkItemType] = 'Task' and [System.TeamProject] = 'myfirstproject' or [System.WorkItemType] = 'Bug' and [System.TeamProject] = 'myfirstproject' "
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
}

struct CommentFromTFS {
    var commenterName: String?
    var description: String?
    var imageURL: String?
    var CreatedDateTime: String?
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
    }
}

// Fixing
func getComment(accountName:String, token:String, tasks: [WorkItemFromTFS], resume: @escaping ([WorkItemFromTFS]) -> Void) {
    let base64LoginData = get64(token: token)
    let headers: HTTPHeaders = ["Authorization": "Basic \(base64LoginData)"]
    var workitemList = tasks
    
    for i in 0...tasks.count-1 {
        Alamofire.request("https://\(accountName).visualstudio.com/DefaultCollection/_apis/wit/workItems/\(tasks[i].ID!)/comments",headers: headers).responseJSON { (response) in
            var commentList = [CommentFromTFS]()
            if let json = response.result.value as? [String:AnyObject] {
                if let comments = json["comments"] as? [[String:AnyObject]] {
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
                    workitemList[i].comment = commentList
                }
            }
        }.resume()
    }
   resume(workitemList)
}

