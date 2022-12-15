//
//  MainMenu.swift
//  VeggiesAttack
//
//  Created by Michele Zurlo on 09/12/22.
//

import SpriteKit

class MainMenu: SKScene{
    
    var containerNode: SKSpriteNode!
    
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
        setupBackground()
        setupMenu()
        
        SKTAudio.sharedInstance().playMusic("menuMusic.wav")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let node = atPoint(touch.location(in: self))
        
        if node.name == "startGame"{
            
            let scene = SKScene(fileNamed: "GameScene")!
            
            scene.scaleMode = .aspectFill
            
            view!.presentScene(scene,transition: .doorsOpenVertical(withDuration: 0.3))
            view!.ignoresSiblingOrder = true
            view!.showsFPS = false
            view!.showsNodeCount = false
            view!.showsPhysics = false
            
        }else if node.name == "highscore" {
            setupPanel()
            
        }else if node.name == "setting" {
            setupSetting()
            
        }else if node.name == "container" {
            containerNode.removeFromParent()
            
        }else if node.name == "music"{
            let node = node as! SKSpriteNode
            SKTAudio.musicEnabled = !SKTAudio.musicEnabled
            node.texture = SKTexture(imageNamed: SKTAudio.musicEnabled ? "musicOn" : "musicOff")
            
        }else if node.name == "effect"{
            let node = node as! SKSpriteNode
            effectEnabled = !effectEnabled
            node.texture = SKTexture(imageNamed: effectEnabled ? "effectOn" : "effectOff")
        }
        
    }
    
}

extension MainMenu{
    
    func setupBackground(){
        
        if let particles = SKEmitterNode(fileNamed: "MyParticle"){
            particles.position = CGPoint(x: playableRect.width,y: 800)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }
        
        
        let backgroundNode = SKSpriteNode(imageNamed: "logoBackground")
            backgroundNode.zPosition = 0
           // backgroundNode.anchorPoint = .zero
            backgroundNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + 150)
            addChild(backgroundNode)
         
         
        /*
        let titleLabel = SKLabelNode(fontNamed: "Pixels")
        titleLabel.text = "Veggie's Attack"
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.fontSize = 300.0
        titleLabel.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + 150)
        
        addChild(titleLabel)
         */
         
        
    }

    func setupMenu(){
        
        let play = SKSpriteNode(imageNamed: "startGame")
        play.name = "startGame"
        play.setScale(0.85)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0 - 650, y: size.height/2.0 - play.size.height - 50.0)
        addChild(play)
        
        let highscore = SKSpriteNode(imageNamed: "highscore")
        highscore.name = "highscore"
        highscore.setScale(0.85)
        highscore.zPosition = 10.0
        highscore.position = CGPoint(x: size.width/2.0 + 650, y: size.height/2.0 - highscore.size.height - 50.0)
        addChild(highscore)
        
        let setting = SKSpriteNode(imageNamed: "setting")
        setting.name = "setting"
        setting.setScale(0.85)
        setting.zPosition = 10.0
        setting.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - setting.size.height - 50.0)
        addChild(setting)
        
    }
    
    func setupPanel(){
        
        setupContainer()
        
        let panel = SKSpriteNode (imageNamed: "panel")
        panel.setScale (1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let x = -panel.frame.width/2.0 + 250.0
        
        let highscoreLbl = SKLabelNode(fontNamed: "Pixels")
        highscoreLbl.text = "Highest score: \(UserDefaults.standard.integer(forKey: "highest") == 0 ? 0 : UserDefaults.standard.integer(forKey: "highest"))"
        highscoreLbl.horizontalAlignmentMode = .left
        highscoreLbl.fontSize = 130.0
        highscoreLbl.zPosition = 25.0
        highscoreLbl.position = CGPoint(x: x, y: highscoreLbl.frame.height/2.0)
        panel.addChild(highscoreLbl)
        
        let scoreLabel = SKLabelNode(fontNamed: "Pixels")
        
        scoreLabel.text = "Last Match: \(UserDefaults.standard.integer(forKey: "latest") == 0 ? 0 : UserDefaults.standard.integer(forKey: "latest"))"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 130.0
        scoreLabel.zPosition = 25.0
        scoreLabel.position = CGPoint(x: x, y: -scoreLabel.frame.height-17.5)
        panel.addChild(scoreLabel)
        
        for family in UIFont.familyNames.sorted(){
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font Names \(names)")
        }
        
    }
    
    func setupContainer(){
        
        containerNode = SKSpriteNode()
        containerNode.name = "container"
        containerNode.zPosition = 15.0
        containerNode.color = .clear
        containerNode.size = size
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(containerNode)
        
    }
    
    func setupSetting(){
        
        setupContainer()
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let music = SKSpriteNode(imageNamed: SKTAudio.musicEnabled ? "musicOn" : "musicOff")
        music.name = "music"
        music.setScale(0.7)
        music.zPosition = 25.0
        music.position = CGPoint(x: -music.frame.width - 50.0 , y: 0.0)
        panel.addChild(music)
        
        
        let effect = SKSpriteNode(imageNamed: effectEnabled ? "effectOn" : "effectOff")
        effect.name = "effect"
        effect.setScale(0.7)
        effect.zPosition = 25.0
        effect.position = CGPoint(x: music.frame.width + 50, y: 0.0)
        panel.addChild(effect)
        
    }
}
