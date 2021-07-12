//
//  DeliveryCell.swift
//  DataReader
//
//  Created by mozhgan on 11/7/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class DeliveryCell: UITableViewCell
{
    private let imageFrame = CGSize(width: 100, height: 120)
    let defaultMargin : CGFloat = 8.0
    
    private let cardView : UIView = {
        let vw = UIView()
        vw.backgroundColor = ThemeManager.sharedInstance.current.secondaryBackgroundColor
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 10
        return vw
    }()
    private let addressLabel : SubtitleLabel = {
        let lbl = SubtitleLabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    
    private let descriptionLabel : TitleLabel = {
        let lbl = TitleLabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let imgView : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    
   
    
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    //MARK: - Intializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configCell(delivery : Delivery)
    {
        self.descriptionLabel.text = delivery.itemDescription
        self.addressLabel.text = delivery.location?.address
        self.imgView.backgroundColor = UIColor.random
        guard let url = URL(string: delivery.imageURL ?? "") else { return }
        self.imgView.kf.indicatorType = .activity
        let processor = ResizingImageProcessor(referenceSize: UIScreen.main.bounds.size, mode: .aspectFill)
        self.imgView.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil, options:[.processor(processor),.transition(.flipFromTop(2)),.cacheOriginalImage], progressBlock: nil, completionHandler: nil)
    }
    

}


extension DeliveryCell
{
    private func setup()
    {
        
        self.contentView.addSubview(self.cardView)
        self.cardView.addSubview(self.imgView)
        self.cardView.addSubview(self.descriptionLabel)
        self.cardView.addSubview(self.addressLabel)

        self.cardView.snp.makeConstraints
        {
            (make) in
            make.top.equalToSuperview().offset(defaultMargin)
            make.bottom.equalToSuperview().offset(-defaultMargin)
            make.height.greaterThanOrEqualTo(self.imgView).offset(defaultMargin * 4).priorityRequired()
            if #available(iOS 11.0, *)
            {
                make.leading.equalTo(self.contentView.safeAreaLayoutGuide.snp.leading).offset(defaultMargin)
                make.trailing.equalTo(self.contentView.safeAreaLayoutGuide.snp.trailing).offset(-defaultMargin)
            }
            else
            {
                make.leading.equalToSuperview().offset(defaultMargin)
                make.trailing.equalToSuperview().offset(-defaultMargin)
            }
        }


        self.imgView.snp.makeConstraints
        {
            (make) in
            make.top.equalToSuperview().offset(defaultMargin * 2)
            make.height.equalTo(imageFrame.height)
            make.width.equalTo(imageFrame.width)
            if #available(iOS 11.0, *)
            {
                make.leading.equalTo(self.cardView.safeAreaLayoutGuide.snp.leading).offset(defaultMargin)
            }
            else
            {
                make.leading.equalToSuperview().offset(defaultMargin)
            }
        }


        self.descriptionLabel.snp.makeConstraints
        {
            (make) in
            make.leading.equalTo(self.imgView.snp_trailingMargin).offset(defaultMargin * 2)
            make.top.equalTo(self.imgView)
            
            make.height.equalToSuperview().dividedBy(4)
            
            if #available(iOS 11.0, *)
            {
                make.trailing.equalTo(self.cardView.safeAreaLayoutGuide.snp.trailing).offset(-defaultMargin)
            }
            else
            {
                make.trailing.equalToSuperview().offset(-defaultMargin)
            }
        }

        self.addressLabel.snp.makeConstraints
        { (make) in
            make.top.equalTo(self.descriptionLabel.snp_bottom)
            make.leading.equalTo(self.descriptionLabel)
            make.trailing.equalTo(self.descriptionLabel)
            make.bottom.equalToSuperview().offset(-defaultMargin).priorityHigh()
        }
        
        
    }
}
