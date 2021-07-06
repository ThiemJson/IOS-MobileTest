//
//  ScorebatModel.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import Foundation

struct ScorebatModel : Decodable {
    var title : String
    var embed : String
    var url : String
    var thumbnail: String
    var date : Date
    var competition : Competition
    
    init(with json: [String : Any]){
        self.title = json["title"] as? String ?? "title"
        self.embed = json["embed"] as? String ?? "embed"
        self.url = json["url"] as? String ?? "url"
        self.thumbnail = json["thumbnail"] as? String ?? "thumbnail"
        self.date = Date.getDateFromStr(with: json["date"]! as! String)
        self.competition = Competition(with: json["competition"] as! [String : Any])
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
