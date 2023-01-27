//
//  Circle.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 12/04/22.
//

import SpriteKit

class Circle {
    let node: SKNode
    var circle: SKShapeNode
    var radius: CGFloat
    var hasLineAttached: Bool = false
    var isConnectedToMainCircle: Bool = false
    var connectedCircles: [Circle] = []
    
    init(radius: CGFloat, color: UIColor, animated: Bool) {
        self.node = SKNode()
        self.node.name = Names.circle
        self.radius = radius
        self.circle = Circle.buildCircle(radius: radius, color: color)
        self.node.addChild(self.circle)
        
        if animated {
            self.node.run(Circle.buildAliveAnimation(), withKey: ActionKeys.aliveAnimation)
        }
    }
    
    func pauseMovement() {
        if let aliveAnimation = self.node.action(forKey: ActionKeys.aliveAnimation) {
            aliveAnimation.speed = 0
        }
        
        if let moveAwayAnimation = self.node.action(forKey: ActionKeys.moveAwayAnimation) {
            moveAwayAnimation.speed = 0
        }
        
        if let moveCloserAnimation = self.node.action(forKey: ActionKeys.moveCloserAnimation) {
            moveCloserAnimation.speed = 0
        }
    }
    
    func resumeMovement() {
        if let aliveAnimation = self.node.action(forKey: ActionKeys.aliveAnimation) {
            aliveAnimation.speed = 1
        }
        
        if let moveAwayAnimation = self.node.action(forKey: ActionKeys.moveAwayAnimation) {
            moveAwayAnimation.speed = 1
        }
        
        if let moveCloserAnimation = self.node.action(forKey: ActionKeys.moveCloserAnimation) {
            moveCloserAnimation.speed = 1
        }
    }
    
    func runChangeColorAnimation(
        to newColor: UIColor,
        withDuration duration: TimeInterval,
        onCompletion: @escaping () -> Void = {}
    ) {
        guard let newCircle = circle.copy() as? SKShapeNode else {
            return
        }
        
        newCircle.alpha = 0
        newCircle.fillColor = newColor
        node.addChild(newCircle)
        
        circle.run(.sequence([
            .wait(forDuration: duration),
            .run {
                self.circle.removeFromParent()
            }
        ]))
        
        newCircle.run(.sequence([
            .fadeIn(withDuration: duration+0.01),
            .run {
                self.circle = newCircle
                onCompletion()
            }
        ]))
    }
    
    func runMoveAwayAnimation(onCompletion: @escaping () -> Void = {}) {
        let position = node.position
        let absPosX = abs(position.x)
        let absPosY = abs(position.y)
        var xMultiplier: CGFloat = 0
        var yMultiplier: CGFloat = 0
        
        if absPosX > absPosY {
            xMultiplier = position.x > 0 ? 1 : -1
            yMultiplier = (absPosY / absPosX) * (position.y > 0 ? 1 : -1)
        }
        
        if absPosX < absPosY {
            xMultiplier = (absPosX / absPosY) * (position.x > 0 ? 1 : -1)
            yMultiplier = position.y > 0 ? 1 : -1
        }
        
        if absPosX == absPosY {
            xMultiplier = position.x > 0 ? 1 : -1
            yMultiplier = position.y > 0 ? 1 : -1
        }
        
        let moveAction: SKAction = .move(
            by: CGVector(dx: 20 * xMultiplier, dy: 20 * yMultiplier),
            duration: 1
        )
        moveAction.timingMode = .easeInEaseOut
        
        self.node.run(.sequence([
            moveAction,
            .run {
                onCompletion()
            }
        ]), withKey: ActionKeys.moveAwayAnimation)
    }
    
    func runMoveCloserAnimation(onCompletion: @escaping () -> Void = {}) {
        let position = node.position
        let absPosX = abs(position.x)
        let absPosY = abs(position.y)
        var xMultiplier: CGFloat = 0
        var yMultiplier: CGFloat = 0
        
        if absPosX > absPosY {
            xMultiplier = position.x > 0 ? -1 : 1
            yMultiplier = (absPosY / absPosX) * (position.y > 0 ? -1 : 1)
        }
        
        if absPosX < absPosY {
            xMultiplier = (absPosX / absPosY) * (position.x > 0 ? -1 : 1)
            yMultiplier = position.y > 0 ? -1 : 1
        }
        
        if absPosX == absPosY {
            xMultiplier = position.x > 0 ? -1 : 1
            yMultiplier = position.y > 0 ? -1 : 1
        }
        
        let moveAction: SKAction = .move(
            by: CGVector(dx: 20 * xMultiplier, dy: 20 * yMultiplier),
            duration: 1
        )
        moveAction.timingMode = .easeInEaseOut
        
        self.node.run(.sequence([
            moveAction,
            .run {
                onCompletion()
            }
        ]), withKey: ActionKeys.moveCloserAnimation)
    }
    
    static private func buildCircle(radius: CGFloat, color: UIColor) -> SKShapeNode {
        let newCircle = SKShapeNode(circleOfRadius: radius)
        newCircle.strokeColor = .clear
        newCircle.fillColor = color
        newCircle.name = Names.circle
        newCircle.zPosition = 10
        
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody.affectedByGravity = false
        physicsBody.restitution = 0.5
        newCircle.physicsBody = physicsBody
        
        return newCircle
    }
    
    static private func buildAliveAnimation() -> SKAction {
        var circleAnimationSequence: [SKAction] = []
        var goBackVector = CGVector()
        
        for i in 1...3 {
            let randomVector: CGVector = PositionUtils.getRandomVector(
                xRange: -10...10,
                yRange: -10...10
            )
            
            circleAnimationSequence.append(
                .move(by: randomVector, duration: TimeInterval.random(in: 1...2))
            )
            
            goBackVector.dx -= randomVector.dx
            goBackVector.dy -= randomVector.dy
            
            if i == 3 {
                let moveAnimation: SKAction = .move(
                    by: goBackVector,
                    duration: TimeInterval.random(in: 1...2)
                )
                moveAnimation.timingMode = .easeInEaseOut
                
                circleAnimationSequence.append(moveAnimation)
            }
        }
        
        let scaleAnimation: SKAction = .sequence([
            .wait(forDuration: TimeInterval.random(in: 0...0.5)),
            .scale(to: 0.95, duration: 0.7),
            .scale(to: 1, duration: 0.7),
        ])
        scaleAnimation.timingMode = .easeInEaseOut
        
        let animation: SKAction = .repeatForever(.group([
            .sequence(circleAnimationSequence),
            scaleAnimation
        ]))
        return animation
    }
    
    enum Names {
        static let circle: String = "circle"
    }
    
    enum ActionKeys {
        static let aliveAnimation: String = "aliveAnimation"
        static let moveAwayAnimation: String = "moveAwayAnimation"
        static let moveCloserAnimation: String = "moveCloserAnimation"
    }
}
