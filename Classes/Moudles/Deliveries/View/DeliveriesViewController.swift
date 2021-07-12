//
//  DeliveriesViewController.swift
//  DataReader
//
//  Created by mozhgan on 11/7/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

final class DeliveriesViewController: UITableViewController
{
    var presenter: DeliveryViewToPresenterProtocol?
    
    private var cellHeights: [IndexPath : CGFloat] = [:]
    
    let reuseIdentifier = "ReuseIdentifier"
    
    
    private lazy var refreshCtrl : UIRefreshControl = {
        let tmp = UIRefreshControl()
        tmp.attributedTitle = NSAttributedString(string: LocalizeStrings.DeliveryListView.refreshingString)
        tmp.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        return tmp
    }()
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.presenter as! DeliveriesPresenter).list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DeliveryCell
        cell.configCell(delivery: (self.presenter as! DeliveriesPresenter).list[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let delivery = (self.presenter as! DeliveriesPresenter).list[indexPath.row]
        self.presenter?.show(delivery: delivery)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
}
//MARK: - ViewController Lifecycle
extension DeliveriesViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = LocalizeStrings.DeliveryListView.deliveryListTitle
        self.tableView.separatorStyle = .none
        tableView.register(DeliveryCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.addSubview(self.refreshCtrl)
        self.presenter?.showCachedData()
        self.refreshCtrl.beginRefreshing()
        self.presenter?.fetchLatestDeliveries()
        tableView.addInfiniteScroll
        { (tableview) in
            self.presenter?.showMoreDeliveries()
        }
    }
}

// MARK: - Table view pull to refresh
extension DeliveriesViewController
{
    @objc func refresh(sender:AnyObject)
    {
        self.presenter?.fetchLatestDeliveries()
    }
}


extension DeliveriesViewController : PresenterToViewProtocol
{
    func stopInfinitIndicator()
    {
        self.tableView.finishInfiniteScroll()
    }
    
    func stopPullToRefreshIndicator()
    {
        self.refreshCtrl.endRefreshing()
    }
    
    func refresh()
    {
        self.tableView.reloadData()
    }
    
    func show(error: Error)
    {
        let alert = UIAlertController(title: LocalizeStrings.CommonStrings.alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizeStrings.CommonStrings.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
