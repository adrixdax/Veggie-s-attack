//
//  MainMenu.swift
//  VeggiesAttack
//
//  Created by Michele Zurlo on 09/12/22.
//

import SpriteKit

class MainMenu: SKScene{
    
    //MARK: - Systems
    var containerNode: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = .zero
        setupBackground()
        setupMenu()
        
        SKTAudio.sharedInstance().playMusic("menuMusic.mpeg")

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

//MARK: - Configurations

extension MainMenu{
    
    func setupBackground(){
        
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.zPosition = -1.0
        backgroundNode.anchorPoint = .zero
        backgroundNode.position = .zero
        addChild(backgroundNode)
        
    }
    
    func setupMenu(){
        
        let play = SKSpriteNode(imageNamed: "startGame")
        play.name = "startGame"
        play.setScale(0.85)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - play.size.height + 350.0)
        addChild(play)
        
        let highscore = SKSpriteNode(imageNamed: "highscore")
        highscore.name = "highscore"
        highscore.setScale(0.85)
        highscore.zPosition = 10.0
        highscore.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - highscore.size.height + 150.0)
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
        
        let highscoreLbl = SKLabelNode(fontNamed: "Krungthep")
        highscoreLbl.text = "Highest score: \(UserDefaults.standard.integer(forKey: "highest") == 0 ? 0 : UserDefaults.standard.integer(forKey: "highest"))"
        highscoreLbl.horizontalAlignmentMode = .left
        highscoreLbl.fontSize = 80.0
        highscoreLbl.zPosition = 25.0
        highscoreLbl.position = CGPoint(x: x, y: highscoreLbl.frame.height/2.0 - 30.0)
        panel.addChild(highscoreLbl)
        
        let scoreLabel = SKLabelNode(fontNamed: "Krungthep")
        scoreLabel.text = "Last Match: \(UserDefaults.standard.integer(forKey: "latest") == 0 ? 0 : UserDefaults.standard.integer(forKey: "latest"))"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 80.0
        scoreLabel.zPosition = 25.0
        scoreLabel.position = CGPoint(x: x, y: -scoreLabel.frame.height - 30.0)
        panel.addChild(scoreLabel)
        
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
        
        //Music
        let music = SKSpriteNode(imageNamed: SKTAudio.musicEnabled ? "musicOn" : "musicOff")
        music.name = "music"
        music.setScale(0.7)
        music.zPosition = 25.0
        music.position = CGPoint(x: -music.frame.width - 50.0 , y: 0.0)
        panel.addChild(music)
        
        //Sound
        let effect = SKSpriteNode(imageNamed: effectEnabled ? "effectOn" : "effectOff")
        effect.name = "effect"
        effect.setScale(0.7)
        effect.zPosition = 25.0
        effect.position = CGPoint(x: music.frame.width + 50, y: 0.0)
        panel.addChild(effect)
        

        
    }
}
