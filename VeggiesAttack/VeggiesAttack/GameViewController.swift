//
//  GameViewController.swift
//  Test
//
//  Created by Michele Zurlo on 08/12/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenu(size: CGSize(width: 2048, height: 1536))
        let skView = view as! SKView
        presentSkView(skView: skView, scene: scene)
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
    
    func presentSkView(skView : SKView, scene : SKScene){
        scene.scaleMode = .aspectFill
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.presentScene(scene)
    }
}
