//
//  NumberOfStepsViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 10/31/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit

class NumberOfStepsViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var textfieldNumberOfSteps: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfSteps = UserDefaults.standard.value(forKey: "numberOfSteps") as! Int
        textfieldNumberOfSteps.text = String(numberOfSteps)
        
        [self.textfieldNumberOfSteps .becomeFirstResponder()]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let numberOfSteps = Int(textfieldNumberOfSteps.text!)
        UserDefaults.standard.set(numberOfSteps, forKey: "numberOfSteps")
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
