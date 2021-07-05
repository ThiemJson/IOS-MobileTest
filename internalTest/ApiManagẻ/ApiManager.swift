//
//  ApiCaller.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import Foundation

class ApiManager {
    private static var instant : ApiManager?
    private var decoder = JSONDecoder()
    typealias ScorebatResulst = ((Result<[ScorebatModel], Error>) -> ())
    
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
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let e = error {
                print(e)
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
