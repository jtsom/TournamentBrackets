//
//  Test_03SchedulerSpec_SingleElimination.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 27/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift
import Quick
import Nimble
@testable import TournamentBrackets

class Test_03SchedulerSpec_SingleElimination : QuickSpec {
    override func spec() {
        
        beforeEach {
        }
        
        afterEach {
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///
        /// VALUE TYPE SINGLE ELIMINATION
        ///
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        func valuedSingleElimination<TeamType>(teams : [TeamType?]) -> [String] {
            let finals = Scheduler.valuedSingleElimination(1, teams: teams)
            var m = finals.flatten()
            m.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }
            return m.map{ (g) in return "R\(g.round).\(g.index).\(g.versus)"}
        }
        
        it("schedules value type single elimination with 00 team") {
            let teams : [Int?] = []
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(1))
            let first = matches.first
            if let f = first {
                expect(f).to(equal("R1.1.v"))
            }
        }
        
        it("schedules value type single elimination with 01 team") {
            let teams : [Int?] = [1]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(1))
            let first = matches.first
            if let f = first {
                expect(f).to(equal("R1.1.1vB"))
            }
        }
        
        it("schedules value type single elimination with 02 teams") {
            let teams : [Int?] = [1,2]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(1))
            let first = matches.first
            if let f = first {
                expect(f).to(equal("R1.1.1v2"))
            }
        }
        
        it("schedules value type single elimination with 03 teams") {
            let teams : [Int?] = [1,2,3]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(3))
            expect(matches[0]).to(equal("R1.1.2v3"))
            expect(matches[1]).to(equal("R1.2.1vB"))
            expect(matches[2]).to(equal("R2.3.W1v1"))
        }
        
        it("schedules value type single elimination with 04 teams") {
            let teams : [Int?] = [1,2,3,4]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(3))
            expect(matches[0]).to(equal("R1.1.2v3"))
            expect(matches[1]).to(equal("R1.2.1v4"))
            expect(matches[2]).to(equal("R2.3.W1vW2"))
        }
        
        it("schedules value type single elimination with 05 teams") {
            let teams : [Int?] = [1,2,3,4,5]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(7))
            expect(matches[0]).to(equal("R1.1.4v5"))
            expect(matches[1]).to(equal("R1.2.3vB"))
            expect(matches[2]).to(equal("R1.3.2vB"))
            expect(matches[3]).to(equal("R1.4.1vB"))
            expect(matches[4]).to(equal("R2.5.3v2"))
            expect(matches[5]).to(equal("R2.6.W1v1"))
            expect(matches[6]).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules value type single elimination with 06 teams") {
            let teams : [Int?] = [1,2,3,4,5,6]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(7))
            expect(matches[0]).to(equal("R1.1.4v5"))
            expect(matches[1]).to(equal("R1.2.3v6"))
            expect(matches[2]).to(equal("R1.3.2vB"))
            expect(matches[3]).to(equal("R1.4.1vB"))
            expect(matches[4]).to(equal("R2.5.W2v2"))
            expect(matches[5]).to(equal("R2.6.W1v1"))
            expect(matches[6]).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules value type single elimination with 07 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(7))
            expect(matches[0]).to(equal("R1.1.4v5"))
            expect(matches[1]).to(equal("R1.2.3v6"))
            expect(matches[2]).to(equal("R1.3.2v7"))
            expect(matches[3]).to(equal("R1.4.1vB"))
            expect(matches[4]).to(equal("R2.5.W2vW3"))
            expect(matches[5]).to(equal("R2.6.W1v1"))
            expect(matches[6]).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules value type single elimination with 08 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(7))
            expect(matches[0]).to(equal("R1.1.4v5"))
            expect(matches[1]).to(equal("R1.2.3v6"))
            expect(matches[2]).to(equal("R1.3.2v7"))
            expect(matches[3]).to(equal("R1.4.1v8"))
            expect(matches[4]).to(equal("R2.5.W2vW3"))
            expect(matches[5]).to(equal("R2.6.W1vW4"))
            expect(matches[6]).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules value type single elimination with 09 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7vB"))
            expect(matches[02]).to(equal("R1.3.6vB"))
            expect(matches[03]).to(equal("R1.4.5vB"))
            expect(matches[04]).to(equal("R1.5.4vB"))
            expect(matches[05]).to(equal("R1.6.3vB"))
            expect(matches[06]).to(equal("R1.7.2vB"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.5v4"))
            expect(matches[09]).to(equal("R2.10.6v3"))
            expect(matches[10]).to(equal("R2.11.7v2"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
            
        }
        
        it("schedules value type single elimination with 10 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6vB"))
            expect(matches[03]).to(equal("R1.4.5vB"))
            expect(matches[04]).to(equal("R1.5.4vB"))
            expect(matches[05]).to(equal("R1.6.3vB"))
            expect(matches[06]).to(equal("R1.7.2vB"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.5v4"))
            expect(matches[09]).to(equal("R2.10.6v3"))
            expect(matches[10]).to(equal("R2.11.W2v2"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules value type single elimination with 11 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6v11"))
            expect(matches[03]).to(equal("R1.4.5vB"))
            expect(matches[04]).to(equal("R1.5.4vB"))
            expect(matches[05]).to(equal("R1.6.3vB"))
            expect(matches[06]).to(equal("R1.7.2vB"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.5v4"))
            expect(matches[09]).to(equal("R2.10.W3v3"))
            expect(matches[10]).to(equal("R2.11.W2v2"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
        }
        
        
        it("schedules value type single elimination with 12 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6v11"))
            expect(matches[03]).to(equal("R1.4.5v12"))
            expect(matches[04]).to(equal("R1.5.4vB"))
            expect(matches[05]).to(equal("R1.6.3vB"))
            expect(matches[06]).to(equal("R1.7.2vB"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.W4v4"))
            expect(matches[09]).to(equal("R2.10.W3v3"))
            expect(matches[10]).to(equal("R2.11.W2v2"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules value type single elimination with 13 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6v11"))
            expect(matches[03]).to(equal("R1.4.5v12"))
            expect(matches[04]).to(equal("R1.5.4v13"))
            expect(matches[05]).to(equal("R1.6.3vB"))
            expect(matches[06]).to(equal("R1.7.2vB"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.W4vW5"))
            expect(matches[09]).to(equal("R2.10.W3v3"))
            expect(matches[10]).to(equal("R2.11.W2v2"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules value type single elimination with 14 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6v11"))
            expect(matches[03]).to(equal("R1.4.5v12"))
            expect(matches[04]).to(equal("R1.5.4v13"))
            expect(matches[05]).to(equal("R1.6.3v14"))
            expect(matches[06]).to(equal("R1.7.2vB"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.W4vW5"))
            expect(matches[09]).to(equal("R2.10.W3vW6"))
            expect(matches[10]).to(equal("R2.11.W2v2"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
        }
        
        
        it("schedules value type single elimination with 15 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6v11"))
            expect(matches[03]).to(equal("R1.4.5v12"))
            expect(matches[04]).to(equal("R1.5.4v13"))
            expect(matches[05]).to(equal("R1.6.3v14"))
            expect(matches[06]).to(equal("R1.7.2v15"))
            expect(matches[07]).to(equal("R1.8.1vB"))
            expect(matches[08]).to(equal("R2.9.W4vW5"))
            expect(matches[09]).to(equal("R2.10.W3vW6"))
            expect(matches[10]).to(equal("R2.11.W2vW7"))
            expect(matches[11]).to(equal("R2.12.W1v1"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules value type single elimination with 16 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(15))
            expect(matches[00]).to(equal("R1.1.8v9"))
            expect(matches[01]).to(equal("R1.2.7v10"))
            expect(matches[02]).to(equal("R1.3.6v11"))
            expect(matches[03]).to(equal("R1.4.5v12"))
            expect(matches[04]).to(equal("R1.5.4v13"))
            expect(matches[05]).to(equal("R1.6.3v14"))
            expect(matches[06]).to(equal("R1.7.2v15"))
            expect(matches[07]).to(equal("R1.8.1v16"))
            expect(matches[08]).to(equal("R2.9.W4vW5"))
            expect(matches[09]).to(equal("R2.10.W3vW6"))
            expect(matches[10]).to(equal("R2.11.W2vW7"))
            expect(matches[11]).to(equal("R2.12.W1vW8"))
            expect(matches[12]).to(equal("R3.13.W10vW11"))
            expect(matches[13]).to(equal("R3.14.W9vW12"))
            expect(matches[14]).to(equal("R4.15.W13vW14"))
            
        }
        
        it("schedules value type single elimination with 17 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
            let matches = valuedSingleElimination(teams)
            expect(matches.count).to(equal(31))
            expect(matches[00]).to(equal("R1.1.16v17"))
            expect(matches[01]).to(equal("R1.2.15vB"))
            expect(matches[02]).to(equal("R1.3.14vB"))
            expect(matches[03]).to(equal("R1.4.13vB"))
            expect(matches[04]).to(equal("R1.5.12vB"))
            expect(matches[05]).to(equal("R1.6.11vB"))
            expect(matches[06]).to(equal("R1.7.10vB"))
            expect(matches[07]).to(equal("R1.8.9vB"))
            expect(matches[08]).to(equal("R1.9.8vB"))
            expect(matches[09]).to(equal("R1.10.7vB"))
            expect(matches[10]).to(equal("R1.11.6vB"))
            expect(matches[11]).to(equal("R1.12.5vB"))
            expect(matches[12]).to(equal("R1.13.4vB"))
            expect(matches[13]).to(equal("R1.14.3vB"))
            expect(matches[14]).to(equal("R1.15.2vB"))
            expect(matches[15]).to(equal("R1.16.1vB"))
            expect(matches[16]).to(equal("R2.17.9v8"))
            expect(matches[17]).to(equal("R2.18.10v7"))
            expect(matches[18]).to(equal("R2.19.11v6"))
            expect(matches[19]).to(equal("R2.20.12v5"))
            expect(matches[20]).to(equal("R2.21.13v4"))
            expect(matches[21]).to(equal("R2.22.14v3"))
            expect(matches[22]).to(equal("R2.23.15v2"))
            expect(matches[23]).to(equal("R2.24.W1v1"))
            expect(matches[24]).to(equal("R3.25.W20vW21"))
            expect(matches[25]).to(equal("R3.26.W19vW22"))
            expect(matches[26]).to(equal("R3.27.W18vW23"))
            expect(matches[27]).to(equal("R3.28.W17vW24"))
            expect(matches[28]).to(equal("R4.29.W26vW27"))
            expect(matches[29]).to(equal("R4.30.W25vW28"))
            expect(matches[30]).to(equal("R5.31.W29vW30"))
        }
        

        it("ends this spec") {
            expect(1-1).to(equal(0))
        }
    }
}
