//
//  API.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 30/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation
import Alamofire

let url = URL(string: "https://traxapplication.visualstudio.com/DefaultCollection/")
let apiVersion = "2.0"

struct ProjectFromTFS {
    var id: String?
    var name: String?
}

func getProjectList(result: @escaping ([ProjectFromTFS]) -> Void) {
    
    var projectList = [ProjectFromTFS]()
    let headers: HTTPHeaders = ["Authorization": "Basic Om90dGw1d2xlc2U1dmJwZWV1Y2oyNHJrZnVkYTN5Y3ljdWJ4Zmh6c25qejRzNGxoM3RieWE="]
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

//
//"\(url)_apis/projects?api-version=\(apiVersion)"
