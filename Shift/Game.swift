//
//  Game.swift
//  Shift
//
//  Created by Chris Villegas on 4/29/19.
//  Copyright © 2019 Village Games. All rights reserved.
//

import Foundation

enum Action {
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

public class Game {
    // Cache file name for restart
    var file:String
    
    // Current state
    var state:State
    
    // Game still playable
    var isActive:Bool
    
    // Number of moves made
    var numMoves:Int
    
    init(file:String) {
        self.file = file
        self.state = State.generate(file: self.file)
        self.numMoves = 0
        self.isActive = true;
    }
    
    // Restart game
    func restart() {
        self.state = State.generate(file: self.file)
        self.numMoves = 0
        self.isActive = true
    }
    
    // User makes move, changing state
    func makeMove(action:Action) {
        if isActive {
            // Get successor
            state = state.successor(action: action)
            
            // Increment moves
            numMoves += 1
            
            // Check if game still active
            if !state.isLegal() {
                isActive = false
            } else if state.isGoal() {
                isActive = false
            }
        }
    }
    
    // Returns board array
    func boardState() -> State {
        return self.state
    }
}

class State {
    var board:[[Square]]
    var positions:[Coordinate]
    
    init(board:[[Square]], positions:[Coordinate]) {
        self.board = board
        self.positions = positions
    }
    
    // Generate state from file
    static func generate(file:String) -> State {
        if let path = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                // Returned variables
                var positions:[Coordinate]
                var board:[[Square]]
                
                // Read file
                let text = try String(contentsOfFile: path, encoding: .utf8)
                let data = text.components(separatedBy: "\n~\n")
                
                // Generate coordinates
                positions = []
                let coordinates = data[0].components(separatedBy: .newlines)
                for coordinate in coordinates {
                    let coordinateArray = coordinate.components(separatedBy: .whitespaces)
                    if let r = Int(coordinateArray[0]) , let c = Int(coordinateArray[1]) {
                        positions.append(Coordinate(r: r, c: c))
                    }
                }
                
                // Separate board data strings
                let solidityStrings = data[1].components(separatedBy: .newlines)
                let verticalBorderStrings = data[2].components(separatedBy: .newlines)
                let horizontalBorderStrings = data[3].components(separatedBy: .newlines)
                
                // Parse board data
                var solidity:[[Bool]] = []
                var verticalBorders:[[Bool]] = []
                var horizontalBorders:[[Bool]] = []
                
                for stringRow in solidityStrings {
                    var boolRow:[Bool] = []
                    for square in stringRow {
                        if square == "1" {
                            boolRow.append(true)
                        } else {
                            boolRow.append(false)
                        }
                    }
                    solidity.append(boolRow)
                }
                for stringRow in verticalBorderStrings {
                    var boolRow:[Bool] = []
                    for square in stringRow {
                        if square == "1" {
                            boolRow.append(true)
                        } else {
                            boolRow.append(false)
                        }
                    }
                    verticalBorders.append(boolRow)
                }
                for stringRow in horizontalBorderStrings {
                    var boolRow:[Bool] = []
                    for square in stringRow {
                        if square == "1" {
                            boolRow.append(true)
                        } else {
                            boolRow.append(false)
                        }
                    }
                    horizontalBorders.append(boolRow)
                }
                
                // Build board
                board = []
                for r in 0..<solidity.count {
                    var boardRow:[Square] = []
                    for c in 0..<solidity.count {
                        // Get solidity
                        let isSolid = solidity[r][c]
                        
                        // Get borders
                        let top = verticalBorders[r][c]
                        let bottom = verticalBorders[r + 1][c]
                        let left = horizontalBorders[r][c]
                        let right = horizontalBorders[r][c + 1]
                        let borders = [top, bottom, left, right]
                        
                        // Create and append square
                        boardRow.append(Square(isSolid: isSolid, borders: borders))
                    }
                    board.append(boardRow)
                }
                
                return State(board: board, positions: positions)
                
            } catch {
                print(error)
            }
        }
        
        return State(board: [], positions: [])
    }
    
    // Successor function
    func successor(action:Action) -> State {
        switch action {
        case Action.UP:
            for position in positions {
                if !board[position.r][position.c].borders[0] {
                    position.r -= 1
                }
            }
        case Action.DOWN:
            for position in positions {
                if !board[position.r][position.c].borders[1] {
                    position.r += 1
                }
            }
        case Action.LEFT:
            for position in positions {
                if !board[position.r][position.c].borders[2] {
                    position.c -= 1
                }
            }
        case Action.RIGHT:
            for position in positions {
                if !board[position.r][position.c].borders[3] {
                    position.c += 1
                }
            }
        }
        
        return self
    }
    
    // Check if state is not a losing state
    func isLegal() -> Bool{
        for position in self.positions {
            // Check if position is in range
            if position.r < 0 || position.r >= board.count {
                return false
            }
            if position.c < 0 || position.c >= board.count {
                return false
            }
            
            // Check if position is on solid square
            let square = board[position.r][position.c]
            if !square.isSolid {
                return false
            }
        }
        
        return true
    }
    
    // Check if game is won
    func isGoal() -> Bool {
        // Check each position for equality with first
        let firstPosition = positions[0]
        for position in positions {
            if firstPosition != position {
                return false
            }
        }
        
        return true
    }
}

class Square {
    var isSolid:Bool
    var borders:[Bool]
    
    init(isSolid:Bool, borders:[Bool]) {
        self.isSolid = isSolid
        self.borders = borders
    }
    
}

class Coordinate {
    var r:Int
    var c:Int
    
    init(r:Int, c:Int) {
        self.r = r
        self.c = c
    }
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.r == rhs.r || lhs.c == rhs.c
    }
    
    static func != (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.r != rhs.r || lhs.c != rhs.c
    }
}
