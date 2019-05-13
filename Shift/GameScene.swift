//
//  GameScene.swift
//  Shift
//
//  Created by Chris Villegas on 4/29/19.
//  Copyright © 2019 Village Games. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Game
    var game : Game?
    
    // Pieces
    var pieces : [SKSpriteNode]?
    
    // Board Parameters
    var numRows : Int?
    var numCols : Int?
    var squareDim : CGFloat?
    var squareSize : CGSize?
    var centerOffset : CGFloat?
    var xOffset : CGFloat?
    var yOffset : CGFloat?
    
    override func didMove(to view: SKView) {
        // Initialize game, board, and pieces array
        game = Game(file: "6-test")
        pieces = []
        
        // Calculate board parameters
        let boardState = game!.boardState()
        self.numRows = boardState.board.count
        self.numCols = boardState.board.count
        self.squareDim = frame.width / CGFloat(self.numRows! + 3)
        self.squareSize = CGSize(width: self.squareDim!, height: self.squareDim!)
        self.centerOffset = CGFloat(self.numRows! / 2) * self.squareDim! - self.squareDim! / CGFloat(2)
        self.xOffset = frame.midX - self.centerOffset!
        self.yOffset = frame.midY - self.centerOffset!
        
        // Initialize swipe gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        // Draw board
        drawBoard(game: game!)
    }
    
    // Restart game
    func restart() {
        game!.restart()
        for (i, position) in game!.boardState().positions.enumerated() {
            let ball = self.childNode(withName: "ball" + String(i))
            ball!.position = CGPoint(x: CGFloat(position.c) * squareSize!.width + xOffset!, y: -(CGFloat(position.r) * squareSize!.height + yOffset!))
        }
    }
    
    // Recognize and respond to swipe gestures
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            print("Swipe Up")
            game!.makeMove(action: Action.UP)
            let positions = game!.boardState().positions
            for (i, piece) in pieces!.enumerated() {
                piece.run(SKAction.moveTo(y: -(CGFloat(positions[i].r) * squareSize!.height + yOffset!), duration: 0.1))
            }
        } else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            print("Swipe Down")
            game!.makeMove(action: Action.DOWN)
            let positions = game!.boardState().positions
            for (i, piece) in pieces!.enumerated() {
                piece.run(SKAction.moveTo(y: -(CGFloat(positions[i].r) * squareSize!.height + yOffset!), duration: 0.1))
            }
        } else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            game!.makeMove(action: Action.LEFT)
            let positions = game!.boardState().positions
            for (i, piece) in pieces!.enumerated() {
                piece.run(SKAction.moveTo(x: CGFloat(positions[i].c) * squareSize!.width + xOffset!, duration: 0.1))
            }
        } else if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            game!.makeMove(action: Action.RIGHT)
            let positions = game!.boardState().positions
            for (i, piece) in pieces!.enumerated() {
                piece.run(SKAction.moveTo(x: CGFloat(positions[i].c) * squareSize!.width + xOffset!, duration: 0.1))
            }
        }
        
    }
    
    func drawBoard(game: Game) {
        // Board array
        let boardState = game.boardState()
        
        // Draw top wall border
        for (i, topSquare) in boardState.board[0].enumerated() {
            if topSquare.borders[0] {
                let square = SKSpriteNode(imageNamed: "empty_0100")
                square.size = squareSize!
                square.position = CGPoint(x: CGFloat(i) * squareSize!.width + xOffset!, y: -yOffset! + squareSize!.height)
                square.zPosition = -1
                addChild(square)
            }
        }
        
        // Draw each row
        for row in 0...numRows!-1 {
            // Draw left wall border
            if boardState.board[row][0].borders[2] {
                let square = SKSpriteNode(imageNamed: "empty_0001")
                square.size = squareSize!
                square.position = CGPoint(x: xOffset! - squareSize!.width, y: -(CGFloat(row) * squareSize!.height + yOffset!))
                square.zPosition = -1
                addChild(square)
            }
            
            // Draw right wall border
            if boardState.board[row][boardState.board.count - 1].borders[3] {
                let square = SKSpriteNode(imageNamed: "empty_0010")
                square.size = squareSize!
                square.position = CGPoint(x: CGFloat(boardState.board.count) * squareSize!.width + xOffset!, y: -(CGFloat(row) * squareSize!.height + yOffset!))
                square.zPosition = -1
                addChild(square)
            }
            
            // Draw middle squares
            for col in 0...numCols!-1 {
                var square : SKSpriteNode
                var texture_type : String
                
                // Determine texture type
                if boardState.board[row][col].isSolid {
                    texture_type = "solid"
                } else {
                    texture_type = "empty"
                }
                
                // Determine border layout
                let borders = boardState.board[row][col].borders
                var borderString = ""
                for item in borders {
                    if item {
                        borderString += "1"
                    } else {
                        borderString += "0"
                    }
                }
                
                square = SKSpriteNode(imageNamed: texture_type + "_" + borderString)
                square.size = squareSize!
                square.position = CGPoint(x: CGFloat(col) * squareSize!.width + xOffset!, y: -(CGFloat(row) * squareSize!.height + yOffset!))
                square.zPosition = -1
                addChild(square)
            }
        }
        
        // Draw bottom wall border
        for (i, bottomSquare) in boardState.board[boardState.board.count - 1].enumerated() {
            if bottomSquare.borders[1] {
                let square = SKSpriteNode(imageNamed: "empty_1000")
                square.size = squareSize!
                square.position = CGPoint(x: CGFloat(i) * squareSize!.width + xOffset!, y: -(CGFloat(boardState.board.count) * squareSize!.height + yOffset!))
                square.zPosition = -1
                addChild(square)
            }
        }
        
        // Draw game pieces
        for (i, position) in boardState.positions.enumerated() {
            let piece = SKSpriteNode(imageNamed: "ball")
            piece.name = "ball" + String(i)
            piece.size = squareSize!
            piece.position = CGPoint(x: CGFloat(position.c) * squareSize!.width + xOffset!, y: -(CGFloat(position.r) * squareSize!.height + yOffset!))
            piece.zPosition = 1
            pieces!.append(piece)
            addChild(piece)
        }
    }
}
