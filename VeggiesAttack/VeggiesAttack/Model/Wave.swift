//
//  Wave.swift
//  Test
//
//  Created by Michele Zurlo on 08/12/22.
//

import SpriteKit
//OK
struct Wave: Codable{
    
    struct WaveEnemy: Codable{
        
        let position: Int
        let xOffset: CGFloat
        let moveStraight: Bool
    }
    
    let name: String
    let enemies: [WaveEnemy]
}
