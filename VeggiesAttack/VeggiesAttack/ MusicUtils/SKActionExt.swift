//
//  SKTAction.swift
//  VeggiesAttack
//
//  Created by Alessio Gazzara on 11/12/22.
//

import SpriteKit

extension SKAction{
    
    class func playSoundFileNamed(_ fileNamed: String) -> SKAction {
        if !effectEnabled { return SKAction()}
        return SKAction.playSoundFileNamed(fileNamed, waitForCompletion: false)
    }
}


private let keySFX = "keySFX"
var effectEnabled: Bool = {
    return !UserDefaults.standard.bool(forKey:  keySFX)
}() {
    didSet{
        let value = !effectEnabled
        UserDefaults.standard.set(value, forKey:  keySFX)
        if value {
            SKAction.stop()
        }
    }
}
