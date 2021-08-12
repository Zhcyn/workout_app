//
//  Models.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 12/08/2021.
//

import Foundation

enum workoutState {
    case pause
    case resume
}

class Exercise {
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

class CompletedWorkout {
    var name: String?
    var total_time: Int? //TODO: the same as above
    
    init(name: String, total_time: Int? ) { //maybe use  convenience init?
        self.name = name
        self.total_time = total_time
    }
}

class InitialWorkoutsData {
    var total_time: Int? //int?
    var exercises:[Exercise]?
    var setup_sequance: String?
    var re_setup_sequance: [ReSetupSeq]?
    
    
}

struct ReSetupSeq {
    var type: String?
    var code: Int?
    
    init(type: String?, code: Int?) {
        self.type = type
        self.code = code
    }
}

class CompletedWorkoutsData {
    var total_time_completed: Int?
    var exercises_cpmleted: [CompletedWorkout]?
    
}
