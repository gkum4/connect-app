//
//  MainCircle.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 13/04/22.
//

import SpriteKit

class MainCircle: Circle {
    var gradientColors: [CGColor] = []
    
    init(radius: CGFloat) {
        let circleColor = UIColor(named: "darkGray") ?? UIColor.darkGray
        
        super.init(radius: radius, color: circleColor, animated: false)
        
        node.name = Names.mainCircle
        circle.fillColor = circleColor
        circle.physicsBody?.isDynamic = false
        gradientColors.append(circleColor.cgColor)
    }
    
    override func runChangeColorAnimation(
        to newColor: UIColor,
        withDuration duration: TimeInterval,
        onCompletion: @escaping () -> Void = {}
    ) {
        if gradientColors.isEmpty {
            super.runChangeColorAnimation(
                to: newColor,
                withDuration: duration,
                onCompletion: onCompletion
            )
            
            gradientColors.append(newColor.cgColor)
            return
        }
        
        if gradientColors.count >= 4 {
            gradientColors.removeFirst()
        }
        
        gradientColors.append(newColor.cgColor)
        
        guard let newCircle = circle.copy() as? SKShapeNode else {
            return
        }
        
        let gradientImage = UIImage.buildGradient(frame: circle.frame, colors: gradientColors)
        
        newCircle.fillTexture = SKTexture(image: gradientImage)
        newCircle.alpha = 0
        newCircle.fillColor = .white
        node.addChild(newCircle)
        
        circle.run(.sequence([
            .wait(forDuration: duration),
            .run {
                self.circle.removeFromParent()
            }
        ]))
        
        newCircle.run(.sequence([
            .fadeIn(withDuration: duration),
            .wait(forDuration: 0.01),
            .run {
                self.circle = newCircle
                onCompletion()
            }
        ]))
    }
    
    enum Names {
        static let mainCircle: String = "mainCircle"
    }
}
