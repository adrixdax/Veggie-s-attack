//
//  GameViewController.swift
//  Veggie's attack
//
//  Created by Adriano d'Alessandro on 06/12/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                
                /*
                scene.scaleMode = .aspectFill
                let play = SKShapeNode(rect: CGRect(x: -(UIScreen.main.bounds.width/3)/2, y: (UIScreen.main.bounds.height/4)/2, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4), cornerRadius: 10);
                play.fillColor = SKColor.systemBlue;
                scene.addChild(play)
                scene.addChild(SKShapeNode(rect: CGRect(x: -(UIScreen.main.bounds.width/3)/2, y: -(UIScreen.main.bounds.height/4)/2, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4), cornerRadius: 10))
                scene.addChild(SKShapeNode(rect: CGRect(x: -(UIScreen.main.bounds.width/3)/2, y: -(UIScreen.main.bounds.height/4)/(2/3), width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4), cornerRadius: 10))
                 */
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
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
