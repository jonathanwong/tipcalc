//
//  ViewController.swift
//  tipcalc
//
//  Created by Jonathan Wong on 2/28/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var percentTipLabel: UILabel!
    @IBOutlet weak var splitPeopleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var billTextField: UITextField!
    
    let settings = Settings()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tipSwipe = UIPanGestureRecognizer(target: self, action: #selector(ViewController.updateTip(_:)))
        percentTipLabel.addGestureRecognizer(tipSwipe)
        
        let peopleSwipe = UIPanGestureRecognizer(target: self, action: #selector(ViewController.updatePeople(_:)))
        splitPeopleLabel.addGestureRecognizer(peopleSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDefaults()
        setupTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDefaults() {
        percentTipLabel.text = "\(settings.defaultTip())%"
        splitPeopleLabel.text = "Split: \(settings.defaultSplitPeople())"
        let lastUsed = settings.lastUsed()
        let dateString = Array(lastUsed.keys)[0]
        let dateKey = ViewController.dateFormatter.date(from: dateString)
        let amount = Array(lastUsed.values)[0] as! Double
        let timeInterval = dateKey?.timeIntervalSince(Date())
        
        if let timeInterval = timeInterval {
            if abs(timeInterval) < 10 * 60 {
                billTextField.text = "\(amount)"
            }
        }
        
        percentTip = settings.defaultTip()
        splitPeople = settings.defaultSplitPeople()
    }
    
    func setupTheme() {
        if settings.isDarkTheme() {
            view.backgroundColor = UIColor.black
            billTextField.textColor = UIColor.orange
            percentTipLabel.textColor = UIColor.yellow
            splitPeopleLabel.textColor = UIColor.yellow
            totalLabel.textColor = UIColor.green
        } else {
            view.backgroundColor = UIColor.white
            billTextField.textColor = UIColor.lightGray
            percentTipLabel.textColor = UIColor.darkGray
            splitPeopleLabel.textColor = UIColor.darkGray
            totalLabel.textColor = UIColor.black
        }
    }
    
    var percentTip: Int? {
        didSet {
            calculateTip(self)
        }
    }
    
    var splitPeople: Int? {
        didSet {
            calculateTip(self)
        }
    }
    
    func updateTip(_ gesture: UIPanGestureRecognizer) {
        guard percentTip != nil else {
            return
        }
        let adjustAmount = gesture.velocity(in: view).x >= 0 ? 1 : -1
        let temp = percentTip! + adjustAmount
        if temp < settings.minimumTip() {
            percentTip = settings.minimumTip()
        } else if temp > settings.maximumTip() {
            percentTip = settings.maximumTip()
        } else {
            percentTip = temp
        }
    }
    
    func updatePeople(_ gesture: UIPanGestureRecognizer) {
        guard splitPeople != nil else {
            return
        }
        let adjustAmount = gesture.velocity(in: view).x >= 0 ? 1 : -1
        let temp = splitPeople! + adjustAmount
        if temp < 1 {
            splitPeople = 1
        } else if temp > settings.maximumSplitPeople() {
            splitPeople = settings.maximumSplitPeople()
        } else {
            splitPeople = temp
        }
    }

    func showAllInputs(show: Bool) {
        if show {
            containerHeightConstraint.constant = 20.0
        } else {
            let offset = view.frame.height / 2.0 - billTextField.frame.height + 20.0
            containerHeightConstraint.constant = offset
        }
        
        UIView.animate(withDuration: 0.33,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 10.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        },
                       completion: nil)
    }

    @IBAction func calculateTip(_ sender: Any) {
        guard percentTip != nil && splitPeople != nil else {
            return
        }
        let billTotal = Double(billTextField.text!) ?? 0
        
        if billTotal == 0 {
            showAllInputs(show: false)
        } else {
            showAllInputs(show: true)
        }
        
        let dollarTip = billTotal * Double(percentTip!) * 0.01
        let total = (billTotal + dollarTip) / Double(splitPeople!)
        
        percentTipLabel.text = String(format: "%d%%", Int(percentTip!))
        splitPeopleLabel.text = "Split: \(splitPeople!)"
        ViewController.numberFormatter.locale = locale as Locale
        let totalString = ViewController.numberFormatter.string(from: NSNumber(value: total))
        totalLabel.text = totalString
        
        settings.setLastUsed(date: Date(), amount: billTotal)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(show: false, notification: notification)
    }
    
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = ((keyboardFrame).height) * (show ? 1 : -1)
    }
}

