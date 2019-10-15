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
    
    
    // create the background
    let bg = SKSpriteNode(imageNamed: "bg")

    // create the spaceship sprite or image
    let spaceship = SKSpriteNode(imageNamed: "spaceship")
    // track movement
    var movableNode :SKNode?
    
    // track spaceship position on the screen
    var spaceshipStartX : CGFloat = 0.0
    var spaceshipStartY : CGFloat = 0.0
    
    // Create the button image
    let shootButton = SKSpriteNode (imageNamed: "shootButton")
    
    // Create the sound
    let laserBeamSound = SKAction.playSoundFileNamed("laserBeamSound.mp3", waitForCompletion: false)
    
    // create fire exhaust
    let engineExhaust = SKEmitterNode(fileNamed: "engineExhaust.sks")
    
        
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.blue

        spaceship.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.15)
        spaceship.setScale(0.1)
        spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spaceship.zPosition = 5
        spaceship.name = "spaceship"
        addChild(spaceship)
        
        engineExhaust?.position = CGPoint(x: 0.0, y: -(spaceship.size.height * 6))
        engineExhaust?.setScale(15)
        spaceship.addChild(engineExhaust!)
        
        // uncomment to Run animation will make spaceship move on its on
        //animateSpaceship()
        
        // Button Atributes
        shootButton.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.15)
        shootButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shootButton.setScale(0.15)
        shootButton.zPosition = 10
        shootButton.name = "shoot"
        addChild(shootButton)
        
        addStartFields()
        //spawnUFO()
        
        let wait = SKAction.wait(forDuration: 2.0)
        let constantSpawing = SKAction.run {
            self.spawnUFO()
        }
        let spawnSequence = SKAction.sequence([wait, constantSpawing])
        run(SKAction.repeatForever(spawnSequence))
   

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // locate where the user is touching the screen
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            // know where the spaceship is and if is where the user is touching
            if (spaceship.contains(touchLocation)){
                movableNode = spaceship
                spaceshipStartX = (movableNode?.position.x)! - touchLocation.x
                spaceshipStartY = (movableNode?.position.y)! - touchLocation.y
                
            }
            
            if touchedNode.name == "shoot"{
                self.run(laserBeamSound)
                shootLaserBeam()
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Update the position of the spaceship base on the user touch
        if let touch = touches.first, movableNode != nil {
            let location = touch.location(in:self)
            movableNode!.position = CGPoint(x: location.x + spaceshipStartX, y: location.y + spaceshipStartY)
        }
    }
    
    // touched ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first, movableNode != nil {
            movableNode = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
                   movableNode = nil
               }
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
    
    // ENEMIES
    func spawnUFO(){
        
        let UFO = SKSpriteNode(imageNamed: "UFO")
        UFO.setScale(0.15)
        UFO.zPosition = 7
        UFO.name = "UFO"
        UFO.position = CGPoint(x: CGFloat.random(min: -200, max: self.size.width + 200), y:self.size.height + 200)
        addChild(UFO)
        
        let leftTwist = SKAction.rotate(byAngle: 3.14 / 8.0, duration: 0.5)
        let rightTwist = leftTwist.reversed()
        let fullTwist = SKAction.sequence([leftTwist, rightTwist])
        UFO.run(SKAction.repeatForever(fullTwist))
        
        
        // Animate the UFO
        let x = CGFloat.random(min: 0, max: self.size.width)
        // The movement of the UFO.. decrese the duration for a more dificult game
        let UFOMove = SKAction.move(to: CGPoint(x: x, y: -200), duration: 2.5)
        // Remove the UFO
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([UFOMove, remove])
        UFO.run(sequence)
        
    }
    
    func shootLaserBeam(){
        let laser = SKSpriteNode(imageNamed: "laserBeam")
        
        laser.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        laser.zPosition = 3
        laser.setScale(0.1)
        laser.name = "laser"
        laser.position = spaceship.position
        
        addChild(laser)
        
        let moveY = size.height
        let moveDuration = 1.5
        
        let move = SKAction.moveBy(x: 0, y: moveY, duration: moveDuration)
        // Remove the laser out the screen
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        
        laser.run(sequence)
        
    }
    
    func addStartFields(){
        let startTexture = SKTexture(imageNamed: "spark.png")
        
        //Emiter #1 Closer Stars
        let emitter = SKEmitterNode()
        emitter.particleTexture = startTexture
        emitter.particleBirthRate = 15
        emitter.particleLifetime = 45
        emitter.emissionAngle = CGFloat(90.0).degressToRadians()
        emitter.emissionAngleRange = CGFloat(360.0).degressToRadians()
        emitter.yAcceleration = -5
        emitter.particleSpeed = 30
        emitter.particleAlpha = 0.0
        emitter.particleAlphaSpeed = 0.5
        emitter.particleScale = 0.005
        emitter.particleScaleRange = 0.0075
        emitter.particleScaleSpeed = 0.01
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColor = SKColor.white
        emitter.position = CGPoint(x: frame.width / 2, y: frame.height * 1.75)
        emitter.zPosition = -4
        emitter.advanceSimulationTime(45)
        addChild(emitter)
        
        //Emiter #2 More Stars
        let emitter2 = SKEmitterNode()
        emitter2.particleTexture = startTexture
        emitter2.particleBirthRate = 10
        emitter2.particleLifetime = 180
        emitter2.emissionAngle = CGFloat(90.0).degressToRadians()
        emitter2.emissionAngleRange = CGFloat(360.0).degressToRadians()
        emitter2.yAcceleration = 0
        emitter2.particleSpeed = 30
        emitter2.particleAlpha = 0.0
        emitter2.particleAlphaSpeed = 0.5
        emitter2.particleScale = 0.0005
        emitter2.particleScaleRange = 0.0005
        emitter2.particleScaleSpeed = 0.005
        emitter2.particleColorBlendFactor = 1.0
        emitter2.particleColor = SKColor.white
        emitter2.position = CGPoint(x: frame.width / 2, y: frame.height * 1.75)
        emitter2.zPosition = -5
        emitter2.advanceSimulationTime(180)
        addChild(emitter2)
        
    }
}

extension CGFloat {
    public func degressToRadians() -> CGFloat{
        let π = CGFloat.pi
        return π * self / 180.0
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
