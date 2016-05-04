//
//  ScheduleType.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 03/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

enum ScheduleType : Int {
    case RoundRobin = 0
    case RoundDoubles
    case SingleElimination
    case DoubleElimination
    
    var allowedTeamCounts : [Int] {
        get {
            switch self {
            case .RoundRobin : return (2..<33).map { $0 }
            case .RoundDoubles : return (4..<33).filter{ ($0 % 4) != 2 }.map { $0 }
            case .SingleElimination : return (2..<33).map { $0 }
            case .DoubleElimination : return (2..<33).map { $0 }
            }
        }
    }
    
    var description : String {
        get {
            switch self {
            case .RoundRobin : return "Round Robin"
            case .RoundDoubles : return "Round Doubles"
            case .SingleElimination : return "Single Elimination"
            case .DoubleElimination : return "Double Elimination"
            }
        }
    }
    
    static func schedules() -> [ScheduleType] {
        return [ .RoundRobin, .RoundDoubles, .SingleElimination, .DoubleElimination ]
    }
}