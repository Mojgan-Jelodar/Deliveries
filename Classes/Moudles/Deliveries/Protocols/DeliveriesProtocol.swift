//
//  DeliveriesProtocol.swift
//  DataReader
//
//  Created by mozhgan on 11/7/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterToViewProtocol: class
{
    func refresh()
    func show(error : Error)
    func stopInfinitIndicator()
    func stopPullToRefreshIndicator()
}

protocol InteractorToPresenterProtocol: class
{
      func fetched(deliveries: [Delivery])
      func fetched(error : Error)
}

protocol DeliveryPresentorToInteractorProtocol: class
{
    var presenter: InteractorToPresenterProtocol? {get set}
    func fetchLiveDeliveries(offset: Int, limit: Int)
    func fetchCachedDeliveries(offset: Int, limit: Int)
}

protocol DeliveryViewToPresenterProtocol: class {
    var view: PresenterToViewProtocol? {get set}
    var interactor: DeliveryPresentorToInteractorProtocol? {get set}
    var router: DeliveryPresenterToRouterProtocol? {get set}
    func fetchLatestDeliveries()
    func showMoreDeliveries()
    func show(delivery : Delivery?)
    func showCachedData()
}

protocol DeliveryPresenterToRouterProtocol: class {
    static func createModule() -> UIViewController
    func showDetail(delivery : Delivery) 
}

