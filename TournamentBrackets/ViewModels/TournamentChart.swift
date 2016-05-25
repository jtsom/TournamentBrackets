//
//  TournamentChart.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

enum TournamentChart : Int, CustomStringConvertible {
    case Played, PlayedPerTeam, Won, Earned, Conceded
    
    var description: String {
        get {
            switch self {
            case .Played:
                return "GAMES PLAYED"
            case .PlayedPerTeam:
                return "GAMED PLAYED PER TEAM"
            case .Won:
                return "GAMES WON"
            case .Earned:
                return "POINTS EARNED"
            case .Conceded:
                return "POINTS CONCEDED"
            }
        }
    }
    
    static var all : [TournamentChart] {
        get {
            return [.Played, .PlayedPerTeam, Won, Earned, Conceded]
        }
    }
}