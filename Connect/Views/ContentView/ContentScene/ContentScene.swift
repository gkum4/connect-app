//
//  ContentScene.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 11/04/22.
//

import SpriteKit
import AVFoundation

class ContentScene: SKScene, StoryProgressDelegate, TextOverlayDelegate {
    internal lazy var screenArea: CGFloat = {
        return self.frame.height * self.frame.width
    }()
    internal let numberOfCircles: Int = 25
    internal lazy var circleRadius: CGFloat = {
        let totalCircleArea = screenArea * 0.15
        let circleArea = totalCircleArea / CGFloat(numberOfCircles)
        return sqrt(circleArea / CGFloat.pi)
    }()
    internal lazy var minCircleRadius: CGFloat = circleRadius * 0.4
    internal lazy var mainCircleRadius: CGFloat = {
        let mainCircleArea = screenArea * 0.025
        return sqrt(mainCircleArea / CGFloat.pi)
    }()
    internal lazy var mainCircle: MainCircle = MainCircle(radius: mainCircleRadius)
    internal lazy var background: Background = Background(frame: self.frame)
    internal lazy var textOverlay: TextOverlay = TextOverlay(frame: self.frame, delegate: self)
    internal lazy var contentCamera: ContentCamera = ContentCamera(frame: self.frame)
    internal lazy var storyProgress: StoryProgress = StoryProgress(delegate: self, tips: tips)
    internal lazy var tips: Tips = Tips(frame: self.frame)
    internal var circles: [Circle] = []
    internal var lines: [Line] = []
    internal var touchedNode: SKNode?
    internal var showingText: Bool = false
    internal var zoomInSoundPlayer: AVAudioPlayer?
    internal var zoomOutSoundPlayer: AVAudioPlayer?
    
    func getMainCircleColors() -> [CGColor] {
        return mainCircle.gradientColors
    }
    
    func showText(onCompletion: @escaping () -> Void = {}) {
        showingText = true
        
        textOverlay.show(onCompletion: {
            self.textOverlay.nextStep(onCompletion: {
                self.textOverlay.wait(forDuration: 3, onCompletion: {
                    self.showingText = false
                    self.textOverlay.hide(onCompletion: {
                        onCompletion()
                    })
                })
            })
        })
    }
    
    internal func findCircle(node: SKNode) -> Circle? {
        for circle in circles {
            if circle.node == node {
                return circle
            }
        }
        
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    internal enum ActionKeys {
        static let connectionSoundAction: String = "connectionSoundAction"
        static let cutSoundAction: String = "cutSoundAction"
        static let tapSoundAction: String = "tapSoundAction"
        static let zoomInSoundAction: String = "zoomInSoundAction"
        static let zoomOutSoundAction: String = "zoomOutSoundAction"
    }
}
