//
//  Item.swift
//  DataReader
//
//  Created by mozhgan on 11/6/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import ObjectMapper
import RealmSwift

// MARK: - Item
public class Delivery : Object,Mappable
{
    @objc dynamic private(set) var id: Int = 0
    @objc dynamic private(set) var itemDescription: String?
    @objc dynamic private(set) var imageURL: String?
    @objc dynamic private(set) var location: Location?
    
    
    
    public convenience init(id : Int , itemDescription : String , imageURL : String , location : Location)
    {
        self.init()
        self.id = id
        self.itemDescription = itemDescription
        self.imageURL = imageURL
        self.location = location
       
    }
    
    public required convenience init(map: Map)
    {
        self.init()
    }
    
    
    public override class func primaryKey() -> String?
    {
        return CodingKeys.id.rawValue
    }
    
    /// Mapping json
    public func mapping(map: Map)
    {
        self.id <- map[CodingKeys.id.rawValue]
        self.itemDescription <- map[CodingKeys.itemDescription.rawValue]
        self.imageURL <- map[CodingKeys.imageURL.rawValue]
        self.location <- map[CodingKeys.location.rawValue]
    }
}

extension Delivery
{
    /// List of key names
    enum CodingKeys: String, CodingKey {
        case id
        case itemDescription = "description"
        case imageURL = "imageUrl"
        case location
    }
}


// MARK: - Location
public class Location : Object,Mappable
{
    @objc dynamic private(set)  var lat: NSNumber? = NSNumber(value: 0.0)
    @objc dynamic private(set)  var lng: NSNumber? = NSNumber(value: 0.0)
    @objc dynamic private(set)  var address: String?
    
    public required convenience init(map: Map)
    {
        self.init()
    }
    
    public convenience init(lat : Double , lng : Double , address : String )
     {
         self.init()
         self.lat = NSNumber(value: lat)
         self.lng = NSNumber(value: lng)
         self.address = address
        
     }
    
    /// Mapping json
    public func mapping(map: Map)
    {
        self.lat <- map[CodingKeys.lat.rawValue]
        self.lng <- map[CodingKeys.lng.rawValue]
        self.address <- map[CodingKeys.address.rawValue]
    }
}

extension Location
{
    /// List of key names
    enum CodingKeys: String, CodingKey
    {
        case lat
        case lng
        case address
    }
    
}

