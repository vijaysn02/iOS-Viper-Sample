//
//  ServiceInteractionHandler.swift
//  API Master
//
//  Created by TPFLAP146 on 04/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Service Interaction - Generic
class ServiceInteraction {
    
    static func apiCall(urlString:String,httpMethod:APIMethod,foregroundAPICall:Bool,parameters:Dictionary<String, String>?,completionBlock: @escaping (Data) -> Void) -> Void
    {
        
        
        if !Reachability.isInternetAvailable() {
            return
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod.description
        
        //Passing Parameter
        if httpMethod != .GET {
            if let param = parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
            } else {
                print("Pass body parameter")
            }
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(Constants.URLS.HEADER_VALUE, forHTTPHeaderField: Constants.URLS.HEADER_KEY)
        
        //API Time Out
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = Constants.ApplicationGenerics.APIs.MINIMUM_TIMEOUT
        session.configuration.timeoutIntervalForResource = Constants.ApplicationGenerics.APIs.MINIMUM_TIMEOUT
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            guard let data = data else {
                return
            }
            completionBlock(data)
        })
        task.resume()
    }
    
}


//MARK: - HTTP Method
enum APIMethod {
    
    case GET
    case POST
    case PUT
    case DELETE
    
    var description : String {
     
        switch self {
      
      case .GET: return "GET"
      case .POST: return "POST"
      case .PUT: return "PUT"
      case .DELETE: return "DELETE"
      }
        
    }
    
}



