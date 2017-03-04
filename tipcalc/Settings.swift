//
//  Settings.swift
//  tipcalc
//
//  Created by Jonathan Wong on 3/1/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Foundation

class Settings {
    static let MinimumTip = "MinimumTip"
    static let MaximumTip = "MaximumTip"
    static let DefaultTip = "DefaultTip"
    static let MaximumSplitPeople = "MaximumSplitPeople"
    static let DefaultSplitPeople = "DefaultSplitPeople"
    static let DarkTheme = "DarkTheme"
    static let LastUsed = "LastUsed"
    static let LocaleString = "LocaleString"
    
    var userDefaults = UserDefaults.standard
    
    static let sharedInstance: Settings = {
        let instance = Settings()
        
        return instance
    }()
    
    func minimumTip() -> Int {
        if userDefaults.object(forKey: Settings.MinimumTip) == nil {
            userDefaults.set(10, forKey: Settings.MinimumTip)
        }
        return userDefaults.object(forKey: Settings.MinimumTip) as! Int
    }
    
    func setMinimumTip(minimumTip: Int) -> Int {
        if minimumTip < 0 || minimumTip > maximumTip() {
            return userDefaults.object(forKey: Settings.MinimumTip) as! Int
        }
        userDefaults.set(minimumTip, forKey: Settings.MinimumTip)
        return minimumTip
    }
    
    func maximumTip() -> Int {
        if userDefaults.object(forKey: Settings.MaximumTip) == nil {
            userDefaults.set(20, forKey: Settings.MaximumTip)
        }
        return userDefaults.object(forKey: Settings.MaximumTip) as! Int
    }
    
    func setMaximumTip(maximumTip: Int) -> Int {
        if maximumTip < 0 || maximumTip < minimumTip() {
            return userDefaults.object(forKey: Settings.MaximumTip) as! Int
        }
        userDefaults.set(maximumTip, forKey: Settings.MaximumTip)
        return maximumTip
    }
    
    func defaultTip() -> Int {
        if userDefaults.object(forKey: Settings.DefaultTip) == nil {
            userDefaults.set(15, forKey: Settings.DefaultTip)
        }
        return userDefaults.object(forKey: Settings.DefaultTip) as! Int
    }
    
    func setDefaultTip(defaultTip: Int) -> Int {
        if defaultTip > maximumTip() {
            userDefaults.set(maximumTip(), forKey: Settings.DefaultTip)
            return userDefaults.object(forKey: Settings.MaximumTip) as! Int
        } else if defaultTip < minimumTip() {
            userDefaults.set(minimumTip(), forKey: Settings.DefaultTip)
            return userDefaults.object(forKey: Settings.MinimumTip) as! Int
        } else {
            userDefaults.set(defaultTip, forKey: Settings.DefaultTip)
            return defaultTip
        }
    }
    
    func maximumSplitPeople() -> Int {
        if userDefaults.object(forKey: Settings.MaximumSplitPeople) == nil {
            userDefaults.set(4, forKey: Settings.MaximumSplitPeople)
        }
        return userDefaults.object(forKey: Settings.MaximumSplitPeople) as! Int
    }
    
    func setMaximumSplitPeople(maximumSplitPeople: Int) -> Int {
        if maximumSplitPeople > 0 {
            userDefaults.set(maximumSplitPeople, forKey: Settings.MaximumSplitPeople)
            return maximumSplitPeople
        }
        return userDefaults.object(forKey: Settings.MaximumSplitPeople) as! Int
    }
    
    func defaultSplitPeople() -> Int {
        if userDefaults.object(forKey: Settings.DefaultSplitPeople) == nil {
            userDefaults.set(2, forKey: Settings.DefaultSplitPeople)
        }
        return userDefaults.object(forKey: Settings.DefaultSplitPeople) as! Int
    }
    
    func setDefaultSplitPeople(defaultSplitPeople: Int) -> Int {
        if defaultSplitPeople > 0 && defaultSplitPeople < userDefaults.object(forKey: Settings.DefaultSplitPeople) as! Int {
            userDefaults.set(defaultSplitPeople, forKey: Settings.DefaultSplitPeople)
            return defaultSplitPeople
        }
        return userDefaults.object(forKey: Settings.DefaultSplitPeople) as! Int
    }
    
    func isDarkTheme() -> Bool {
        if userDefaults.object(forKey: Settings.DarkTheme) == nil {
            userDefaults.set(false, forKey: Settings.DarkTheme)
        }
        return userDefaults.object(forKey: Settings.DarkTheme) as! Bool
    }
    
    func setIsDarkTheme(isDark: Bool) {
        userDefaults.set(isDark, forKey: Settings.DarkTheme)
    }
    
    func lastUsed() -> [String: Any] {
        if userDefaults.dictionary(forKey: Settings.LastUsed) == nil {
            userDefaults.set([Date().description: 0.0], forKey: Settings.LastUsed)
        }
        return userDefaults.dictionary(forKey: Settings.LastUsed)!
    }
    
    func setLastUsed(date: Date, amount: Double) {
        var newDict = [String: Any]()
        newDict[date.description] = amount
        userDefaults.setValue(newDict, forKey: Settings.LastUsed)
        userDefaults.synchronize()
    }
    
    func localeString() -> String {
        if userDefaults.object(forKey: Settings.LocaleString) == nil {
            userDefaults.set("en_US", forKey: Settings.LocaleString)
        }
        return userDefaults.object(forKey: Settings.LocaleString) as! String
    }
    
    func setLocaleString(localeString: String) {
        userDefaults.set(localeString, forKey: Settings.LocaleString)
    }
}
