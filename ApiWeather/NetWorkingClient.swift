
//  NetWorkingClient.swift
//  ApiWeather
//
//  Created by Mohamed on 9/24/19.
//  Copyright © 2019 Mohamed. All rights reserved.
//

import Foundation
import Alamofire
 
final class NetWorkingClient {
    
    // MARK:  Typealias
    
    typealias WebServiceResponse = ([[String: Any]]? , Error?) -> Void
    
    // MARK: Helper
    
    func execute(_url: URL , completion: @escaping WebServiceResponse) {
        Alamofire.request(_url).validate().responseJSON { response in
            if let erorr = response.error{
                completion(nil , erorr)
            } else if let jsonArray = response.result.value as? [String: Any] {
                let json = jsonArray["list"] as! [[String:Any]]
               completion (json , nil)
            }
        }
    }
}
