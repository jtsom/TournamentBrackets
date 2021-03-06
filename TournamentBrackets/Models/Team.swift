//
//  Team.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 04/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

class Team : Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var name = ""
    dynamic var isHandicapped = false
    dynamic var handicap = 0
    dynamic var seed = 0
    
    convenience init(name : String, seed : Int, isHandicap : Bool) {
        self.init()
        self.name = name
        self.seed = seed
        self.isHandicapped = isHandicap
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}