//
//  SecondViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 10/12/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    @IBOutlet weak var tableviewRequiredSteps: UITableView!
    @IBOutlet weak var tableviewDailyWorkHours: UITableView!
    @IBOutlet weak var tableviewReminderInterval: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableviewRequiredSteps.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

