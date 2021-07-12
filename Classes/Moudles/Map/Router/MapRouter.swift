//
//  File.swift
//  DataReader
//
//  Created by mozhgan on 11/8/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit


final class MapRouter : MapPresenterToRouterProtocol
{
    static func createModule(delivery : Delivery) -> UIViewController
    {
        let view = MapViewController(delivery: delivery)
        let presenter: ViewToMapPresenterProtocol = MapPresenter()
        let router: MapPresenterToRouterProtocol = MapRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view

        
    }
    
    
}
