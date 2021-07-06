//
//  ApiCaller.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case internetDisconnected
}

/**
 Singleton APIManger
 */
class ApiManager {
    typealias ScorebatResulst = ((Result<[ScorebatModel], Error>) -> ())
    
    private static var instant : ApiManager?
    private var decoder = JSONDecoder()
    private var session = URLSession.shared
    
    private init(){}
    
    public static func shared() -> ApiManager {
        if let instant = self.instant {
            return instant
        }
        else {
            self.instant = ApiManager()
            return self.instant!
        }
    }
    
    func sendRequest(with url : String, completion: @escaping ScorebatResulst) -> Void {
        guard let url = URL(string: url) else {
            return
        }
        
        let task = self.session.dataTask(with: url) { data, response, error in
            if let e = error {
                completion(.failure(e))
                return
            }
            
            do {
                var resuls = [ScorebatModel]()
                let dataJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                for data in (dataJson as! [AnyObject]) {
                    resuls.append(ScorebatModel(with: data as! [String : Any]))
                }
                completion(.success(resuls))
                
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
