//
//  MapViewController.swift
//  DataReader
//
//  Created by mozhgan on 11/8/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController
{

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var presenter: ViewToMapPresenterProtocol?

    private var delivery : Delivery!
    
    let addressLabel : TextLabel = {
        let lbl = TextLabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()


    let descriptionLabel : TitleLabel = {
        let lbl = TitleLabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()

    let mapView : MKMapView = {
        let map = MKMapView(frame: CGRect.zero)
        return map
    }()


    required init(delivery : Delivery)
    {
        super.init(nibName: nil, bundle: nil)
        self.delivery = delivery
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        setup()
        self.presenter?.show(delivery: delivery)
        
    }


    private func setup()
    {

        self.view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints
        { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.view.addSubview(mapView)
        mapView.snp.makeConstraints
        {
                (make) in
                if #available(iOS 11.0, *)
                {
                    make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-8)
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
                    make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(8)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-150)
                }
                else
                {
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-150)
                    make.trailing.equalToSuperview()
                }
        }
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints
            { (make) in
                if #available(iOS 11.0, *)
                {
                    make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-8)
                    make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(8)
                    make.top.equalTo(self.mapView.snp_bottomMargin).offset(8)
                }
                else
                {
                    make.top.equalTo(mapView.snp_bottomMargin).offset(8)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                }
        }
        
        self.view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints
            { (make) in
                if #available(iOS 11.0, *)
                {
                    make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-8)
                    make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(8)
                    make.top.equalTo(self.descriptionLabel.snp_bottomMargin).offset(8)
                }
                else
                {
                    make.top.equalTo(descriptionLabel.snp_bottomMargin).offset(8)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                }
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
   

}
//MARK: - dismiss viewcontroller with tap
extension MapViewController
{
    @objc func onTap(gr: UITapGestureRecognizer)
    {
        if gr.state == UIGestureRecognizer.State.ended
        {
            let view = gr.view
            let loc = gr.location(in: view)
            if view?.hitTest(loc, with: nil) is UIVisualEffectView
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension MapViewController : MapPresenterToViewProtocol
{
    func show(delivery: Delivery)
    {
        self.addressLabel.text = delivery.location?.address
        self.descriptionLabel.text = delivery.itemDescription
        guard let lat = delivery.location?.lat?.doubleValue ,let long = delivery.location?.lng?.doubleValue else { return }
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
        annotation.coordinate = centerCoordinate
        annotation.title = delivery.location?.address
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    
}


