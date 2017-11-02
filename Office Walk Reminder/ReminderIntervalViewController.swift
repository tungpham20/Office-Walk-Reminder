//
//  ReminderIntervalViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 11/2/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit

class ReminderIntervalViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var textfieldFirstInterval: UITextField!    
    @IBOutlet weak var textfieldRepeatedInterval: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let firstInterval       = UserDefaults.standard.value(forKey: "firstInterval") as! Int
        let repeatedInterval    = UserDefaults.standard.value(forKey: "repeatedInterval") as! Int
        
        textfieldFirstInterval.text     = String(firstInterval)
        textfieldRepeatedInterval.text  = String(repeatedInterval)
        
        [self.textfieldFirstInterval .becomeFirstResponder()]
    }

    override func viewDidDisappear(_ animated: Bool) {
        let firstInterval = Int(textfieldFirstInterval.text!)
        let repeatedInterval = Int(textfieldRepeatedInterval.text!)
        
        UserDefaults.standard.set(firstInterval, forKey: "firstInterval")
        UserDefaults.standard.set(repeatedInterval, forKey: "repeatedInterval")
        
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
