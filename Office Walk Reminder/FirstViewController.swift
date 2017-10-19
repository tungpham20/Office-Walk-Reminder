//
//  FirstViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 10/12/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var requiredContinuousSteps = 300
    var timerStartTime = Calendar.current.startOfDay(for: Date())
    var currentWalkSteps: Double! = 0
    var lastSuccessfulWalkTime = Calendar.current.startOfDay(for: Date())
    var lastSuccessfulWalkSteps: Double! = 0
    var lastWalkTime = Calendar.current.startOfDay(for: Date())
    var lastWalkSteps: Double! = 0
    var todayTotalSteps: Double! = 0
    
    
    //MARK: Properties
    @IBOutlet weak var labelTotalSteps: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buttonVibrate: UIButton!
    @IBOutlet weak var labelLastSuccessfulWalkStep: UILabel!
    @IBOutlet weak var labelLastSuccessfulWalkTime: UILabel!
    @IBOutlet weak var labelLastWalkSteps: UILabel!
    @IBOutlet weak var labelLastWalkTime: UILabel!
    @IBOutlet weak var buttonResetTimer: UIButton!
    @IBOutlet weak var labelCurrentWalkSteps: UILabel!
    
    //MARK: Actions
    @IBAction func buttonVibrateTouchUpInside(_ sender: UIButton) {
        vibrate()
    }
    @IBAction func buttonResetTimerTouchUpInside(_ sender: UIButton) {
        self.timerStartTime = Date()
        updateTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        HealthKitManager().listenForStepsUpdate()
        updateStepsFromHealthKit()
        
        let timeFormat : DateFormatter = DateFormatter()
        timeFormat.dateFormat = "hh:mm a"
        
        labelTotalSteps.text = String(Int(todayTotalSteps))
        labelLastWalkSteps.text = String(Int(lastWalkSteps))
        labelLastWalkTime.text = timeFormat.string(from: lastWalkTime)
        labelLastSuccessfulWalkStep.text = String(Int(lastSuccessfulWalkSteps))
        labelLastSuccessfulWalkTime.text = timeFormat.string(from: lastSuccessfulWalkTime)
        
        updateTimer()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateStepsFromHealthKit() {
        HealthKitManager().getAllStepsUpdates() { todayTotalSteps, lastSuccessfulWalkSteps, lastSuccessfulWalkTime, lastWalkSteps, lastWalkTime, error in
            self.todayTotalSteps = todayTotalSteps
            self.lastSuccessfulWalkSteps = lastSuccessfulWalkSteps
            self.lastSuccessfulWalkTime = lastSuccessfulWalkTime
            self.lastWalkSteps = lastWalkSteps
            self.lastWalkTime = lastWalkTime
           
            self.timerStartTime = lastSuccessfulWalkTime > self.timerStartTime ? lastSuccessfulWalkTime : self.timerStartTime
        }
    }

    @objc func updateTimer() {
        let now = Date()
        let intervalInSeconds = now.timeIntervalSince(self.timerStartTime)
        
        var hours = String(Int(intervalInSeconds/3600))
        var minutes = String(Int((intervalInSeconds/60).truncatingRemainder(dividingBy: 60)))
        var seconds = String(Int(intervalInSeconds.truncatingRemainder(dividingBy: 60)))
        
        hours = (hours.count == 1) ? "0"+hours : hours
        minutes = (minutes.count == 1) ? "0"+minutes : minutes
        seconds = (seconds.count == 1) ? "0"+seconds : seconds
        
        timeLabel.text = hours + ":" + minutes + ":" + seconds
    }
    
    func vibrate() {
        print("Vibrate!!!")
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        feedbackGenerator.selectionChanged()
        feedbackGenerator.selectionChanged()
    }
}
