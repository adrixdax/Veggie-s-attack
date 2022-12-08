//
//  GameScene.swift
//  Test
//
//  Created by Michele Zurlo on 08/12/22.
//

import SpriteKit
import GameplayKit

enum CollisionType: UInt32{
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "playerSanto")
    
    let waves = Bundle.main.decode([Wave].self, from: "waves.json")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.json")
   
    override func didMove(to view: SKView) {
        
        if let particles = SKEmitterNode(fileNamed: "MyParticle"){
            
            particles.position = CGPoint(x: 1080,y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
    
            addChild(particles)
        }
        
        /*
         Other version to get particles file
        let particlePath = Bundle.main.path(forResource: "MyParticle", ofType: "sks")
        
        let particle = NSKeyedUnarchiver.unarchiveObject(withFile: particlePath!) as! SKEmitterNode
        
        particle.position = CGPoint(x: 1080,y: 0)
        addChild(particle)
         */
        
        player.name = "playerSanto"
        player.position.x = frame.minX + 75
        player.zPosition = 1
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: (player.texture!.size()))
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.isDynamic = false
    }
    

    
    
}
