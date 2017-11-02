//
//  FirstViewController.swift
//  Office Walk Reminder
//
//  Created by Local on 10/12/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class FirstViewController: UIViewController {
    
    //MARK: Instance variables
    static var requiredContinuousStepsForASuccessfulWalk    = UserDefaults.standard.value(forKey: "numberOfSteps") as! Int
    static var dailyWorkStartTime                           = UserDefaults.standard.value(forKey: "workStartTime") as! Date
    static var dailyWorkEndTime                             = UserDefaults.standard.value(forKey: "workEndTime") as! Date
    static var intervalUntilFirstReminderInMinutes          = UserDefaults.standard.value(forKey: "firstInterval") as! Int
    static var intervalAfterFirstReminderInMinutes          = UserDefaults.standard.value(forKey: "repeatedInterval") as! Int

    
    static var timerStartTime = Calendar.current.startOfDay(for: Date())
    var currentWalkSteps: Double! = 0
    var lastSuccessfulWalkTime = Calendar.current.startOfDay(for: Date())
    var lastSuccessfulWalkSteps: Double! = 0
    var lastWalkTime = Calendar.current.startOfDay(for: Date())
    var lastWalkSteps: Double! = 0
    var todayTotalSteps: Double! = 0
    
    //MARK: Properties
    @IBOutlet weak var labelTotalSteps: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelLastSuccessfulWalkStep: UILabel!
    @IBOutlet weak var labelLastSuccessfulWalkTime: UILabel!
    @IBOutlet weak var labelLastWalkSteps: UILabel!
    @IBOutlet weak var labelLastWalkTime: UILabel!
    @IBOutlet weak var buttonResetTimer: UIButton!
    @IBOutlet weak var labelCurrentWalkSteps: UILabel!
    @IBOutlet weak var labelNextReminder: UILabel!
    
    //MARK: Actions
    @IBAction func buttonResetTimerTouchUpInside(_ sender: UIButton) {
        // Reset the timer to 0
        FirstViewController.timerStartTime = timeWithoutSeconds(time: Date())
        labelNextReminder.text = timeFormat(nextReminderTime())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start listening for updates immediately. If any updates, getNewStepsDataThenUpdateView() will be called
        HealthKitManager().listenForStepsUpdate(view: self)
        
        // Start updating the timer every 0.5 secnds
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FirstViewController.reloadSettings()
        updateStepsDataAndUpdateView()
    }
    
    static func reloadSettings() {
        FirstViewController.requiredContinuousStepsForASuccessfulWalk    = UserDefaults.standard.value(forKey: "numberOfSteps") as! Int
        FirstViewController.dailyWorkStartTime                           = UserDefaults.standard.value(forKey: "workStartTime") as! Date
        FirstViewController.dailyWorkEndTime                             = UserDefaults.standard.value(forKey: "workEndTime") as! Date
        FirstViewController.intervalUntilFirstReminderInMinutes          = UserDefaults.standard.value(forKey: "firstInterval") as! Int
        FirstViewController.intervalAfterFirstReminderInMinutes          = UserDefaults.standard.value(forKey: "repeatedInterval") as! Int
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func fetch(_ completion: () -> Void){
        completion()
    }
    
    func timeWithoutSeconds(time: Date) -> Date {
        let timeDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        return Calendar.current.date(from: timeDateComponents)!
    }
    
    func dailyTimeOfToday(dailyWorkHour: Date) -> Date {
        let today = Date()
        let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        let dailyWorkHourDateComponents = Calendar.current.dateComponents([.hour, .minute], from: dailyWorkHour)
        
        let dailyTimeOfTodayDateComponents = DateComponents(
            year    : todayDateComponents.year,
            month   : todayDateComponents.month,
            day     : todayDateComponents.day,
            hour    : dailyWorkHourDateComponents.hour,
            minute  : dailyWorkHourDateComponents.minute
        )
        
        return Calendar.current.date(from: dailyTimeOfTodayDateComponents)!
    }
    
    func nextReminderTime() -> Date {
        let now = timeWithoutSeconds(time: Date())
        var nextReminderTime: Date = Calendar.current.date(byAdding: .minute, value: FirstViewController.intervalUntilFirstReminderInMinutes, to: FirstViewController.timerStartTime)!
        
        while now >= nextReminderTime {
            nextReminderTime = Calendar.current.date(byAdding: .minute, value: FirstViewController.intervalAfterFirstReminderInMinutes, to: nextReminderTime)!
        }
        
        let todayStartTime = dailyTimeOfToday(dailyWorkHour: FirstViewController.dailyWorkStartTime)
        let todayEndTime = dailyTimeOfToday(dailyWorkHour: FirstViewController.dailyWorkEndTime)
        let tomorrowStartTime = Calendar.current.date(byAdding: .day, value: 1, to: todayStartTime)!
        
        nextReminderTime = nextReminderTime < todayStartTime ? todayStartTime : nextReminderTime
        nextReminderTime = nextReminderTime > todayEndTime ? tomorrowStartTime: nextReminderTime
        
        return nextReminderTime
    }
    
    func updateStepsDataAndUpdateView() {
        updateStepsDataFromHealthKit()
        
        // wait for updateStepsFromHealthKit to finish updating instance variables with new data
        sleep(1)
        
        updateFirstView()
    }
    
    func updateFirstView() {
        labelNextReminder.text = timeFormat(nextReminderTime())
        labelTotalSteps.text = String(Int(todayTotalSteps))
        labelLastWalkSteps.text = String(Int(lastWalkSteps))
        labelLastWalkTime.text = timeFormat(lastWalkTime)
        labelLastSuccessfulWalkStep.text = String(Int(lastSuccessfulWalkSteps))
        labelLastSuccessfulWalkTime.text = timeFormat(lastSuccessfulWalkTime)
    }
    
    func timeFormat(_ time: Date) -> String {
        let timeFormat : DateFormatter = DateFormatter()
        timeFormat.dateFormat = "hh:mm a"
        
        return timeFormat.string(from: time)
    }

    func bannerNotifyNow(){
        let content = UNMutableNotificationContent()
        content.title = "Last succesful walk: " + String(Int(Date().timeIntervalSince(lastSuccessfulWalkTime)/60)) + "' ago - " + String(Int(lastSuccessfulWalkSteps)) + " steps"
        content.subtitle = "Last walk: " + String(Int(Date().timeIntervalSince(lastWalkTime)/60)) + "' ago - " + String(Int(lastWalkSteps)) + " steps"
        content.body = "Today steps: " + String(Int(todayTotalSteps)) + " steps"
        
        // Notify in a second from now
        let date = Calendar.current.date(byAdding: .second, value: 1, to: Date())
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let identifier = "ReminderToWalk"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        vibrate()
        print(timeFormat(date!), "bannerNotifyNow")
    }
    
    func updateStepsDataFromHealthKit() {
        HealthKitManager().getAllStepsUpdates() { todayTotalSteps, lastSuccessfulWalkSteps, lastSuccessfulWalkTime, lastWalkSteps, lastWalkTime, error in
            
            self.todayTotalSteps = todayTotalSteps
            self.lastSuccessfulWalkSteps = lastSuccessfulWalkSteps
            self.lastSuccessfulWalkTime = lastSuccessfulWalkTime
            self.lastWalkSteps = lastWalkSteps
            self.lastWalkTime = lastWalkTime
           
            if lastSuccessfulWalkTime > FirstViewController.timerStartTime {
                // No need to use timeWithoutSeconds as time retrieved from HealthKit already does not include seconds
                FirstViewController.timerStartTime = lastSuccessfulWalkTime
            }
        }
    }

    @objc func updateTimer() {
        let now = Date()
        let intervalInSeconds = now.timeIntervalSince(FirstViewController.timerStartTime)
        
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
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        feedbackGenerator.impactOccurred()
        feedbackGenerator.impactOccurred()
    }
}
