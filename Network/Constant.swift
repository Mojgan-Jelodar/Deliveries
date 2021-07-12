//
//  Constant.swift
//  DataReader
//
//  Created by mozhgan on 11/6/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import Foundation
//Active Compilation Conditions
#if DEBUG
let apiEnv: APIEnvironment = .debug
#else
let apiEnv: APIEnvironment = .production
#endif


enum APIEnvironment {
    case production
    case debug
    
    var string: String
    {
        switch self
        {
            case .production:
                return "https://mock-api-mobile.dev.lalamove.com"
            case .debug:
                return "http://localhost:8080"
            
        }
    }
}


enum Endpoints
{
    case deliveries
    
    var string: String
    {
        switch self
        {
            case .deliveries: return "/deliveries"
        }
    }
}



