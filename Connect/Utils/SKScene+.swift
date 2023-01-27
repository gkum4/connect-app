//
//  SKScene+.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 12/04/22.
//

import SpriteKit

extension SKScene {
    func addChild(_ mainCircle: MainCircle) {
        self.addChild(mainCircle.node)
    }
    
    func addChild(_ circle: Circle) {
        self.addChild(circle.node)
    }
    
    func addChild(_ line: Line) {
        self.addChild(line.node)
    }
    
    func addChild(_ background: Background) {
        self.addChild(background.node)
    }
    
    func addChild(_ textOverlay: TextOverlay) {
        self.addChild(textOverlay.node)
    }
    
    func addChild(_ contentCamera: ContentCamera) {
        self.addChild(contentCamera.node)
    }
    
    func addChild(_ tips: Tips) {
        self.addChild(tips.node)
    }
}
