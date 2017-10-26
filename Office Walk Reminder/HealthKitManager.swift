//
//  HealthKitManager.swift
//  Office Walk Reminder
//
//  Created by Local on 10/12/17.
//  Copyright © 2017 Tung Pham. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
   
    let healthStore = HKHealthStore()
    
    init(){
        authorizeHealthKit()
    }
    
    func authorizeHealthKit() -> Bool {
        var isEnabled = true
        
        if HKHealthStore.isHealthDataAvailable() {
            let stepCount = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
            
            healthStore.requestAuthorization(toShare: nil, read: stepCount as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
                //print("isEnabled")
            }
        }
        else {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func getAllStepsUpdates(completion: @escaping (Double, Double, Date, Double, Date, Error?) -> ()) {
        
        let requiredContinuousSteps = Double(300)
        
        let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today)
        let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: today, options: [])
        
        let stepsQuery = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var todayTotalSteps: Double = 0
            var lastSuccessfulWalkSteps: Double = 0
            var lastSuccessfulWalkTime: Date = startOfToday
            var lastWalkSteps: Double = 0
            var lastWalkTime: Date = startOfToday
            
            if results != nil {
                for result in results as! [HKQuantitySample] {
                    lastWalkSteps = result.quantity.doubleValue(for: HKUnit.count())
                    lastWalkTime = result.startDate
                    
                    if lastWalkSteps >= requiredContinuousSteps {
                        lastSuccessfulWalkSteps = lastWalkSteps
                        lastSuccessfulWalkTime = lastWalkTime
                    }
                    
                    todayTotalSteps += lastWalkSteps
                }
            }

            completion(todayTotalSteps, lastSuccessfulWalkSteps, lastSuccessfulWalkTime, lastWalkSteps, lastWalkTime, error)
        }
        
        healthStore.execute(stepsQuery)
    }

    
    
    func listenForStepsUpdate(view: FirstViewController) {
        let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let stepsUpdateQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { query, completionHandler, error in
            if error != nil {
                print("Error listening for steps update")
            }
            //print("listenForStepsUpdate")
            DispatchQueue.main.async {
                view.updateStepsDataAndUpdateView()
            }
        }
        
        healthStore.execute(stepsUpdateQuery)
    }
}
