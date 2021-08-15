//
//  Models.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation

enum SequanceState {
    case setup
    case reSetupInside
    case reSetupBetween
}

struct Exercise : Codable {
    var name: String
    var startTime: Int
    var totalTime: Int
    
    init(name: String, startTime: Int, totalTime: Int) {
        self.name = name
        self.startTime = startTime
        self.totalTime = totalTime
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case startTime = "start_time"
        case totalTime = "total_time"
    }
}

struct CompleteExercise : Codable {
    var name: String
    var totalTime: Int
    
    init(name: String, totalTime: Int) {
        self.name = name
        self.totalTime = totalTime
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case totalTime = "total_time"
    }
}

struct InitialWorkoutsData : Codable {
    var totalTime: Int
    var exercises:[Exercise]
    var setupSeq: String
    var reSetupSeq: [ReSetupSeq]
    
    init(totalTime: Int, exercises: [Exercise], setupSeq: String, reSetupSeq: [ReSetupSeq]) {
        self.totalTime = totalTime
        self.exercises = exercises
        self.setupSeq = setupSeq
        self.reSetupSeq = reSetupSeq
    }
    
    enum CodingKeys: String, CodingKey {
        case totalTime = "total_time"
        case exercises
        case setupSeq = "setup_sequence"
        case reSetupSeq = "re_setup_sequence"
    }
}

struct ReSetupSeq : Codable {
    var type: String
    var code: Int
    
    init(type: String, code: Int) {
        self.type = type
        self.code = code
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case code
    }
}

struct CompletedWorkoutsData : Codable {
    var totalTimeCompleted: Int
    var exercisesCompleted: [CompleteExercise?]
    
    init(totalTimeCompleted: Int, exercisesCompleted: [CompleteExercise?]) {
        self.totalTimeCompleted = totalTimeCompleted
        self.exercisesCompleted = exercisesCompleted
    }
    
    enum CodingKeys: String, CodingKey {
        case totalTimeCompleted = "total_time_completed"
        case exercisesCompleted = "exercises_completed"
    }
    
}
