//
//  GameViewController.swift
//  Shift
//
//  Created by Chris Villegas on 4/29/19.
//  Copyright © 2019 Village Games. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene : GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene") as? GameScene
            
            // Set the scale mode to scale to fit the window
            scene!.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
        }
    }

    @IBAction func restartGame(_ sender: Any) {
        self.scene!.restart()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
