//
//  ScorebatModel.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import Foundation

struct ScorebatModel : Decodable {
    let title : String
    let embed : String
    let url : String
    let thumbnail: String
    let date : Date
    let competition : Competition
    
    init(with json: [String : Any]){
        title = json["title"] as? String ?? "title"
        embed = json["embed"] as? String ?? "embed"
        url = json["url"] as? String ?? "url"
        thumbnail = json["thumbnail"] as? String ?? "thumbnail"
        date = Date.getDateFromStr(with: json["date"]! as! String) 
        competition = Competition(with: json["competition"] as! [String : Any])
    }
}

struct Competition : Decodable {
    let name : String
    let url : String
    
    init(with json: [String: Any]){
        name = json["name"] as? String ?? "name"
        url = json["url"] as? String ?? "url"
    }
}
