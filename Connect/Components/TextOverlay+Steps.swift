//
//  TextOverlay+Steps.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 17/04/22.
//

import SpriteKit

extension TextOverlay {
    func nextStep(onCompletion: @escaping () -> Void = {}) {
        switch step {
        case 0:
            showText1(onCompletion: onCompletion)
        case 1:
            showText2(onCompletion: onCompletion)
        case 2:
            showText3(onCompletion: onCompletion)
        case 3:
            showText4(onCompletion: onCompletion)
        case 4:
            showText5(onCompletion: onCompletion)
        default:
            onCompletion()
            return
        }
        
        step += 1
    }
    
    // People change the way you think
    internal func showText1(onCompletion: @escaping () -> Void = {}) {
        let label1 = buildLabel("People change the")
        label1.name = LabelNames.peopleChangeThe
        let label1PosX = layoutMetrics.horizontalMargin + label1.frame.width/2
        label1.position = CGPoint(x: label1PosX, y: layoutMetrics.normalLineHeight/2)
        label1.alpha = 0

        let label2 = buildLabel("way you")
        label2.name = LabelNames.wayYou
        let label2PosX = layoutMetrics.horizontalMargin + label2.frame.width/2
        label2.position = CGPoint(x: label2PosX, y: -layoutMetrics.normalLineHeight/2)
        label2.alpha = 0

        let label3 = buildLabel("think")
        label3.name = LabelNames.think
        let label3PosX = (
            layoutMetrics.horizontalMargin +
            label3.frame.width/2 +
            label2.frame.width +
            layoutMetrics.spaceWidth
        )
        label3.position = CGPoint(x: label3PosX, y: -layoutMetrics.normalLineHeight/2)
        label3.alpha = 0

        node.addChild(label1)
        node.addChild(label2)
        node.addChild(label3)
        
        label1.run(.fadeIn(withDuration: 1))
        label2.run(.fadeIn(withDuration: 1))
        label3.run(.sequence([
            .fadeIn(withDuration: 1),
            .run {
                onCompletion()
            }
        ]))
    }
    
    // People change the way you see things
    private func showText2(onCompletion: @escaping () -> Void = {}) {
        guard
            let label2 = node.children.first(where: { $0.name == LabelNames.wayYou })
                as? SKLabelNode,
            let label3 = node.children.first(where: { $0.name == LabelNames.think })
                as? SKLabelNode
        else {
            return
        }
        
        label3.run(.sequence([
            .group([
                .fadeOut(withDuration: 1),
                .move(by: CGVector(dx: 0, dy: -100), duration: 1)
            ]),
            .run {
                label3.removeFromParent()
            }
        ]))
        
        let label4 = buildLabel("see things")
        label4.name = LabelNames.seeThings
        let label4PosX = (
            layoutMetrics.horizontalMargin +
            label4.frame.width/2 +
            label2.frame.width +
            layoutMetrics.spaceWidth
        )
        label4.position = CGPoint(x: label4PosX, y: -layoutMetrics.normalLineHeight/2)
        label4.alpha = 0
        
        node.addChild(label4)
        
        label4.run(.sequence([
            .wait(forDuration: 0.3),
            .fadeIn(withDuration: 1),
            .run {
                onCompletion()
            }
        ]))
    }
    
    // Sometimes people have to leave (but that’s ok)
    private func showText3(onCompletion: @escaping () -> Void = {}) {
        guard
            let label1 = node.children.first(where: { $0.name == LabelNames.peopleChangeThe })
                as? SKLabelNode,
            let label2 = node.children.first(where: { $0.name == LabelNames.wayYou })
                as? SKLabelNode,
            let label4 = node.children.first(where: { $0.name == LabelNames.seeThings })
                as? SKLabelNode
        else {
            return
        }
        
        let moveAndFade: SKAction = .group([
            .move(by: CGVector(dx: -300, dy: 0), duration: 1),
            .fadeOut(withDuration: 1)
        ])
        label1.run(.sequence([moveAndFade, .run({ label1.removeFromParent() })]))
        label2.run(.sequence([moveAndFade, .run({ label2.removeFromParent() })]))
        label4.run(.sequence([moveAndFade, .run({ label4.removeFromParent() })]))
        
        let label5 = buildLabel("Sometimes people")
        label5.name = LabelNames.sometimesPeople
        let label5PosX = layoutMetrics.horizontalMargin + label5.frame.width/2
        let label5PosY = layoutMetrics.normalLineHeight/2 + layoutMetrics.smallLineHeight/2
        label5.position = CGPoint(x: label5PosX, y: label5PosY)
        label5.alpha = 0
        
        let label6 = buildLabel("have to leave")
        label6.name = LabelNames.haveToLeave
        let label6PosX = layoutMetrics.horizontalMargin + label6.frame.width/2
        let label6PosY = label5.position.y - layoutMetrics.normalLineHeight
        label6.position = CGPoint(x: label6PosX, y: label6PosY)
        label6.alpha = 0
        
        let label7 = buildLabel("(but that's ok)", size: .small)
        label7.name = LabelNames.butThat
        let label7PosX = layoutMetrics.horizontalMargin + label7.frame.width/2
        let label7PosY = label6.position.y - layoutMetrics.smallLineHeight
        label7.position = CGPoint(x: label7PosX, y: label7PosY + layoutMetrics.smallLineHeight/2)
        label7.alpha = 0
        
        node.addChild(label5)
        node.addChild(label6)
        node.addChild(label7)
        
        let moveAndShow: SKAction = .group([
            .move(by: CGVector(dx: 0, dy: -layoutMetrics.smallLineHeight/2), duration: 1),
            .fadeIn(withDuration: 1)
        ])
        label5.run(.sequence([.wait(forDuration: 0.5), .fadeIn(withDuration: 1)]))
        label6.run(.sequence([.wait(forDuration: 0.5), .fadeIn(withDuration: 1)]))
        label7.run(.sequence([.wait(forDuration: 2), moveAndShow, .run({ onCompletion() })]))
    }
    
    // The more you know, the more you see  what you don’t know
    private func showText4(onCompletion: @escaping () -> Void = {}) {
        guard
            let label5 = node.children.first(where: { $0.name == LabelNames.sometimesPeople })
                as? SKLabelNode,
            let label6 = node.children.first(where: { $0.name == LabelNames.haveToLeave })
                as? SKLabelNode,
            let label7 = node.children.first(where: { $0.name == LabelNames.butThat })
                as? SKLabelNode
        else {
            return
        }
        
        let groupNode = SKNode()
        node.addChild(groupNode)
        label5.removeFromParent()
        label6.removeFromParent()
        label7.removeFromParent()
        groupNode.addChild(label5)
        groupNode.addChild(label6)
        groupNode.addChild(label7)
        
        let scaleAndFade: SKAction = .group([
            .scale(to: 1.5, duration: 1),
            .fadeOut(withDuration: 1)
        ])
        groupNode.run(.sequence([scaleAndFade, .run({ groupNode.removeFromParent() })]))
        
        let label8 = buildLabel("The more you know,")
        label8.name = LabelNames.theMoreYouKnow
        let label8PosX = layoutMetrics.horizontalMargin + label8.frame.width/2
        label8.position = CGPoint(x: label8PosX, y: layoutMetrics.normalLineHeight)
        label8.alpha = 0
        
        let label9 = buildLabel("the more you see")
        label9.name = LabelNames.theMoreYouSee
        let label9PosX = layoutMetrics.horizontalMargin + label9.frame.width/2
        label9.position = CGPoint(x: label9PosX, y: 0)
        label9.alpha = 0
        
        let label10 = buildLabel("what you don't know")
        label10.name = LabelNames.whatYou
        let label10PosX = layoutMetrics.horizontalMargin + label10.frame.width/2
        label10.position = CGPoint(x: label10PosX, y: -layoutMetrics.normalLineHeight)
        label10.alpha = 0
        
        node.addChild(label8)
        node.addChild(label9)
        node.addChild(label10)
        
        label8.run(.sequence([.wait(forDuration: 1), .fadeIn(withDuration: 1)]))
        label9.run(.sequence([.wait(forDuration: 1.6), .fadeIn(withDuration: 1)]))
        label10.run(.sequence([
            .wait(forDuration: 2.2),
            .fadeIn(withDuration: 1),
            .run {
                onCompletion()
            }
        ]))
    }
    
    private func showText5(onCompletion: @escaping () -> Void = {}) {
        guard
            let label8 = node.children.first(where: { $0.name == LabelNames.theMoreYouKnow })
                as? SKLabelNode,
            let label9 = node.children.first(where: { $0.name == LabelNames.theMoreYouSee })
                as? SKLabelNode,
            let label10 = node.children.first(where: { $0.name == LabelNames.whatYou })
                as? SKLabelNode
        else {
            return
        }
        
        let slideAndFade: (CGFloat) -> SKAction = { horizontalDist in
            return .group([
                .move(by: CGVector(dx: horizontalDist, dy: 0), duration: 1),
                .fadeOut(withDuration: 1)
            ])
        }
        label8.run(.sequence([slideAndFade(100), .run({ label8.removeFromParent() })]))
        label9.run(.sequence([slideAndFade(-100), .run({ label9.removeFromParent() })]))
        label10.run(.sequence([slideAndFade(100), .run({ label10.removeFromParent() })]))
        
        let label11 = buildLabel("The world is vast,")
        label11.name = LabelNames.theWorld
        let label11PosX = layoutMetrics.horizontalMargin + label11.frame.width/2
        label11.position = CGPoint(x: label11PosX, y: layoutMetrics.normalLineHeight/2)
        
        let label12 = buildLabel("just keep connecting!")
        label12.name = LabelNames.justKeep
        let label12PosX = layoutMetrics.horizontalMargin + label12.frame.width/2
        label12.position = CGPoint(x: label12PosX, y: -layoutMetrics.normalLineHeight/2)
        
        let groupNode = SKNode()
        groupNode.addChild(label11)
        groupNode.addChild(label12)
        groupNode.setScale(2)
        groupNode.alpha = 0
        
        node.addChild(groupNode)
        groupNode.run(.sequence([
            .wait(forDuration: 1),
            .group([
                .scale(to: 1, duration: 1),
                .fadeIn(withDuration: 1)
            ]),
            .run {
                onCompletion()
            }
        ]))
    }
}
