//
//  GameViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 13/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class GameViewModel {
    
    var realm = try! Realm()
    var winner : Variable<Team?> = Variable(nil)
    var leftTeam : Variable<Team?> = Variable(nil)
    var rightTeam : Variable<Team?> = Variable(nil)
    lazy var disposeBag: DisposeBag? = { return DisposeBag() }()
    var game : Game!
    var gamesCount = 0
    var leftScore : String = "" {
        didSet {
            let score = leftScore.characters.count > 0 ? leftScore : "0"
            if let s = Int(score) {
                try! realm.write{
                    game.leftScore = s
                }
            }
        }
    }
    var rightScore : String = "" {
        didSet {
            let score = rightScore.characters.count > 0 ? rightScore : "0"
            if let s = Int(score) {
                try! realm.write{
                    game.rightScore = s
                }
            }
        }
    }
    var prevLeftGameViewModel : GameViewModel? = nil {
        didSet {
            if let prevModel = prevLeftGameViewModel {
                prevModel.winner
                    .asObservable()
                    .subscribeNext { [unowned self] newWinner in
                        
                        // We are only concerned about elimination schedule types. Speifically double elimination and future games with
                        // right previous game.
                        guard let elimination = self.game.elimination, prevLeftGame = elimination.prevLeftGame else { return }
                        var newLoser : Team? = (newWinner == nil) ? nil : prevLeftGame.opposite(newWinner)
                        
                        // Which team are we observing, the winner or the loser? This depends on the game index
                        if prevModel.index >= elimination.firstLoserIndex {
                            newLoser = newWinner
                        }
                        
                        // Will the placeholder value change?
                        guard  (!elimination.isLoserBracket && newWinner != self.game.leftTeam)
                            || (elimination.isLoserBracket && newLoser != self.game.leftTeam)  else { return }
                        let team : Team? = ( elimination.isLoserBracket ) ? newLoser : newWinner
                        
                        // Change it!
                        self.winner.value = nil
                        self.leftTeam.value = team
                        try! self.realm.write {
                            self.game.winner = nil
                            self.game.leftTeam = team
                            self.game.isDraw = false
                            self.game.calculateHandicap()
                        }
                    }
                    .addDisposableTo(disposeBag!)
            }
        }
    }
    
    var prevRightGameViewModel : GameViewModel? = nil {
        didSet {
            if let prevModel = prevRightGameViewModel {
                prevModel.winner
                    .asObservable()
                    .subscribeNext { [unowned self] newWinner in
                        
                        guard let elimination = self.game.elimination, prevRightGame = elimination.prevRightGame else { return }
                        var newLoser : Team? = (newWinner == nil) ? nil : prevRightGame.opposite(newWinner)
                        
                        if prevModel.index >= elimination.firstLoserIndex {
                            newLoser = newWinner
                        }
                        
                        guard  (!elimination.isLoserBracket && newWinner != self.game.rightTeam)
                            || (elimination.isLoserBracket && newLoser != self.game.rightTeam)  else { return }
                        let team : Team? = ( elimination.isLoserBracket ) ? newLoser : newWinner
                        self.winner.value = nil
                        self.rightTeam.value = team
                        try! self.realm.write {
                            self.game.winner = nil
                            self.game.rightTeam = team
                            self.game.isDraw = false                            
                            self.game.calculateHandicap()
                        }
                    }
                    .addDisposableTo(disposeBag!)
            }
        }
    }
    
    var isFinalElimination: Bool {
        get {
            if let _ = game.elimination {
                return game.index == self.gamesCount
            } else {
                return false
            }
        }
    }
    
    var isLoserBracket : Bool {
        get {
            return game.elimination?.isLoserBracket ?? false
        }
    }
    
    var leftPrompt : String {
        get {
            return game.leftPrompt
        }
    }
    
    var rightPrompt : String {
        get {
            return game.rightPrompt
        }
    }
    
    var index : Int {
        get {
            return game.index
        }
    }

    init(game : Game, gamesCount : Int) {
        self.game = game
        self.gamesCount = gamesCount
        self.winner.value = game.winner
        self.leftTeam.value = game.leftTeam
        self.rightTeam.value = game.rightTeam
        
        self.leftTeam
            .asObservable()
            .subscribeNext { [unowned self] someTeam in
                if let team = someTeam where self.game.rightPrompt == "BYE" {
                    self.winner.value = team
                    try! self.realm.write {
                        self.game.winner = team
                    }
                }
            }
            .addDisposableTo(self.disposeBag!)
        
        self.rightTeam
            .asObservable()
            .subscribeNext { [unowned self] someTeam in
                if let team = someTeam where self.game.leftPrompt == "BYE" {
                    self.winner.value = team
                    try! self.realm.write {
                        self.game.winner = team
                    }
                }
            }
            .addDisposableTo(self.disposeBag!)
    }
    
    func setLeftTeamAsWinner() {
        guard self.rightPrompt != "BYE" && self.rightPrompt.characters.count > 0 else { return }
        
        self.winner.value = leftTeam.value
        try! self.realm.write {
            self.game.winner = self.winner.value
            self.game.isDraw = false
        }
    }
    
    func setRightTeamAsWinner() {
        guard self.leftPrompt != "BYE" && self.leftPrompt.characters.count > 0 else { return }
        
        self.winner.value = rightTeam.value
        try! self.realm.write {
            self.game.winner = self.winner.value
            self.game.isDraw = false
        }
    }
    
    func setDrawn() {
        guard let _ = leftTeam.value, _ = rightTeam.value else { return }
        
        self.leftScore = ""
        self.rightScore = ""
        self.winner.value = nil
        try! self.realm.write {
            self.game.winner = nil
            self.game.isDraw = true
        }
    }
}


extension Game {
    
    func opposite(team: Team?) -> Team? {
        if team == self.leftTeam {
            return self.rightTeam
        } else if team == self.rightTeam {
            return self.leftTeam
        } else {
            return nil
        }
    }
    
    var isBothBye : Bool {
        get {
            return leftPrompt == "BYE" && rightPrompt == "BYE"
        }
    }
    
    var leftPrompt : String {
        get {
            if let l = leftTeam {
                if let d = doubles, l2 = d.leftTeam2 {
                    let first = String.sevenChars(ofString: l.name)
                    let second = String.sevenChars(ofString: l2.name)
                    return "\(first)/\(second)"
                } else {
                    return l.name
                }
            } else if let _ = rightTeam where leftTeam == nil && self.isBye {
                return "BYE"
            } else if let e = elimination, left = e.prevLeftGame, leftE = left.elimination
                where e.isLoserBracket && (left.isBye && left.index < leftE.firstLoserIndex || left.isBothBye) {
                
                return "BYE"
            } else {
                return ""
            }
        }
    }
    
    var rightPrompt : String {
        get {
            if let r = rightTeam {
                if let d = doubles, r2 = d.rightTeam2 {
                    let first = String.sevenChars(ofString: r.name)
                    let second = String.sevenChars(ofString: r2.name)
                    return "\(first)/\(second)"
                } else {
                    return r.name
                }
            } else if let _ = leftTeam where rightTeam == nil && self.isBye {
                return "BYE"
            } else if let e = elimination, right = e.prevRightGame, rightE = right.elimination
                where e.isLoserBracket && (right.isBye && right.index < rightE.firstLoserIndex || right.isBothBye) {
                
                return "BYE"
            } else {
                return ""
            }
        }
    }
    
}