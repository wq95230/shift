//
//  GameTests.swift
//  ShiftTests
//
//  Created by Chris Villegas on 4/29/19.
//  CopyRIGHT © 2019 Village Games. All RIGHTs reserved.
//

import XCTest
@testable import Shift

class GameTests: XCTestCase {

    override func setUp() {
        // Put setUP code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put tearDOWN code here. This method is called after the invocation of each test method in the class.
    }

    func testGenerate() {
        var test = State.generate(file:"test")
        
    }
    
    func testMove() {
        var test:Game
        
        // Test horse shoe level
        test = Game(file: "3-horse_shoe")
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.RIGHT)
        assert(test.state.isGoal())
        
        // Test columns level
        test = Game(file: "5-columns")
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.DOWN)
        test.makeMove(action: Action.DOWN)
        test.makeMove(action: Action.DOWN)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.LEFT)
        test.makeMove(action: Action.LEFT)
        test.makeMove(action: Action.LEFT)
        assert(test.state.isGoal())
        
        // Test columns level
        test = Game(file: "6-2_walls")
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.DOWN)
        test.makeMove(action: Action.DOWN)
        test.makeMove(action: Action.LEFT)
        test.makeMove(action: Action.LEFT)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.UP)
        test.makeMove(action: Action.DOWN)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.RIGHT)
        test.makeMove(action: Action.RIGHT)
        assert(test.state.isGoal())
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
