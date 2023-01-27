//
//  ContentScene+Touches.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 13/04/22.
//

import SpriteKit

extension ContentScene {
    internal func touchDown(atPoint pos: CGPoint) {
        if showingText {
            return
        }
        
        guard let nodeTouched = getTouchedNode(atPos: pos) else {
            touchedNode = nil
            return
        }
        
        touchedNode = nodeTouched

        if nodeTouched.name == Circle.Names.circle {
            onTouchCircle(nodeTouched: nodeTouched)
            return
        }

        if nodeTouched.name == MainCircle.Names.mainCircle {
            onTouchMainCircle(nodeTouched: nodeTouched)
            return
        }

        touchedNode = nil
    }
    
    internal func touchMoved(toPoint pos: CGPoint) {
        if showingText {
            return
        }
        
        if touchedNode == nil && storyProgress.canCutConnectionLine {
            if checkIfIsTouchingAnyCircle(atPos: pos) {
                return
            }
            
            guard let (touchedLine, touchedLineIndex) = getLineWhileTouchMoving(atPos: pos) else {
                return
            }
            
            playCutSound()
            cutConnection(
                touchedLine: touchedLine,
                touchedLineIndex: touchedLineIndex,
                onCompletion: self.storyProgress.cutConnectionLine
            )
        }
        
        if touchedNode == mainCircle.node && storyProgress.canZoomInOrZoomOut {
            zoomCamera(touchedPos: pos)
        }
    }
    
    internal func touchUp(atPoint pos: CGPoint) {
        touchedNode = nil
        stopZoomInSound()
        stopZoomOutSound()
        
        if contentCamera.isZoomingIn || contentCamera.isZoomingOut {
            
            if contentCamera.isZoomingOut {
                storyProgress.zoomedOut()
            }
            
            contentCamera.stopedZooming()
        }
    }
    
    private func onTouchCircle(nodeTouched: SKNode) {
        if !storyProgress.canCreateConnection {
            return
        }
        
        guard let circleTouched = findCircle(node: nodeTouched) else {
            return
        }
        
        if circleTouched.hasLineAttached {
            if storyProgress.canTapOnConnection {
                playTapSound()
                
                background.runHugeSpreadAnimation(
                    colors: mainCircle.gradientColors,
                    atPos: circleTouched.node.position,
                    onCompletion: {
                        self.storyProgress.tappedOnConnection()
                    }
                )
            }
            return
        }
        circleTouched.hasLineAttached = true
        
        connectCircle(circleTouched, onCompletion: {
            self.storyProgress.createdConnection()
        })
    }
    
    private func onTouchMainCircle(nodeTouched: SKNode) {
        if nodeTouched != mainCircle.node {
            return
        }
        
        touchedNode = mainCircle.node
    }
    
    private func getTouchedNode(atPos pos: CGPoint) -> SKNode? {
        for node in self.children {
            if node.contains(pos) {
                return node
            }
        }
        
        return nil
    }
    
    private func connectCircle(
        _ circle: Circle,
        onCompletion: @escaping () -> Void = {}
    ) {
        if checkIfCircleIsInMainFrame(circle) {
            drawLine(from: mainCircle, to: circle, onCompletion: {
                self.playConnectionSound()
                onCompletion()
            })
            return
        }
        
        let nearestCircle = findNearestConnectedCircle(from: circle)
        
        if nearestCircle is MainCircle {
            drawLine(from: nearestCircle, to: circle, onCompletion: {
                self.playDistantConnectionSound()
                nearestCircle.connectedCircles.append(circle)
                circle.connectedCircles.append(nearestCircle)
                
                onCompletion()
            })
        } else {
            drawLine(from: nearestCircle, to: circle, onCompletion: {
                self.playDistantConnectionSound()
                nearestCircle.connectedCircles.append(circle)
                circle.connectedCircles.append(nearestCircle)
                
                self.drawLine(from: circle, to: self.mainCircle, onCompletion: {
                    self.storyProgress.createdDistantConection()
                    onCompletion()
                })
            })
        }
    }
    
    private func findNearestConnectedCircle(from circle: Circle) -> Circle {
        let circlePos = circle.node.position
        
        var nearestCircle: Circle = mainCircle
        var nearestCircleDistance: CGFloat = PositionUtils.getDistance(
            pointA: mainCircle.node.position,
            pointB: circlePos
        )
        
        for otherCircle in circles {
            let alreadyConnectedToCircle = circle.connectedCircles.first(where: {
                return $0.node == otherCircle.node
            }) == nil ? false : true
            
            if !otherCircle.hasLineAttached || otherCircle.node == circle.node || alreadyConnectedToCircle {
                continue
            }
            
            let distance = PositionUtils.getDistance(
                pointA: otherCircle.node.position,
                pointB: circlePos
            )
            
            if distance < nearestCircleDistance {
                nearestCircle = otherCircle
                nearestCircleDistance = distance
            }
        }
        
        return nearestCircle
    }
    
    private func checkIfCircleIsInMainFrame(_ circle: Circle) -> Bool {
        let maxX = self.frame.width/3
        let maxY = self.frame.height/3
        let maxDistance = PositionUtils.getDistance(
            pointA: .zero,
            pointB: CGPoint(x: maxX, y: maxY)
        )
        
        let circleDistanceFromCenter = PositionUtils.getDistance(
            pointA: .zero,
            pointB: circle.node.position
        )
        
        return circleDistanceFromCenter < (maxDistance + circleRadius)
    }
    
    private func drawLine(
        from circleOrigin: Circle,
        to circleDest: Circle,
        onCompletion: @escaping () -> Void = {}
    ) {
        circleOrigin.pauseMovement()
        circleDest.pauseMovement()
        
        let lineColor = ColorSequence.shared.actualColor
        ColorSequence.shared.next()
        let newColor = ColorSequence.shared.actualColor
        
        let line = Line(
            anchorCircleA: circleOrigin,
            anchorCircleB: circleDest,
            color: lineColor
        )
        line.completeAnimationCallback = {
            self.background.runSpreadAnimation(color: newColor, atPos: circleDest.node.position)
            
            line.runChangeColorAnimation(to: newColor, withDuration: 1)
            
            if !(circleOrigin is MainCircle) && !(circleDest is MainCircle) {
                self.mainCircle.runChangeColorAnimation(to: newColor, withDuration: 1)
            }
            
            circleOrigin.runChangeColorAnimation(to: newColor, withDuration: 1)
            
            onCompletion()
            
            circleDest.runChangeColorAnimation(to: newColor, withDuration: 1, onCompletion: {
                circleOrigin.resumeMovement()
                circleDest.resumeMovement()
                
                if circleOrigin is MainCircle {
                    circleDest.runMoveCloserAnimation()
                }
                
                if circleDest is MainCircle {
                    circleOrigin.runMoveCloserAnimation()
                }
            })
        }
        
        lines.append(line)
        self.addChild(line)
    }
    
    private func zoomCamera(touchedPos pos: CGPoint) {
        if pos.y > 0 {
            playZoomOutSound()
            contentCamera.zoomOut(valueY: pos.y)
        } else {
            playZoomInSound()
            contentCamera.zoomIn(valueY: pos.y)
        }
    }
    
    private func checkIfIsTouchingAnyCircle(atPos pos: CGPoint) -> Bool {
        if mainCircle.circle.contains(self.convert(pos, to: mainCircle.node)) {
            return true
        }
        
        for circle in circles {
            if circle.circle.contains(self.convert(pos, to: circle.node)) {
                return true
            }
        }
        
        return false
    }
    
    private func cutConnection(
        touchedLine: Line,
        touchedLineIndex: Int,
        onCompletion: @escaping () -> Void = {}
    ) {
        if !touchedLine.completedAnimation {
            return
        }
        
        let anchorCircleA = touchedLine.anchorCircleA
        let anchorCircleB = touchedLine.anchorCircleB
        
        anchorCircleA.pauseMovement()
        anchorCircleB.pauseMovement()
        touchedLine.removeWithAnimation(onCompletion: {
            anchorCircleA.connectedCircles.removeAll(where: { $0.node == anchorCircleB.node })
            anchorCircleB.connectedCircles.removeAll(where: { $0.node == anchorCircleA.node })
            anchorCircleA.hasLineAttached = false
            anchorCircleB.hasLineAttached = false
            
            if !(anchorCircleA is MainCircle) {
                anchorCircleA.runMoveAwayAnimation(onCompletion: {
                    anchorCircleA.resumeMovement()
                    onCompletion()
                })
            }
            
            if !(anchorCircleB is MainCircle) {
                anchorCircleB.runMoveAwayAnimation(onCompletion: {
                    anchorCircleB.resumeMovement()
                    onCompletion()
                })
            }
        })
        
        lines.remove(at: touchedLineIndex)
    }
    
    private func getLineWhileTouchMoving(atPos pos: CGPoint) -> (Line, Int)? {
        for (i, line) in lines.enumerated() {
            if line.node.contains(pos) {
                return (line, i)
            }
        }
        
        return nil
    }
    
    
}
