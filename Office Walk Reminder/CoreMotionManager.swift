//
//  CoreMotionManager.swift
//  Office Walk Reminder
//
//  Created by Local on 10/18/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import Foundation
import CoreMotion

class CoreMotionManager {
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    func getCurrentWalkSteps() {
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today)
        
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startEventUpdates(handler: {pedometerEvent, error in
                print(pedometerEvent?.date)
            })
        }
    }
}
