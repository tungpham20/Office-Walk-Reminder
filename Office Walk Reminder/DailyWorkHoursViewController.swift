//
//  WorkHoursViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 11/1/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit

class DailyWorkHoursViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var datePickerWorkStartTime: UIDatePicker!
    @IBOutlet weak var datePickerWorkEndTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let workStartTime = UserDefaults.standard.value(forKey: "workStartTime") as! Date
        let workEndTime = UserDefaults.standard.value(forKey: "workEndTime") as! Date

        datePickerWorkStartTime.date = workStartTime
        datePickerWorkEndTime.date = workEndTime
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let workStartTime = datePickerWorkStartTime.date
        let workEndTime = datePickerWorkEndTime.date
        
        UserDefaults.standard.set(workStartTime, forKey: "workStartTime")
        UserDefaults.standard.set(workEndTime, forKey: "workEndTime")
        
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

}
