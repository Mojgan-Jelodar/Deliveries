//
//  File.swift
//  DataReader
//
//  Created by mozhgan on 11/7/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//
import UIKit
final class DeliveriesPresenter: DeliveryViewToPresenterProtocol
{
   
    
    var view: PresenterToViewProtocol?
    var interactor: DeliveryPresentorToInteractorProtocol?
    var router: DeliveryPresenterToRouterProtocol?
    
    private(set) var list : [Delivery] =  []
    
    
    private var isPerformingRefreshing : Bool = false
    
    private var offset = 0
    private(set) var limit : Int
    
    init(limit : Int = 10)
    {
        self.limit = limit
    }
    
    
    func showCachedData()
    {
        self.interactor?.fetchCachedDeliveries(offset: self.offset, limit: self.limit)
    }
    func fetchLatestDeliveries()
    {
        self.offset = 0
        self.isPerformingRefreshing = true
        self.startFetching()
    }
    func showMoreDeliveries()
    {
        offset += limit
        self.startFetching()
    }
    
    func show(delivery: Delivery?)
    {
        guard let item = delivery else { return }
        self.router?.showDetail(delivery: item)
    }
    
    private func startFetching()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.interactor?.fetchLiveDeliveries(offset: self.offset, limit: self.limit)
        }
        else
        {
            self.interactor?.fetchCachedDeliveries(offset: self.offset, limit: self.limit)
        }
    }
 
    
}

extension DeliveriesPresenter: InteractorToPresenterProtocol
{
    func fetched(deliveries: [Delivery])
    {
        if isPerformingRefreshing
        {
            isPerformingRefreshing = false
            self.view?.stopPullToRefreshIndicator()
            self.list.removeAll()
            self.list = deliveries
        }
        else
        {
            self.view?.stopInfinitIndicator()
            let distinctItems =  Set<Delivery>()
            self.list = distinctItems.union(self.list).union(deliveries).sorted(by: {$0.id < $1.id})
        }
        self.view?.refresh()
    }
    
    func fetched(error: Error)
    {
        if isPerformingRefreshing
        {
            isPerformingRefreshing = false
            self.view?.stopPullToRefreshIndicator()
        }
        else
        {
            self.view?.stopInfinitIndicator()
        }
        view?.show(error: error)
    }
    
    
}
