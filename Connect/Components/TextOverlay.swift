//
//  TextOverlay.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 16/04/22.
//

import SpriteKit

protocol TextOverlayDelegate: AnyObject {
    func getMainCircleColors() -> [CGColor]
}

class TextOverlay {
    let node: SKNode
    internal let background: SKShapeNode
    internal let sceneFrame: CGRect
    internal let layoutMetrics: LayoutMetrics
    internal var step: Int = 0
    internal let delegate: TextOverlayDelegate?
    
    init(frame: CGRect, delegate: TextOverlayDelegate) {
        node = TextOverlay.buildNode()
        sceneFrame = frame
        layoutMetrics = TextOverlay.buildLayoutMetrics(frame: frame)
        background = TextOverlay.buildBackground(frame: frame, color: .darkGray)
        self.delegate = delegate
        node.addChild(background)
    }
    
    func show(onCompletion: @escaping () -> Void = {}) {
        changeBackgroundColor()
        let fadeIn: SKAction = .fadeIn(withDuration: 1)
        fadeIn.timingMode = .easeInEaseOut
        
        node.run(.sequence([
            fadeIn,
            .run {
                onCompletion()
            }
        ]))
    }
    
    func wait(forDuration time: TimeInterval, onCompletion: @escaping () -> Void = {}) {
        node.run(.sequence([
            .wait(forDuration: time),
            .run {
                onCompletion()
            }
        ]))
    }
    
    func hide(onCompletion: @escaping () -> Void = {}) {
        let fadeOut: SKAction = .fadeOut(withDuration: 1)
        fadeOut.timingMode = .easeInEaseOut
        
        node.run(.sequence([
            fadeOut,
            .run {
                onCompletion()
            }
        ]))
    }
    
    internal func changeBackgroundColor() {
        guard let colors = delegate?.getMainCircleColors() else {
            return
        }
        
        let gradientImage = UIImage.buildGradient(frame: background.frame, colors: colors)
        let gradientTexture = SKTexture(image: gradientImage)
        
        background.fillColor = .white
        background.fillTexture = gradientTexture
    }
    
    internal static func buildNode() -> SKNode {
        let newNode = SKNode()
        newNode.zPosition = 100
        newNode.alpha = 0
        return newNode
    }
    
    internal func buildLabel(_ text: String, size: TextSize = .normal) -> SKLabelNode {
        let newLabel = SKLabelNode(text: text)
        
        switch size {
        case .normal:
            newLabel.fontName = FontNames.pingFangSemibold
            newLabel.fontSize = layoutMetrics.normalFontSize
        case .small:
            newLabel.fontName = FontNames.pingFangRegular
            newLabel.fontSize = layoutMetrics.smallFontSize
        }
    
        return newLabel
    }
    
    static private func buildLayoutMetrics(frame: CGRect) -> LayoutMetrics {
        let frameWidthReference: CGFloat = 834
        let frameWidth: CGFloat = frame.width
        let multiplier = frameWidth / frameWidthReference
        
        let horizontalMarginCompensation = multiplier * 50
        
        return LayoutMetrics(
            normalFontSize: multiplier * 70,
            smallFontSize: multiplier * 35,
            spaceWidth: multiplier * 30,
            horizontalMargin: (multiplier * -417) + horizontalMarginCompensation,
            normalLineHeight: multiplier * 95,
            smallLineHeight: multiplier * 70
        )
    }
    
    static private func buildBackground(frame: CGRect, color: UIColor) -> SKShapeNode {
        let newBackground = SKShapeNode(rectOf: frame.size)
        newBackground.strokeColor = .clear
        newBackground.fillColor = color
        newBackground.alpha = 0.8
        return newBackground
    }
    
    internal enum TextSize {
        case normal
        case small
    }
    
    internal struct LayoutMetrics {
        let normalFontSize: CGFloat
        let smallFontSize: CGFloat
        let spaceWidth: CGFloat
        let horizontalMargin: CGFloat
        let normalLineHeight: CGFloat
        let smallLineHeight: CGFloat
    }
    
    enum FontNames {
        static let pingFangRegular: String = "PingFangSC-Regular"
        static let pingFangSemibold: String = "PingFangSC-Semibold"
    }
    
    enum LabelNames {
        static let peopleChangeThe: String = "label1"
        static let wayYou: String = "label2"
        static let think: String = "label3"
        static let seeThings: String = "label4"
        static let sometimesPeople: String = "label5"
        static let haveToLeave: String = "label6"
        static let butThat: String = "label7"
        static let theMoreYouKnow: String = "label8"
        static let theMoreYouSee: String = "label9"
        static let whatYou: String = "label10"
        static let theWorld: String = "label11"
        static let justKeep: String = "label12"
    }
}
