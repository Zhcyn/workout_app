//
//  Models.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation

enum WorkoutState {
    case pause
    case resume
}

enum SequanceState {
    case setup
    case re_setup
}

struct Exercise : Codable {
    var name: String?
    var start_time: Int? //TODO: think about which type to use
    var total_time: Int? //TODO: the same as above
    
    init(name: String?, start_time: Int?, total_time: Int? ) { //maybe use  convenience init?
        self.name = name
        self.start_time = start_time
        self.total_time = total_time
    }
//
//    convenience init?(dict: RawJsonFormat?) {
//        guard let lat = dict?["latitude"] as? String,let long = dict?["longitude"] as? String else {
//            return nil
//        }
//
//        self.init(latitude:lat,longitude:long)
//    }
    
    //Geters and setters funcs
    
}

struct CompletedWorkout : Codable {
    var name: String?
    var total_time: Int? //TODO: the same as above
    
    init(name: String, total_time: Int? ) { //maybe use  convenience init?
        self.name = name
        self.total_time = total_time
    }
}

struct InitialWorkoutsData : Codable {
    var total_time: Int? //int?
    var exercises:[Exercise]?
    var setup_sequance: String?
    var re_setup_sequance: [ReSetupSeq]?
    
    
}

struct ReSetupSeq : Codable {
    var type: String?
    var code: Int?
    
    init(type: String?, code: Int?) {
        self.type = type
        self.code = code
    }
}

struct CompletedWorkoutsData : Codable {
    var total_time_completed: Int?
    var exercises_cpmleted: [CompletedWorkout]?
    
}
