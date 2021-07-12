//
//  MapPresenter.swift
//  DataReader
//
//  Created by mozhgan on 11/8/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import Foundation

final class MapPresenter: ViewToMapPresenterProtocol
{
    var view: MapPresenterToViewProtocol?
    var router: MapPresenterToRouterProtocol?
    func show(delivery: Delivery)
    {
        view?.show(delivery: delivery)
    }
    
    
    
    
}
