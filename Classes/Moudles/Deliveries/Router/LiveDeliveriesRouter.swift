//
//  File.swift
//  DataReader
//
//  Created by mozhgan on 11/7/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit

class LiveDeliveriesRouter: DeliveryPresenterToRouterProtocol
{
   
    
    let presentingViewController: UIViewController
    
    required init(presentingViewController : UIViewController)
    {
        self.presentingViewController = presentingViewController
    }
    
    
    func showDetail(delivery: Delivery)
    {
        let vc = MapRouter.createModule(delivery: delivery)
        self.presentingViewController.present(vc, animated: true, completion: nil)
    }
    
    
    
    class func createModule() -> UIViewController
    {
        let view = DeliveriesViewController.init(style: .plain)
        let presenter: DeliveryViewToPresenterProtocol & InteractorToPresenterProtocol = DeliveriesPresenter()
        let interactor: DeliveryPresentorToInteractorProtocol = LiveDeliveriesInteractor()
        let router: DeliveryPresenterToRouterProtocol = LiveDeliveriesRouter(presentingViewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view;
    }
    
}
