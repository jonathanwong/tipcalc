//
//  SettingsViewController.swift
//  tipcalc
//
//  Created by Jonathan Wong on 2/28/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let settings = Settings()
    
    var localeIdentifiers = [String]()
    var identifiers: [String]!
    var lastLocaleIndexPath: IndexPath?
    
    enum TipTextFieldTag: Int {
        case minimumTip = 100
        case defaultTip = 101
        case maximumTip = 102
        case maximumSplit = 103
        case defaultSplit = 104
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleTap(_:)))
        settingsTableView.addGestureRecognizer(tapGesture)
        
        
        identifiers = NSLocale.availableLocaleIdentifiers.sorted()
        let locale = NSLocale(localeIdentifier: "en_US")
        identifiers.forEach {
            let name = locale.displayName(forKey: NSLocale.Key.identifier, value: $0)!
            localeIdentifiers.append(name)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        sender.cancelsTouchesInView = false
        view.endEditing(true)
    }
    
    @objc func darkThemeChanged(_ sender: UISwitch) {
        settings.setIsDarkTheme(isDark: sender.isOn)
    }
}


extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else {
            return localeIdentifiers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTipTableViewCell", for: indexPath)
            (cell as! DefaultTipTableViewCell).tipTextField.delegate = self
            
            if indexPath.row == 0 {
                (cell as! DefaultTipTableViewCell).tipLabel.text = "Minimum"
                (cell as! DefaultTipTableViewCell).tipTextField.text = "\(settings.minimumTip())"
                (cell as! DefaultTipTableViewCell).tipTextField.tag = TipTextFieldTag.minimumTip.rawValue
            } else if indexPath.row == 1 {
                (cell as! DefaultTipTableViewCell).tipLabel.text = "Default"
                (cell as! DefaultTipTableViewCell).tipTextField.text = "\(settings.defaultTip())"
                (cell as! DefaultTipTableViewCell).tipTextField.tag = TipTextFieldTag.defaultTip.rawValue
            } else {
                (cell as! DefaultTipTableViewCell).tipLabel.text = "Maximum"
                (cell as! DefaultTipTableViewCell).tipTextField.text = "\(settings.maximumTip())"
                (cell as! DefaultTipTableViewCell).tipTextField.tag = TipTextFieldTag.maximumTip.rawValue
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTipTableViewCell", for: indexPath)
            (cell as! DefaultTipTableViewCell).tipTextField.delegate = self
            
            if indexPath.row == 0 {
                (cell as! DefaultTipTableViewCell).tipLabel.text = "Default Party"
                (cell as! DefaultTipTableViewCell).tipTextField.text = "\(settings.defaultSplitPeople())"
                (cell as! DefaultTipTableViewCell).tipTextField.tag = TipTextFieldTag.defaultSplit.rawValue
            } else {
                (cell as! DefaultTipTableViewCell).tipLabel.text = "Maximum Party"
                (cell as! DefaultTipTableViewCell).tipTextField.text = "\(settings.maximumSplitPeople())"
                (cell as! DefaultTipTableViewCell).tipTextField.tag = TipTextFieldTag.maximumSplit.rawValue
            }
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell", for: indexPath)
            (cell as! ThemeTableViewCell).themeSwitch.isOn = settings.isDarkTheme()
            (cell as! ThemeTableViewCell).themeSwitch.addTarget(self, action: #selector(SettingsViewController.darkThemeChanged(_:)), for: .valueChanged)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "LocaleTableViewCell", for: indexPath)
            (cell as! LocaleTableViewCell).localeLabel.text = localeIdentifiers[indexPath.row]
            if settings.localeString() == identifiers[indexPath.row] {
                cell.accessoryType = .checkmark
                lastLocaleIndexPath = indexPath
            } else {
                cell.accessoryType = .none
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Tip Amount"
        } else if section == 1 {
            return "Party Size"
        } else if section == 2 {
            return "Theme"
        } else {
            return "Locale"
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let localeString = identifiers[indexPath.row]
            settings.setLocaleString(localeString: localeString)
            
            let selectedCell = tableView.cellForRow(at: indexPath) as! LocaleTableViewCell
            selectedCell.accessoryType = .checkmark
            
            if let lastIndexPath = lastLocaleIndexPath {
                if lastIndexPath != indexPath {
                    let lastSelectedCell = tableView.cellForRow(at: lastIndexPath)
                    lastSelectedCell?.accessoryType = .none
                }
                
            }
            
            lastLocaleIndexPath = indexPath
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        var tip: Int
        if textField.tag == TipTextFieldTag.minimumTip.rawValue {
            tip = settings.setMinimumTip(minimumTip: Int(textField.text!)!)
        } else if textField.tag == TipTextFieldTag.defaultTip.rawValue {
            tip = settings.setDefaultTip(defaultTip: Int(textField.text!)!)
        } else if textField.tag == TipTextFieldTag.maximumTip.rawValue {
            tip = settings.setMaximumTip(maximumTip: Int(textField.text!)!)
        } else if textField.tag == TipTextFieldTag.defaultSplit.rawValue {
            tip = settings.setDefaultSplitPeople(defaultSplitPeople: Int(textField.text!)!)
        } else {
            tip = settings.setMaximumSplitPeople(maximumSplitPeople: Int(textField.text!)!)
        }
        
        textField.text = "\(tip)"
    }
}
