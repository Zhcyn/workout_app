//
//  Utils.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation
import UIKit

class Utils {
    
    public static func saveExercisesToUserDefaults(exercises: [Exercise]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(exercises) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.exercisesKey)
        }
    }
    
    public static func getExercisesFromUserDefaults() -> [Exercise]? {
        if let savedExercises = UserDefaults.standard.object(forKey: UserDefaultsKeys.exercisesKey) as? Data {
            let decoder = JSONDecoder()
            if let exercises = try? decoder.decode([Exercise].self, from: savedExercises) {
                return exercises
            }
        }
        return nil
    }
    
    public static func calculateSucessPercentage(workoutTotalTime: Int, completedTime: Int)-> Int {
        let res = Double(completedTime) / Double(workoutTotalTime)
        return Int(res * 100)
    }
    
}
