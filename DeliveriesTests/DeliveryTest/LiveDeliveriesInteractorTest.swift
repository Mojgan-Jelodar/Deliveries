//
//  f.swift
//  DataReaderTests
//
//  Created by m.jelodar on 11/9/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import Delivery

class LiveDeliveriesInteractorTest: XCTestCase {
    var presenter: MockDeliveryInteractor?
    var interactor: DeliveryPresentorToInteractorProtocol?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.interactor = MockInteractor()
        self.presenter = MockDeliveryInteractor()
        self.interactor?.presenter = self.presenter
    }

    override func tearDown() {
        self.presenter = nil
        self.interactor = nil
    }

    func testFetchDeliveriesSuccess() {
        NetworkMock().fetchData(offset: 0, limit: 10, successCallback: { (list) in
            self.presenter?.fetched(deliveries: list)
        }, failureCallback: nil)
        XCTAssertGreaterThanOrEqual(self.presenter?.deliveries?.count ?? 0, 0)
    }

    func testFetchDeliveriesFaild() {
        NetworkMock(resultType: .failure).fetchData(offset: 0, limit: 10, successCallback: nil) { (error) in
            self.presenter?.fetched(error: error)
        }
        XCTAssertNotNil(self.presenter?.error)

    }

}

class MockDeliveryInteractor : InteractorToPresenterProtocol {
    var deliveries: [Delivery]?
    var error : Error?

    func fetched(deliveries: [Delivery]) {
        self.deliveries = deliveries
    }

    func fetched(error: Error) {
        self.error = error
    }
}
