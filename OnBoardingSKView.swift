//
//  File.swift
//  My App
//
//  Created by Felipe on 05/02/25.
//

import Foundation
import SpriteKit
import SwiftUI

class WelcomeScene: SKScene, SKPhysicsContactDelegate {
    
    var scaleDog: CGFloat = 1
    
    private var textures: [SKTexture] = []
    private var textureIndex = 0
    
    lazy var zicoNode: SKSpriteNode = {
        // Inicializa o sprite
        var zicoNode = SKSpriteNode(texture: textures.first)
        zicoNode.size.height = 443.15
        zicoNode.size.width = 518.81
        
        zicoNode.position.y = self.frame.minY + (zicoNode.size.height / 2)
        zicoNode.position.x = self.frame.maxX - (zicoNode.size.width / 2)
        
        return zicoNode
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(Color(.pretoDeFundo))

        // Carrega as texturas para alternar
        textures = [
            SKTexture(imageNamed: "zicoInicial1"),
            SKTexture(imageNamed: "zicoInicial2"),
            SKTexture(imageNamed: "zicoInicial3"),
            SKTexture(imageNamed: "zicoInicial2"),
        ]
        
        addChild(zicoNode)
        
        // Inicia o timer para trocar a textura a cada 0.25s
        let wait = SKAction.wait(forDuration: 0.25)
        let changeTexture = SKAction.run {
            self.textureIndex = (self.textureIndex + 1) % self.textures.count
            self.zicoNode.texture = self.textures[self.textureIndex]
        }
        
        let sequence = SKAction.sequence([wait, changeTexture])
        zicoNode.run(SKAction.repeatForever(sequence))
    }
    
    func startTalking() {
        // MARK: Ainda não ta funcionando corretamente
        let sizeHeightAnimation = SKAction.resize(toHeight: 696.13, duration: 0.5)
        let sizeWidthAnimation = SKAction.resize(toWidth: 798, duration: 0.5)
        let movingAnimation = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 0.5)
        let setTexture = SKAction.setTexture(SKTexture(imageNamed: "zicoTalking1Grande"))
        let updateTextures = SKAction.run {
            self.textures = [
                SKTexture(imageNamed: "zicoTalking1Grande"),
                SKTexture(imageNamed: "zicoTalking2Grande"),
                SKTexture(imageNamed: "zicoTalking3Grande"),
                SKTexture(imageNamed: "zicoTalking2Grande"),
            ]
        }
        
        let group = SKAction.group([movingAnimation, sizeHeightAnimation, sizeWidthAnimation])
        let sequence = SKAction.sequence([group, setTexture, updateTextures])
        
        zicoNode.run(sequence)
    }
}


