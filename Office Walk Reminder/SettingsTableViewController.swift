//
//  SettingsTableViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 11/1/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: Properties
    @IBOutlet weak var labelNumberOfSteps: UILabel!
    @IBOutlet weak var labelWorkStartTime: UILabel!
    @IBOutlet weak var labelWorkEndTime: UILabel!
    @IBOutlet weak var labelFirstInterval: UILabel!
    @IBOutlet weak var labelRepeatedInterval: UILabel!
    
    // MARK: Actions
    @IBAction func resetButtonTouchUpInside(_ sender: UIButton) {
        
        let resetAlert = UIAlertController(title: "Reset to default settings", message: "", preferredStyle: UIAlertControllerStyle.alert)
        resetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(ACTION: UIAlertAction!) in
            let defaults = UserDefaults.standard
            
            defaults.set(AppDelegate.defaultNumberOfSteps   , forKey: "numberOfSteps")
            defaults.set(AppDelegate.defaultWorkStartTime   , forKey: "workStartTime")
            defaults.set(AppDelegate.defaultWorkEndTime     , forKey: "workEndTime")
            defaults.set(AppDelegate.defaultFirstInterval   , forKey: "firstInterval")
            defaults.set(AppDelegate.defaultRepeatedInterval, forKey: "repeatedInterval")
            
            self.loadSetting()
        }))
        resetAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(ACTION: UIAlertAction!) in

        }))
        present(resetAlert, animated: true, completion: nil)        

    }
    
    func loadSetting() {
        let defaults = UserDefaults.standard
        let numberOfSteps       = defaults.value(forKey: "numberOfSteps") as! Int
        let workStartTime       = defaults.value(forKey: "workStartTime") as! Date
        let workEndTime         = defaults.value(forKey: "workEndTime") as! Date
        let firstInterval       = defaults.value(forKey: "firstInterval") as! Int
        let repeatedInterval    = defaults.value(forKey: "repeatedInterval") as! Int
        
        labelNumberOfSteps.text     = String(numberOfSteps) + " steps"
        labelWorkStartTime.text     = getHourMinute(workStartTime)
        labelWorkEndTime.text       = getHourMinute(workEndTime)
        labelFirstInterval.text     = String(firstInterval) + " minutes"
        labelRepeatedInterval.text  = String(repeatedInterval) + " minutes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadSetting()
        FirstViewController.reloadSettings()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHourMinute(_ time: Date) -> String {
        let timeFormat : DateFormatter = DateFormatter()
        timeFormat.dateFormat = "hh:mm a"
        
        return timeFormat.string(from: time)
    }
}
