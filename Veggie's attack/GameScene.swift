//
//  GameScene.swift
//  Veggie's attack
//
//  Created by Adriano d'Alessandro on 06/12/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var player: SKNode?
    var joystick: SKNode?
    var joystickKnob: SKNode?
    
    var joystickAction = false
    
    var knobRadius: CGFloat  = 50.0
    
    override func didMove(to view: SKView) {
        
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
    
    }
    

   
}


extension GameScene{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        for touch in touches {
            if let joystickKnob = joystickKnob{
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else {return}
        guard let joystickKnob = joystickKnob else {return}
        
        if !joystickAction {return}
        
        for touch in touches{
            let position = touch.location(in: joystick)
            
            let lenght = sqrt(pow(position.y,2) + pow(position.x,2))
            let angle = atan2(position.y,position.x)
            
            if knobRadius > lenght{
                joystickKnob.position = position
                print("\(position)")
            }else{
                joystickKnob.position = CGPoint(x:cos(angle) * knobRadius,y: sin(angle) * knobRadius)
                print("Else \(position)")
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
}
