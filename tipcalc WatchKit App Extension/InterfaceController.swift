//
//  InterfaceController.swift
//  tipcalc WatchKit App Extension
//
//  Created by Jonathan Wong on 3/9/18.
//  Copyright © 2018 Jonathan Wong. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var totalLabel: WKInterfaceLabel!
    
    @IBOutlet var splitPeoplePicker: WKInterfacePicker!
    
    let tipLogic = TipLogic()
    var total: String?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        updateTotal()
        
        if WCSession.isSupported() {
//            let session = WCSession.default
//            if session.isReachable {
//                session.sendMessage(["maxSplitPeople": 2],
//                                    replyHandler: { (reply: [String: Any]) -> Void in
//                                        if let splitPeople = reply["maxSplitPeople"] as? Int {
//                                            self.updateMaxSplitPeople(maxSplitPeople: splitPeople)
//                                        }
//                },
//                                    errorHandler: { error in
//                                        print("error sending message: \(error.localizedDescription)")
//                })
//            }
        }
        
        updateMaxSplitPeople(maxSplitPeople: 10)
    }
    
    override func willActivate() {
        super.willActivate()
        
//        totalLabel.setText(<#T##text: String?##String?#>)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updateMaxSplitPeople(maxSplitPeople: Int) {
        DispatchQueue.main.async(execute: { () -> Void in
            var pickerItems: [WKPickerItem] = []
            for i in 1...maxSplitPeople {
                let item = WKPickerItem()
                item.title = String(i)
                pickerItems.append(item)
            }
            self.splitPeoplePicker.setItems(pickerItems)
            // default number
        })
    }
    
    func addDigit(digit: String) {
        if digit == "X" {
//            if var updatedTotal = total, updatedTotal.count > 0 {
//                let index = updatedTotal.index(updatedTotal.endIndex, offsetBy: -1)
//                updatedTotal = updatedTotal[index...]
//                print(updatedTotal)
//            }
        }
        total?.append(digit)
        
        if let tt = total {
            let totalString = TipLogic.numberFormatter.string(from: NSNumber(value: Int(tt)!))
            totalLabel.setText(totalString)
        }
    }
    
    @IBAction func splitPeoplePickerChanged(_ value: Int) {
        // todo: update the total Label
        // value is the index of the picker, not the value
    }
    
    @IBAction func oneButtonPressed() {
        addDigit(digit: "1")
    }
    
    @IBAction func twoButtonPressed() {
        addDigit(digit: "2")
    }
    
    @IBAction func threeButtonPressed() {
        addDigit(digit: "3")
    }
    
    @IBAction func fourButtonPressed() {
        addDigit(digit: "4")
    }
    
    @IBAction func fiveButtonPressed() {
        addDigit(digit: "5")
    }
    
    @IBAction func sixButtonPressed() {
        addDigit(digit: "6")
    }
    
    @IBAction func sevenButtonPressed() {
        addDigit(digit: "7")
    }
    
    @IBAction func eightButtonPressed() {
        addDigit(digit: "8")
    }

    @IBAction func nineButtonPressed() {
        addDigit(digit: "9")
    }
    
    @IBAction func zeroButtonPressed() {
        addDigit(digit: "0")
    }
    
    @IBAction func deleteButtonPressed() {
        addDigit(digit: "X")
    }
    
}
