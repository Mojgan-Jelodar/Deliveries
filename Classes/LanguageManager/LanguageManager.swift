//
//  File.swift
//  DataReader
//
//  Created by m.jelodar on 11/9/19.
//  Copyright © 2019 mozhgan. All rights reserved.
//
import Foundation
import UIKit

public class LanguageManager
{
    
    /// Returns the singleton LanguageManager instance.
    public static let shared: LanguageManager = LanguageManager()
    
    
    /// Returns the currnet language
    public var currentLanguage: Languages
    {
        get
        {
            
            guard let currentLang = UserDefaults.standard.string(forKey: DefaultsKeys.selectedLanguage) else
            {
                return Languages(rawValue: Languages.en.rawValue)!
            }
            return Languages(rawValue: currentLang)!
        }
        set {
            
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsKeys.selectedLanguage)
        }
    }
    
    /// Returns the default language that the app will run first time
    public var defaultLanguage: Languages {
        get {
            
            guard let defaultLanguage = UserDefaults.standard.string(forKey: DefaultsKeys.defaultLanguage) else {
                fatalError("Did you set the default language for the app ?")
            }
            return Languages(rawValue: defaultLanguage)!
        }
        set {
            
            // swizzle the awakeFromNib from nib and localize the text in the new awakeFromNib
            UIView.localize()
            Bundle.localize()
            
            let defaultLanguage = UserDefaults.standard.string(forKey: DefaultsKeys.defaultLanguage)
            guard defaultLanguage == nil else {
                return
            }
            
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsKeys.defaultLanguage)
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsKeys.selectedLanguage)
            setLanguage(language: newValue)
        }
    }
    
    
    /// Returns the diriction of the language
    public var isRightToLeft: Bool {
        get {
            return isLanguageRightToLeft(language: currentLanguage)
        }
    }
    
    /// Returns the app locale for use it in dates and currency
    public var appLocale: Locale {
        get {
            return Locale(identifier: currentLanguage.rawValue)
        }
    }
    
    ///
    /// Set the current language for the app
    ///
    /// - parameter language: The language that you need from the app to run with
    ///
    public func setLanguage(language: Languages, rootViewController: UIViewController? = nil, animation: ((UIView) -> Void)? = nil) {
        
        // change the dircation of the views
        let semanticContentAttribute: UISemanticContentAttribute = isLanguageRightToLeft(language: language) ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        

        
        // change app language
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // set current language
        currentLanguage = language
        
        
        guard let rootViewController = rootViewController else {
            return
        }
        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        rootViewController.view.addSubview(snapshot);
        
        UIApplication.shared.delegate?.window??.rootViewController = rootViewController
        
        UIView.animate(withDuration: 0.5, animations: {
            animation?(snapshot)
        }) { _ in
            snapshot.removeFromSuperview()
        }
        
    }
    
    private func isLanguageRightToLeft(language: Languages) -> Bool {
        return Locale.characterDirection(forLanguage: language.rawValue) == .rightToLeft
    }
    
}

public enum Languages: String
{
    case ar,en,nl,ja,ko,vi,ru,sv,fr,es,pt,it,de,da,fi,nb,tr,el,id,ms,th,hi,hu,pl,cs,sk,uk,hr,ca,ro,he,ur,ku,arc
    case enGB = "en-GB"
    case enAU = "en-AU"
    case enCA = "en-CA"
    case enIN = "en-IN"
    case frCA = "fr-CA"
    case esMX = "es-MX"
    case ptBR = "pt-BR"
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case zhHK = "zh-HK"
    case fa = "fa-IR"
    
}


// MARK: Swizzling
fileprivate extension UIView
{
    static func localize() {
        
        let orginalSelector = #selector(awakeFromNib)
        let swizzledSelector = #selector(swizzledAwakeFromNib)
        
        let orginalMethod = class_getInstanceMethod(self, orginalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, orginalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(orginalMethod!), method_getTypeEncoding(orginalMethod!))
        } else {
            method_exchangeImplementations(orginalMethod!, swizzledMethod!)
        }
        
    }
    
    
    
    @objc func swizzledAwakeFromNib() {
        swizzledAwakeFromNib()
        
        switch self {
        case let txtf as UITextField:
            txtf.text = txtf.text?.localiz()
            txtf.placeholder = txtf.placeholder?.localiz()
        case let lbl as UILabel:
            lbl.text = lbl.text?.localiz()
        case let btn as UIButton:
            btn.setTitle(btn.title(for: .normal)?.localiz(), for: .normal)
        default:
            break
        }
    }
}

fileprivate extension Bundle
{
    static func localize()
    {
        
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        let swizzledSelector = #selector(customLocaLizedString(forKey:value:table:))
        
        let orginalMethod = class_getInstanceMethod(self, orginalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, orginalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(orginalMethod!), method_getTypeEncoding(orginalMethod!))
        } else {
            method_exchangeImplementations(orginalMethod!, swizzledMethod!)
        }
    }
    
    @objc  private func customLocaLizedString(forKey key:String,value:String?,table:String?)->String
    {
        if let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage.rawValue, ofType: "lproj"),
            let langBundle = Bundle(path: bundle){
            return langBundle.customLocaLizedString(forKey: key, value: value, table: table)
        }else {
            return Bundle.main.customLocaLizedString(forKey: key, value: value, table: table)
        }
    }
}


fileprivate enum DefaultsKeys {
    static let selectedLanguage = "LanguageManagerSelectedLanguage"
    static let defaultLanguage = "LanguageManagerDefaultLanguage"
}

// MARK: UIApplication extension
public extension UIApplication {
    // Get top view controller
    static var topViewController:UIViewController? {
        get{
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                return topController
            }else{
                return nil
            }
        }
    }
    
}

