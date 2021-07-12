//
//  DeliveryService.swift
//  DataReader
//
//  Created by mozhgan on 11/6/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import ObjectMapper

final class DeliveryService
{
    private lazy var agent : Network = {
        return Network(url: apiEnv.string)
    }()
    
    /// This method uses for getting a list of deliveries
    ///
    /// - Parameters:
    ///   - offset: This defines the strat point to fetch data
    ///   - limit: This defines the amount of records for every request
    ///   - successCallback: When the result of a request gets success this block is invoked
    ///   - failureCallback:  When the result of a request failure this block is invoked
    func deliveries(offset : Int,limit : Int,successCallback : @escaping ([Delivery]) -> Void ,failureCallback : @escaping (Error) -> Void)
    {
        agent.get(at: Endpoints.deliveries, params: ["offset" : offset,
                                                     "limit" : limit ]).responseString
        { (response) in
            switch response.result
            {
                case .failure(let error):
                      failureCallback(error)
                case .success(let body):
                    successCallback(Mapper<Delivery>().mapArray(JSONString: body) ?? [])
            }
        }
    }
}
