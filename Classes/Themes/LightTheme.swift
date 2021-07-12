//
//  LightTheme.swift
//  DataReader
//
//  Created by mozhgan on 11/6/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit

struct LightTheme: Theme
{
    var name: ThemeName
    {
        return .light
    }
    
    var tintColor: UIColor
    {
        return UIColor.colorFrom(hexString: "#DD7243")
    }
    
    var barStyle: UIBarStyle {
        return .default
    }
    
    var keyboardAppearance: UIKeyboardAppearance
    {
        return .light
    }
    
    var backgroundColor: UIColor
    {
        return UIColor.colorFrom(hexString: "#FFFFFF")
    }
    
    var secondaryBackgroundColor: UIColor
    {
        return .groupTableViewBackground
    }
    
    var negativeBackgroundColor: UIColor
    {
        return UIColor.colorFrom(hexString: "#FFFFFF")
        
    }
    
    var titleTextColor: UIColor
    {
       return UIColor.colorFrom(hexString: "#FBAA3F")
    }
    var subtitleTextColor: UIColor
    {
        return UIColor.colorFrom(hexString: "#DD7243")
    }
    
    var textColor: UIColor
    {
        return UIColor.colorFrom(hexString: "#000000")
    }
}
