//
//  GameScene.swift
//  spaceship_demo
//
//  Created by Gustavo Garcia  on 2019-10-14.
//  Copyright © 2019 garciaINC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let spaceship = SKSpriteNode(imageNamed: "spaceship")
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        spaceship.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.15)
        spaceship.setScale(0.1)
        spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spaceship.zPosition = 5
        spaceship.name = "spaceship"
        addChild(spaceship)
        
        // Run animation
        animateSpaceship()
                
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // Animation
    func animateSpaceship(){
        // move to the right of the screen
        let rightMovement = SKAction.moveTo(x: self.size.width * 0.8, duration: 2.5)
        
        // move to the right of the screen
        let leftMovement = SKAction.moveTo(x: self.size.width * 0.2 , duration: 2.5)
        
        let sequence = SKAction.sequence([rightMovement, leftMovement])
        let animation = SKAction.repeatForever(sequence)
        
        spaceship.run(animation)
    }
}
