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

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "playerSanto") //OK
    let button = SKSpriteNode(imageNamed: "knob")
    
    let waves = Bundle.main.decode([Wave].self, from: "waves.json")  //OK
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.json") //OK
    
    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    var playerShields = 3
    
    let positions = Array(stride(from: -320, through: 320, by: 80))
    
    //MARK: - pause and restart nodes
    var pauseNode: SKSpriteNode!
    var containerNode = SKNode()
    
    var playableRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        
        let playableHeight = size.width / ratio
        let playableMargin = (size.height - playableHeight) / 2.0
        
        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setupBackground()
        setupPlayer()
        setupShootButton()
        setupPause()
        
    }
    
    override func update(_ currentTime: TimeInterval){
        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        let activeEnemies = children.compactMap { $0 as? EnemyNode }
        
        if activeEnemies.isEmpty {
            createWave()
        }
        
        for enemy in activeEnemies {
            guard frame.intersects(enemy.frame) else { continue }
            
            if enemy.lastFireTime + 1 < currentTime {
                enemy.lastFireTime = currentTime
                
                if Int.random(in: 0...6) == 0 {
                    enemy.fire()
                }
            }
        }
        
       // boundCheck()
        
    
    }
    
    func createWave() {
        guard isPlayerAlive else { return }
        
        if waveNumber == waves.count {
            levelNumber += 1
            waveNumber = 0
        }
        
        let currentWave = waves[waveNumber]
        waveNumber += 1
        
        let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
        let enemyType = Int.random(in: 0..<maximumEnemyType)
        
        let enemyOffsetX: CGFloat = 100
        let enemyStartX = 600
        
        if currentWave.enemies.isEmpty {
            for (index, position) in positions.shuffled().enumerated() {
                let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: position), xOffset: enemyOffsetX * CGFloat(index * 3), moveStraight: true)
                addChild(enemy)
            }
        } else {
            for enemy in currentWave.enemies {
                let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positions[enemy.position]), xOffset: enemyOffsetX * enemy.xOffset, moveStraight: enemy.moveStraight)
                addChild(node)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < player.position.y {
                let newPos = player.position.y+location.y
                if newPos > frame.minY+100{
                    player.position.y = newPos
                    keepPlayerInBounds()
                    keepPlayerInBoundsInY()
                }
                else{
                    player.position.y = frame.minY + 100
                }
            } else {
                let newPos = player.position.y-location.y
                if newPos > frame.maxY-100{
                    player.position.y = newPos
                }
                else{
                    player.position.y = frame.maxY - 100
                }
            }
        }
         
        
     
        
        guard let touch = touches.first else { return }
        
        let node = atPoint(touch.location(in: self))
        
        if node.name == "gameOver"{
            
            guard !isPlayerAlive else {return}
            let scene = MainMenu(size: CGSize(width: 2048, height: 1536))
            
            scene.scaleMode = .aspectFill
            
            view!.presentScene(scene,transition: .doorsOpenVertical(withDuration: 0.3))
            view!.ignoresSiblingOrder = true
            view!.showsFPS = true
            view!.showsNodeCount = true
            view!.showsPhysics = true
            
        }else if node.name == "pause"{
            if isPaused {return}
            createPanel()
            //lastUpdateTime = 0.0
            // dt = 0.0
            
            keepPlayerInBounds()
           keepPlayerInBoundsInY()
            isPaused = true
            
        }else if node.name == "resume"{
            
            containerNode.removeFromParent()
            isPaused = false
        } else if node.name == "back"{
            let scene = MainMenu(size: CGSize(width: 2048, height: 1536))
            
            scene.scaleMode = .aspectFill
            
            view!.presentScene(scene,transition: .doorsOpenVertical(withDuration: 0.3))
            view!.ignoresSiblingOrder = true
            view!.showsFPS = true
            view!.showsNodeCount = true
            view!.showsPhysics = true
            
        }
        
        guard isPlayerAlive else {return}
        let shot = SKSpriteNode(imageNamed: "playerWeapon")
        shot.name = "playerWeapon"
        shot.position = player.position
        shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon.rawValue
        shot.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        addChild(shot)
        let movement = SKAction.move(to: CGPoint(x: 1900, y: shot.position.y), duration: 5)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        shot.run(sequence)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted {$0.name ?? "" < $1.name ?? ""}
        
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "playerSanto"{
            guard isPlayerAlive else { return }
            if let explosion = SKEmitterNode(fileNamed: "Explosion"){
                explosion.position = firstNode.position
                addChild(explosion)
            }
            
            playerShields -= 1
            
            if playerShields == 0 {
                gameOver()
                secondNode.removeFromParent()
            }
            firstNode.removeFromParent()
        }
        else if let enemy = firstNode as? EnemyNode{
            enemy.shields -= 1
            
            if enemy.shields == 0{
                if let explosion = SKEmitterNode(fileNamed: "Explosion"){
                    explosion.position = enemy.position
                    addChild(explosion)
                }
                enemy.removeFromParent()
            }
            if let explosion = SKEmitterNode(fileNamed: "Explosion"){
                explosion.position = enemy.position
                addChild(explosion)
            }
            secondNode.removeFromParent()
        } else {
            if let explosion = SKEmitterNode(fileNamed: "Explosion"){
                explosion.position = secondNode.position
                addChild(explosion)
            }
            firstNode.removeFromParent()
            secondNode.removeFromParent()
        }
    }
    
    
    func gameOver(){
        isPlayerAlive = false;
        if let explosion = SKEmitterNode(fileNamed: "Explosion"){
            explosion.position = player.position
            addChild(explosion)
        }
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.name = "gameOver"
        addChild(gameOver)
        
    }
}

extension GameScene{
    
    //MARK: - pause and restart function
    func setupPause(){
        pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.setScale(0.3)
        pauseNode.zPosition = 50.0
        pauseNode.name = "pause"
        pauseNode.position = CGPoint(x: playableRect.width/2.0 - pauseNode.frame.width/2.0 - 30.0,
                                     y: playableRect.height/2.0 - pauseNode.frame.height/2.0 - 75.0)
        addChild(pauseNode)
        
    }
    
    //MARK: - panel pause and restart
    
    func createPanel(){
        addChild(containerNode)
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.zPosition = 60.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let resume = SKSpriteNode(imageNamed: "resume")
        resume.zPosition = 70.0
        resume.name = "resume"
        resume.setScale(0.7)
        resume.position = CGPoint(x: -panel.frame.width/2.0 + resume.frame.width*1.5, y: 0.0)
        panel.addChild(resume)
        
        let back = SKSpriteNode(imageNamed: "back")
        back.zPosition = 70.0
        back.name = "back"
        back.setScale(0.7)
        back.position = CGPoint(x: panel.frame.width/2.0 - back.frame.width*1.5, y: 0.0)
        panel.addChild(back)
        
    }
    
    func setupPlayer(){
        
        // coding the physics
        player.name = "playerSanto"
        player.position.x = frame.minX + 100
        // player.position.y = frame.midY
        player.zPosition = 1
        addChild(player)
        
        //OK
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: (player.texture!.size()))
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.isDynamic = false
        
    }
    
    func setupShootButton(){
        
        button.position = CGPoint(x: playableRect.width/2.0 - button.frame.width/2.0 - 20.0,
                                  y: (playableRect.height/2.0 - button.frame.height/2.0 - 75.0) * -1 )
        button.zPosition = 0
        addChild(button)
    }
    
    func setupBackground(){
        
        //OK particles
        if let particles = SKEmitterNode(fileNamed: "MyParticle"){
            
            particles.position = CGPoint(x: 1080,y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            
            addChild(particles)
        }
        
    }
    
    func boundCheck(){
        let bottomLeft = CGPoint(x: playableRect.minX - player.frame.width - 300, y: playableRect.minY)
        
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
        }

    }
    
    func keepPlayerInBounds() {
        print("func call in bounds X")
      if player.position.x < frame.minX + player.size.width/2 {
        
        player.position.x = frame.minX + player.size.width/2
          print("playerX minore")
      }
        
        if player.position.x > frame.maxX - player.size.width/2 {
            print("playerX maggiore")

            player.position.x = frame.maxX - player.size.width/2
        }
        
    }
    
    func keepPlayerInBoundsInY() {
        print("func call in bounds Y")
      if player.position.y < frame.minY + player.size.width/2 {
          print("playerY minore")

        player.position.y = frame.minY + player.size.width/2
      }
    
        if player.position.y > frame.maxY - player.size.width/2 {
            print("playerY maggiore")

          player.position.y = frame.maxY - player.size.width/2
        }
      
    }
    

    
}
