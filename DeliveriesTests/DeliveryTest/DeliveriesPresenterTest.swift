//
//  DeliveryListTest.swift
//  DataReaderTests
//
//  Created by m.jelodar on 11/9/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import Delivery

class DeliveriesPresenterTest: XCTestCase {

    var presenter: DeliveriesPresenter!
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!
    var mockView: MockView!

    let delivery = Delivery(id: 1, itemDescription: "Deliver pets to Alan", imageURL: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-2.jpeg",
                            location: Location(lat: 22.336093, lng: 114.155288, address: "Cheung Sha Wan"))

    override func setUp() {
       presenter = DeliveriesPresenter()
       mockInteractor = MockInteractor()
       mockRouter = MockRouter()
       mockView = MockView()

       presenter.interactor = mockInteractor
       presenter.view = mockView
       presenter.router = mockRouter
       mockInteractor.presenter = presenter

       presenter?.fetchLatestDeliveries()
    }

    override func tearDown() {
        self.presenter = nil
        self.mockInteractor = nil
        self.mockRouter = nil
        self.mockView = nil
    }

    func testShowCachedData() {
         presenter?.showCachedData()
         XCTAssertGreaterThanOrEqual(presenter.list.count, 0)
     }

    func testFetchLatestDeliveries() {
        presenter?.fetchLatestDeliveries()
        XCTAssertGreaterThan(presenter.list.count, 0)
        XCTAssertLessThan(presenter.list.count, self.presenter.limit + 1)
    }

   func testShowMoreDeliveries() {
       presenter.showMoreDeliveries()
       XCTAssertGreaterThan(presenter.list.count, self.presenter.limit)
   }

   func testShowMapController() {
        presenter.show(delivery: delivery)
        XCTAssertEqual(mockRouter?.delivery?.id, delivery.id)
   }

    func testShowDelivery() {
        presenter.show(delivery: delivery)
        XCTAssertEqual(mockRouter?.delivery?.id, delivery.id)
    }

}

final class MockInteractor: DeliveryPresentorToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?

    private var deliveries : [Delivery]?

    func fetchLiveDeliveries(offset: Int, limit: Int) {
        NetworkMock(resultType: .success).fetchData(offset: offset, limit: limit,successCallback: {  (list) -> Void in
            self.deliveries = list
            self.presenter?.fetched(deliveries: list)
        })

    }

    func fetchCachedDeliveries(offset: Int, limit: Int) {
        self.presenter?.fetched(deliveries: MockDataProvider.getDeliveries(limit: limit, offset: offset))
    }
}

class MockRouter: DeliveryPresenterToRouterProtocol {

    var delivery: Delivery?

    static func createModule() -> UIViewController {
        return DeliveriesViewController()
    }

    func showDetail(delivery: Delivery) {
        self.delivery = delivery
    }
}

class MockView : PresenterToViewProtocol {
    var shouldRefreshDeliveryList = false
    var shouldShowError = false
    var refreshCallback = false
    var showMoreCallback = false
    var screenLoaderCompletion = false

    func refresh() {
        shouldRefreshDeliveryList = true
    }

    func show(error: Error) {
        shouldShowError = true
    }

    func stopInfinitIndicator() {
        showMoreCallback = true
    }

    func stopPullToRefreshIndicator() {
        refreshCallback = true
    }

}
