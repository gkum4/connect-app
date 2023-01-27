//
//  Tips.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 22/04/22.
//

import SpriteKit

class Tips {
    let node: SKNode
    var label: SKLabelNode
    var tooltip: Tooltip
    let sceneFrame: CGRect
    
    init(frame: CGRect) {
        node = SKNode()
        node.zPosition = 20
        node.position.y = -frame.height/2 + LayoutMetrics.regularFontSize*2
        label = SKLabelNode()
        label.alpha = 0
        tooltip = Tooltip(frame: .zero, type: .touch)
        node.addChild(label)
        node.addChild(tooltip.node)
        sceneFrame = frame
    }
    
    func showConnect() {
        let newLabel = buildLabel("Tap on circles")
        newLabel.alpha = 0
        let newTooltip = getTouchTooltip()
        newTooltip.node.alpha = 0
        
        showNewTip(newLabel: newLabel, newTooltip: newTooltip)
    }
    
    func showTap() {
        let newLabel = buildLabel("Tap on connected circles")
        newLabel.alpha = 0
        let newTooltip = getTouchTooltip()
        newTooltip.node.alpha = 0
        
        showNewTip(newLabel: newLabel, newTooltip: newTooltip)
    }
    
    func showCut() {
        let newLabel = buildLabel("Move slowly to cut lines")
        newLabel.alpha = 0
        let newTooltip = getCutTooltip()
        newTooltip.node.alpha = 0
        
        showNewTip(newLabel: newLabel, newTooltip: newTooltip)
    }
    
    func showZoom() {
        let newLabel = buildLabel("Move finger up or down from the center of the screen")
        newLabel.alpha = 0
        let newTooltip = getZoomTooltip()
        newTooltip.node.alpha = 0
        
        node.run(.fadeIn(withDuration: 0.5))
        newTooltip.tooltip.anchorPoint = .init(x: 0, y: 1)
        newTooltip.node.position.y += sceneFrame.height/2 - LayoutMetrics.regularFontSize*2
        
        label.removeFromParent()
        tooltip.node.removeFromParent()
        
        node.addChild(newLabel)
        node.addChild(newTooltip.node)
        
        newLabel.run(.sequence([
            .fadeIn(withDuration: 0.51),
            .run {
                self.label = newLabel
            }
        ]))
        
        newTooltip.node.run(.sequence([
            .fadeIn(withDuration: 0.51),
            .run {
                self.tooltip = newTooltip
            }
        ]))
    }
    
    func showConnectDistant() {
        let newLabel = buildLabel("Tap on distant circles")
        newLabel.alpha = 0
        let newTooltip = getTouchTooltip()
        newTooltip.node.alpha = 0
        
        showNewTip(newLabel: newLabel, newTooltip: newTooltip)
    }
    
    func showExplore() {
        let newLabel = buildLabel("Explore!")
        newLabel.alpha = 0
        let newTooltip = getTouchTooltip()
        newTooltip.node.alpha = 0
        
        showNewTip(newLabel: newLabel, newTooltip: newTooltip)
        
        node.run(.sequence([
            .wait(forDuration: 3),
            .run {
                self.dismiss()
            }
        ]))
    }

    private func showNewTip(newLabel: SKLabelNode, newTooltip: Tooltip) {
        node.run(.fadeIn(withDuration: 0.5))
        
        let tooltipWidth = newTooltip.tooltip.size.width
        let labelWidth = newLabel.frame.width
        
        let totalWidth = labelWidth + tooltipWidth
        
        newTooltip.tooltip.anchorPoint = .init(x: 0.5, y: 0.5)
        newLabel.position.x = labelWidth/2 - totalWidth/2
        newTooltip.node.position.y += LayoutMetrics.regularFontSize/2
        newTooltip.node.position.x = totalWidth/2 + tooltipWidth/2 - LayoutMetrics.regularFontSize/2
        
        label.removeFromParent()
        tooltip.node.removeFromParent()
        
        node.addChild(newLabel)
        node.addChild(newTooltip.node)
        
        newLabel.run(.sequence([
            .fadeIn(withDuration: 0.51),
            .run {
                self.label = newLabel
            }
        ]))
        
        newTooltip.node.run(.sequence([
            .fadeIn(withDuration: 0.51),
            .run {
                self.tooltip = newTooltip
            }
        ]))
    }
    
    func dismiss(onCompletion: @escaping () -> Void = {}) {
        node.run(.sequence([
            .fadeOut(withDuration: 1),
            .run {
                onCompletion()
            }
        ]))
    }
    
    private func getTouchTooltip() -> Tooltip {
        let touchTooltip = Tooltip(frame: sceneFrame, type: .touch)
        return touchTooltip
    }
    
    private func getCutTooltip() -> Tooltip {
        let cutTooltip = Tooltip(frame: sceneFrame, type: .cut)
        return cutTooltip
    }
    
    private func getZoomTooltip() -> Tooltip {
        let zoomTooltip = Tooltip(frame: sceneFrame, type: .zoom)
        return zoomTooltip
    }
    
    private func buildLabel(_ text: String) -> SKLabelNode {
        let newLabel = SKLabelNode(text: text)
        newLabel.fontName = FontNames.regular
        newLabel.fontSize = LayoutMetrics.regularFontSize
        
        return newLabel
    }
    
    enum FontNames {
        static let regular: String = "PingFangSC-Regular"
    }
    
    enum LayoutMetrics {
        static let regularFontSize: CGFloat = 14
    }
}
