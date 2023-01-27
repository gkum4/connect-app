//
//  Background.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 13/04/22.
//

import SpriteKit

class Background {
    let node: SKNode
    let sceneFrame: CGRect
    private var background: SKSpriteNode
    
    init(frame: CGRect) {
        node = SKNode()
        node.zPosition = 0
        background = SKSpriteNode(color: .black, size: frame.size)
        background.alpha = 0
        node.addChild(background)
        sceneFrame = frame
    }
    
    func runChangeBackground(to newColor: UIColor, onCompletion: @escaping () -> Void = {}) {
        guard let newBackground = background.copy() as? SKSpriteNode else {
            return
        }
        newBackground.color = newColor
        newBackground.alpha = 0
        
        node.addChild(newBackground)
        
        background.run(.sequence([
            .fadeOut(withDuration: 1),
            .run {
                self.background.removeFromParent()
            }
        ]))
        
        newBackground.run(.sequence([
            .fadeAlpha(to: 0.5, duration: 1.01),
            .run {
                self.background = newBackground
            }
        ]))
    }
    
    func runSpreadAnimation(
        color: UIColor,
        atPos pos: CGPoint = .zero,
        onCompletion: @escaping () -> Void = {}
    ) {
        let firstCircleRadius = sceneFrame.height/2/5 + 20
        
        let circle = SKShapeNode(circleOfRadius: 1)
        circle.alpha = 0.3
        circle.strokeColor = .clear
        circle.fillColor = color
        circle.position = pos

        node.addChild(circle)

        let circleAnimation: SKAction = .sequence([
            .group([
                .scale(to: firstCircleRadius * 2, duration: 0.6),
                .fadeOut(withDuration: 0.55),
            ]),
            .removeFromParent()
        ])
        circle.run(circleAnimation)

        node.run(.sequence([
            .wait(forDuration: 1.6),
            .run {
                onCompletion()
            }
        ]))
    }
    
    func runSpreadAnimation(
        colors: [CGColor],
        atPos pos: CGPoint = .zero,
        onCompletion: @escaping () -> Void = {}
    ) {
        let firstCircleRadius = sceneFrame.height/2/5 + 20
        
        let circle = SKShapeNode(circleOfRadius: 1)
        circle.alpha = 0.3
        circle.strokeColor = .clear
        circle.position = pos

        if colors.count > 1 {
            circle.fillColor = .white
            let textureImage = UIImage.buildGradient(
                frame: circle.frame,
                colors: colors
            )
            circle.fillTexture = SKTexture(image: textureImage)
        } else {
            circle.fillColor = UIColor(cgColor: colors[0])
        }

        node.addChild(circle)

        let circleAnimation: SKAction = .sequence([
            .scale(to: firstCircleRadius * 6, duration: 6 * 0.1),
            .fadeOut(withDuration: 1),
            .run {
                circle.removeFromParent()
            }
        ])
        circle.run(circleAnimation)

        node.run(.sequence([
            .wait(forDuration: 1.6),
            .run {
                onCompletion()
            }
        ]))
    }
    
    func runHugeSpreadAnimation(
        colors: [CGColor],
        atPos pos: CGPoint,
        onCompletion: @escaping () -> Void = {}
    ) {
        let firstCircle = SKShapeNode(circleOfRadius: 1)
        firstCircle.alpha = 0.5
        firstCircle.strokeColor = .clear
        firstCircle.position = pos

        if colors.count > 1 {
            firstCircle.fillColor = .white
            let textureImage = UIImage.buildGradient(
                frame: firstCircle.frame,
                colors: colors
            )
            firstCircle.fillTexture = SKTexture(image: textureImage)
        } else {
            firstCircle.fillColor = UIColor(cgColor: colors[0])
        }

        node.addChild(firstCircle)
        
        firstCircle.run(.sequence([
            .scale(to: self.sceneFrame.height, duration: 2),
            .run {
                firstCircle.removeFromParent()
            }
        ]))
        
        let secondCircle = SKShapeNode(circleOfRadius: 1)
        secondCircle.strokeColor = .clear
        secondCircle.fillColor = .black
        secondCircle.position = pos
                        
        node.addChild(secondCircle)
        secondCircle.run(.sequence([
            .wait(forDuration: 0.5),
            .scale(to: self.sceneFrame.height, duration: 1.5),
            .run {
                secondCircle.removeFromParent()
            }
        ]))

        node.run(.sequence([
            .wait(forDuration: 1.5),
            .run {
                onCompletion()
            }
        ]))
    }
}
