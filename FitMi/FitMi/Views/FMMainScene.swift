//
//  FMMainScene.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import SpriteKit
import GameplayKit

class FMMainScene: SKScene {
    
    private var textureAtlas = SKTextureAtlas()
	private var textureArray = [SKTexture]()
	var character = SKSpriteNode()
    
    override func didMove(to view: SKView) {
		self.textureAtlas = SKTextureAtlas(named: "sprite-a")
		
		for i in 1...self.textureAtlas.textureNames.count {
			let name = "relax1-\(i).png"
			textureArray.append(SKTexture(imageNamed: name))
		}
		
		self.character = SKSpriteNode(imageNamed: "relax1-1.png")
		self.character.size = CGSize(width: 400, height: 400)
		self.character.position = CGPoint.zero
		
		self.addChild(self.character)
		
		self.character.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.6, resize: true, restore: true)))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
