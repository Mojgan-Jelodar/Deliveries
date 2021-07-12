//
//  File.swift
//  DataReader
//
//  Created by mozhgan on 11/6/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import Alamofire




final class Network {
    
    
    private var url: String
    
    private var manager: SessionManager {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.retrier = self
        return manager
    }
    
    /// in this class you just set the root url and then you can call every endpoints with every http method  you need
    ///
    /// - Parameter url: this is your base url
    required init(url: String) {
        self.url = url
    }
    
    
    

    func get(at route: Endpoints, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .get,
            params: params,
            encoding: URLEncoding.queryString)
    }
    
    func post(at route: Endpoints, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .post,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    func put(at route: Endpoints, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .put,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    private func request(at route: Endpoints, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding) -> DataRequest
    {
        let path = url + route.string
        return manager.request(
            path,
            method: method,
            parameters: params,
            encoding: encoding).validate(statusCode: 200..<300)
    }
}




extension Network : RequestRetrier
{
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion)
    {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 500
         {
               completion(true, 1.0)
         }
         else
         {
               completion(false, 0.0)
         }
    }
    
    
}
