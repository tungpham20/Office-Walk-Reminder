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
    
    func getTodayTotalSteps(completion: @escaping (Double, Error?) -> ()) {
        let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today)
        let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: today, options: [])
        
        let stepsQuery = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var todayTotalSteps: Double = 0

            if results != nil {
                for result in results as! [HKQuantitySample] {
                    todayTotalSteps += result.quantity.doubleValue(for: HKUnit.count())
                    print(result.quantity.doubleValue(for: HKUnit.count()), result.startDate)
                }
            }
            
            completion(todayTotalSteps, error)
        }
        
        healthStore.execute(stepsQuery)
    }
    
    func getLastWalk(completion: @escaping (Double, Date, Error?) -> ()) {
        
        let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today)
        let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: today, options: [])
        
        let stepsQuery = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var lastWalkSteps: Double = 0
            var lastWalkTime: Date = startOfToday
            
            if results != nil {
                for result in results as! [HKQuantitySample] {
                    lastWalkSteps = result.quantity.doubleValue(for: HKUnit.count())
                    lastWalkTime = result.startDate
                }
            }
            
            completion(lastWalkSteps, lastWalkTime, error)
        }
        
        healthStore.execute(stepsQuery)
    }

    func getLastSuccessfulWalk(completion: @escaping (Double, Date, Error?) -> ()) {
        
        let requiredContinuousSteps = Double(300)
        
        let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today)
        let predicate = HKQuery.predicateForSamples(withStart: startOfToday, end: today, options: [])
        
        let stepsQuery = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var lastSuccessfulWalkSteps: Double = 0
            var lastSuccessfulWalkTime: Date = startOfToday
            
            if results != nil {
                for result in results as! [HKQuantitySample] {
                    let lastWalkSteps = result.quantity.doubleValue(for: HKUnit.count())
                    let lastWalkTime = result.startDate
                    
                    if lastWalkSteps >= requiredContinuousSteps {
                        lastSuccessfulWalkSteps = lastWalkSteps
                        lastSuccessfulWalkTime = lastWalkTime
                    }
                }
            }
            
            completion(lastSuccessfulWalkSteps, lastSuccessfulWalkTime, error)
        }
        
        healthStore.execute(stepsQuery)
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
                    //print(lastWalkSteps, lastWalkTime)
                }
            }
            
            completion(todayTotalSteps, lastSuccessfulWalkSteps, lastSuccessfulWalkTime, lastWalkSteps, lastWalkTime, error)
        }
        
        healthStore.execute(stepsQuery)
    }

    
    
    func listenForStepsUpdate() {
        let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let stepsUpdateQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { query, completionHandler, error in
            if error != nil {
                print("Error listening for steps update")
            }
            
            print("Steps got updated!")
            self.getTodayTotalSteps() { todayTotalSteps, error in
                print("Total = " + String(Int(todayTotalSteps)))
            }
        }
        
        healthStore.execute(stepsUpdateQuery)
    }
}
