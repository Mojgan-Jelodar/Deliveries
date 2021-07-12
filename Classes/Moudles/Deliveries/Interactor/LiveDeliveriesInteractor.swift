//
//  File.swift
//  DataReader
//
//  Created by mozhgan on 11/7/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import Foundation
import Alamofire

public class LiveDeliveriesInteractor: DeliveryPresentorToInteractorProtocol
{
    
    
    var presenter: InteractorToPresenterProtocol?
    
    private lazy var deliveryService : DeliveryService = {
        return DeliveryService()
    }()
    
    private lazy var realmStorageContext : RealmStorageContext! = {
        return try! RealmStorageContext(configuration: ConfigurationType.basic(url: nil))
    }()
    
    

    
    public func fetchLiveDeliveries(offset: Int, limit: Int)
    {
        self.deliveryService.deliveries(offset: offset, limit: limit, successCallback:
        {
            (items) in
            self.persist(deliveries: items)
            self.fetchCachedDeliveries(offset: offset, limit: limit)
        })
        { (error) in
            self.presenter?.fetched(error: error)
        }
    }
    
    
    public func fetchCachedDeliveries(offset: Int, limit: Int)
    {
        self.realmStorageContext.fetch(Delivery.self)
        {   (list) in
            let totalRecords = list.count
            guard offset < totalRecords else {
                self.presenter?.fetched(deliveries: [])
                return
            }
            let to = ((offset + limit) < totalRecords) ? (offset + limit) : totalRecords
            self.presenter?.fetched(deliveries: Array(list[offset..<to]))
        }
    }
    
    
    
    private func persist(deliveries : [Delivery])
    {
        do
        {
            try self.realmStorageContext.save(objects: deliveries)
        }
        catch let error
        {
            self.presenter?.fetched(error: error)
        }
    }
    
    
    
    
}



