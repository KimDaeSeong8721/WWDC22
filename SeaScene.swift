//
//  File.swift
//  TidalWaveTea
//
//  Created by DaeSeong on 2022/04/21.
//

import SpriteKit
import GameplayKit

class SeaScene : SKScene {
    
    var SeaFrame:SKTexture?
    
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.gray
       
        
        let texture = SKTexture(imageNamed: "Sea")
        self.SeaFrame = texture
        
    }
    
    func wave(){
        let texture = self.SeaFrame!
        let sea = SKSpriteNode(texture: texture)
        print(sea)
        sea.size = CGSize(width: 1000, height: 300)
        
        
        let randomSeaYPositionGenerator = GKRandomDistribution(lowestValue: 100, highestValue: Int(self.frame.size.height))
        
        let yPosition = CGFloat(randomSeaYPositionGenerator.nextInt())
        
        let rightToLeft = arc4random() % 2 == 0
        
        let xPosition = rightToLeft ? self.frame.size.width + sea.size.width / 2 : -sea.size.width / 2
        
        sea.position = CGPoint(x: xPosition, y: yPosition)
        
        if rightToLeft {
            sea.xScale = -1
        }
        
        self.addChild(sea)
        
        sea.run(SKAction.repeatForever(SKAction.animate(with: [self.SeaFrame!,self.SeaFrame!], timePerFrame: 0.05, resize: false, restore: true)))
        
        var distanceToCover = self.frame.size.width + sea.size.width
        
        if rightToLeft {
            distanceToCover *= -1
        }
        
        let time = abs(distanceToCover / 1000)
        
        let moveAction = SKAction.moveBy(x: 500, y: 0, duration: time)
        
        let removeAction = SKAction.run {
            sea.removeAllActions()
            sea.removeFromParent()
        }
        
        let allActions = SKAction.sequence([moveAction, removeAction])
        
        sea.run(allActions)
        
    }
}
