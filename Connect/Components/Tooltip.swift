//
//  Tooltip.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 22/04/22.
//

import SpriteKit

class Tooltip {
    let node: SKNode
    let sceneFrame: CGRect
    var tooltip: SKSpriteNode
    var tooltipType: TooltipType
    
    init(frame: CGRect, type: TooltipType) {
        node = Tooltip.buildNode()
        sceneFrame = frame
        tooltipType = type
        
        switch type {
        case .touch:
            tooltip = Tooltip.buildTouchTooltip(frame: frame)
        case .cut:
            tooltip = Tooltip.buildCutTooltip(frame: frame)
        case .zoom:
            tooltip = Tooltip.buildZoomTooltip(frame: frame)
        }
        node.addChild(tooltip)
    }
    
    func hide(onCompletion: @escaping () -> Void = {}) {
        tooltip.removeAllActions()
        tooltip.run(.sequence([
            .fadeOut(withDuration: 0.5),
            .run {
                onCompletion()
            }
        ]))
    }
    
    static private func buildTouchTooltip(frame: CGRect) -> SKSpriteNode {
        let newTooltip = Tooltip.buildHandTooltip(frame: frame)
        newTooltip.name = Names.touchTooltip
        
        let scaleAndDownscale: SKAction = .sequence([
            .scale(to: 0.8, duration: 0.7),
            .scale(to: 1, duration: 1)
        ])
        scaleAndDownscale.timingMode = .easeInEaseOut
        
        newTooltip.run(.sequence([
            .fadeAlpha(to: 1, duration: 0.5),
            .repeatForever(scaleAndDownscale)
        ]), withKey: ActionKeys.touchAction)
        
        return newTooltip
    }
    
    static private func buildCutTooltip(frame: CGRect) -> SKSpriteNode {
        let newTooltip = Tooltip.buildHandTooltip(frame: frame)
        newTooltip.name = Names.cutTooltip
        
        let slideAnimation: SKAction = .sequence([
            .fadeIn(withDuration: 0.5),
            .move(by: CGVector(dx: frame.height * 0.1, dy: 0), duration: 1.2),
            .fadeOut(withDuration: 0.5),
            .run {
                newTooltip.position.x -= frame.height * 0.1
            }
        ])
        slideAnimation.timingMode = .easeInEaseOut
        
        newTooltip.run(.sequence([
            .fadeAlpha(to: 1, duration: 0.5),
            .repeatForever(slideAnimation)
        ]), withKey: ActionKeys.cutAction)
        
        return newTooltip
    }
    
    static private func buildZoomTooltip(frame: CGRect) -> SKSpriteNode {
        let newTooltip = Tooltip.buildHandTooltip(frame: frame)
        newTooltip.name = Names.zoomTooltip
        
        let slideAnimation: SKAction = .sequence([
            .fadeIn(withDuration: 0.5),
            .move(by: CGVector(dx: 0, dy: frame.height * 0.25), duration: 0.7),
            .fadeOut(withDuration: 0.5),
            .run {
                newTooltip.position.y -= frame.height * 0.25
            }
        ])
        slideAnimation.timingMode = .easeInEaseOut
        newTooltip.run(.sequence([
            .fadeAlpha(to: 1, duration: 0.5),
            .repeatForever(slideAnimation)
        ]), withKey: ActionKeys.zoomAction)
        
        return newTooltip
    }
    
    static private func buildNode() -> SKNode {
        let newNode = SKNode()
        newNode.name = Names.tooltip
        newNode.zPosition = 20
        
        return newNode
    }
    
    static private func buildHandTooltip(frame: CGRect) -> SKSpriteNode {
        let symbol = (
            UIImage(systemName: "hand.point.up.left.fill") ?? UIImage()
        ).withTintColor(.white)
        guard let symbolData = symbol.pngData() else {
            return SKSpriteNode()
        }
        let symbolImage = UIImage(data: symbolData) ?? UIImage()
        
        let width = frame.width * 0.046
        
        let newTooltip = SKSpriteNode()
        newTooltip.size = CGSize(width: width, height: width)
        newTooltip.texture = SKTexture(image: symbolImage)
        newTooltip.alpha = 0
        
        return newTooltip
    }
    
    enum TooltipType {
        case touch
        case cut
        case zoom
    }
    
    enum Names {
        static let tooltip: String = "tooltip"
        static let touchTooltip: String = "touchTooltip"
        static let cutTooltip: String = "cutTooltip"
        static let zoomTooltip: String = "slideTooltip"
    }
    
    enum ActionKeys {
        static let touchAction: String = "touchAction"
        static let cutAction: String = "touchAction"
        static let zoomAction: String = "touchAction"
    }
}
