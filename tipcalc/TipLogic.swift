//
//  TipLogic.swift
//  tipcalc
//
//  Created by Jonathan Wong on 3/10/18.
//  Copyright © 2018 Jonathan Wong. All rights reserved.
//

import Foundation

struct TipLogic {
    
    let settings = Settings()
    
    var locale: NSLocale {
        get {
            return NSLocale(localeIdentifier: settings.localeString())
        }
    }
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    func calculateTip(total: Double, percent: Double, split: Int) -> Double {
        let tipAmount = total * percent * 0.01
        return (total + tipAmount) / Double(split)
    }
}
