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

let apiVersion = "2.0"

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

func get64(token:String) -> String {
    
    let loginData = String(format: "%@:%@", "", "\(token)").data(using: String.Encoding.utf8)!
    let base64LoginData = loginData.base64EncodedString()
    
    return base64LoginData
}

