//
//  MockDataProvider.swift
//  DataReaderTests
//
//  Created by m.jelodar on 11/9/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import Foundation
import ObjectMapper
@testable import Delivery

class MockDataProvider {
    class func getDeliveries(limit : Int,offset : Int) -> [Delivery] {
        let testBundle = Bundle(for: MockDataProvider.self)
        let path = testBundle.path(forResource: "MockData", ofType: "json")
        do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
              let jsonString = String.init(data: data, encoding: String.Encoding.utf8)
              let deliveries = Mapper<Delivery>().mapArray(JSONString: jsonString ?? "")
              let totalRecords = deliveries?.count ?? 0
              guard offset < totalRecords else { return []}
              let to = ((offset + limit) < totalRecords) ? (offset + limit) : totalRecords
              return Array(deliveries![offset..<to])
        } catch {
              return []
        }
    }
}
