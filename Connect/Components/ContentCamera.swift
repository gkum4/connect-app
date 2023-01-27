//
//  ContentCamera.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 19/04/22.
//

import SpriteKit

class ContentCamera {
    let node: SKCameraNode
    private let sceneFrame: CGRect
    private var scaleValue: CGFloat = 1
    var isZoomingIn: Bool = false
    var isZoomingOut: Bool = false
    private var lastZoomPositionY: CGFloat?
    private final let minScale: CGFloat = 0.55
    private final let maxScale: CGFloat = 2
    
    init(frame: CGRect) {
        node = SKCameraNode()
        sceneFrame = frame
    }
    
    func zoomIn(valueY: CGFloat) {
        isZoomingIn = true

        let actualScale = node.yScale
        if actualScale <= minScale {
            return
        }
        
        guard let lastPosY = lastZoomPositionY else {
            lastZoomPositionY = valueY
            return
        }
        
        let zoomScale = getZoomScale(valueY: valueY, lastPosY: lastPosY)
        let newScale = actualScale - zoomScale
        node.setScale(newScale)
        
        lastZoomPositionY = valueY
    }
    
    func zoomOut(valueY: CGFloat) {
        isZoomingOut = true
        
        let actualScale = node.yScale
        if actualScale >= maxScale {
            return
        }
        
        guard let lastPosY = lastZoomPositionY else {
            lastZoomPositionY = valueY
            return
        }
        
        let zoomScale = getZoomScale(valueY: valueY, lastPosY: lastPosY)
        let newScale = actualScale + zoomScale
        node.setScale(newScale)
        
        lastZoomPositionY = valueY
    }
    
    func stopedZooming() {
        isZoomingIn = false
        isZoomingOut = false
        lastZoomPositionY = nil
    }
    
    private func getZoomScale(valueY: CGFloat, lastPosY: CGFloat) -> CGFloat {
        let zoomValue = abs(abs(lastPosY) - abs(valueY))
        
        let zoomScale = zoomValue / sceneFrame.height
        
        return zoomScale
    }
}
