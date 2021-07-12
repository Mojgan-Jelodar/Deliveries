//
//  MapProtocols.swift
//  DataReader
//
//  Created by mozhgan on 11/8/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit


protocol MapPresenterToRouterProtocol: class
{
    static func createModule(delivery : Delivery) -> UIViewController
}

protocol ViewToMapPresenterProtocol: class
{
    
    var view: MapPresenterToViewProtocol? {get set}
    var router: MapPresenterToRouterProtocol? {get set}
    func show(delivery: Delivery)
}
protocol MapPresenterToViewProtocol: class
{
    func show(delivery: Delivery)
}
