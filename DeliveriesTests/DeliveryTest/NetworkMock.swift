//
//  File.swift
//  DataReaderTests
//
//  Created by m.jelodar on 11/9/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import ObjectMapper
@testable import Delivery

class NetworkMock {
    var result: Result
    typealias SuccessCallback = ([Delivery]) -> Void
    typealias FailureCallback = (Error) -> Void
    required  init(resultType: Result = .success) {
        self.result = resultType
    }

    func fetchData(offset: Int, limit: Int, successCallback: SuccessCallback? = nil ,failureCallback: FailureCallback? = nil) {
        DispatchQueue.global(qos: .userInitiated).sync {
            switch result {
            case .success:
                successCallback?(MockDataProvider.getDeliveries(limit: limit, offset: offset))
            case .failure:
                failureCallback?(NSError(domain: HTTPURLResponse.localizedString(forStatusCode: 500), code: 500, userInfo: nil))
            }
        }

    }
}

enum Result {
    case success
    case failure
}
