//
//  ThemeManager.swift
//  DataReader
//
//  Created by mozhgan on 11/6/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//

import UIKit

final class ThemeManager
{
    private let themeRepository: ThemeRepository = DefaultThemeRepository()
    
    class var sharedInstance: ThemeManager {
        struct Static {
            static let instance = ThemeManager()
        }
        return Static.instance
    }
    
    var current: Theme
    {
        return themeRepository.load()
        
    }
    func apply(theme: Theme)
    {
        themeRepository.save(theme)
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().barTintColor = theme.negativeBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.titleTextColor]
//        UIView.appearance().backgroundColor = theme.backgroundColor
        
        UITabBar.appearance().barStyle = theme.barStyle
        UISwitch.appearance().onTintColor = theme.tintColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.tintColor
        
    }
}
