//
//  ContentScene+Setup.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 13/04/22.
//

import SpriteKit
import AVFoundation

extension ContentScene {
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        self.addChild(mainCircle)
        placeCircles()
        self.addChild(contentCamera)
        self.camera = contentCamera.node
        contentCamera.addChild(textOverlay)
        contentCamera.node.setScale(0.8)
        self.addChild(background)
        contentCamera.node.addChild(tips.node)
        
        tips.showConnect()
        
        setupAudioPlayers()
    }
    
    private func placeCircles() {
        let screenXRange = (-self.size.width + 10)...(self.size.width - 10)
        let screenYRange = (-self.size.height + 10)...(self.size.height - 10)
        let color = ColorSequence.shared.actualColor
        
        for _ in 1...(numberOfCircles * 3) {
            let radius = CGFloat.random(in: minCircleRadius...circleRadius)
            
            let circle = Circle(radius: radius, color: color, animated: true)
            circle.node.position = getUsusedPositionToPlaceCircle(
                xRange: screenXRange,
                yRange: screenYRange
            )
            
            circles.append(circle)
            self.addChild(circle)
        }
    }
    
    private func getUsusedPositionToPlaceCircle(
        xRange: ClosedRange<CGFloat>,
        yRange: ClosedRange<CGFloat>
    ) -> CGPoint {
        var newPosition = PositionUtils.getRandomPosition(
            xRange: xRange,
            yRange: yRange
        )
        
        while !(
            checkHasMinimunDistanceFromMainCircle(atPos: newPosition) &&
            checkHasMinimunDistanceFromCircles(atPos: newPosition, dist: circleRadius*4)
        ) {
            newPosition = PositionUtils.getRandomPosition(
                xRange: xRange,
                yRange: yRange
            )
        }
        
        return newPosition
    }
    
    private func checkHasMinimunDistanceFromCircles(atPos pos: CGPoint, dist: CGFloat) -> Bool {
        for node in self.children {
            if node.name != Circle.Names.circle && node.name != MainCircle.Names.mainCircle {
                continue
            }
            
            let distance = PositionUtils.getDistance(pointA: node.position, pointB: pos)
            
            if distance < dist {
                return false
            }
        }
        
        return true
    }
    
    private func checkHasMinimunDistanceFromMainCircle(atPos pos: CGPoint) -> Bool {
        let distance = PositionUtils.getDistance(pointA: pos, pointB: mainCircle.node.position)
        
        if distance < mainCircleRadius*1.5 {
            return false
        }
        
        return true
    }
    
    private func setupAudioPlayers() {
        let zoomInAudioURL = Bundle.main.url(forResource: "zoomIn", withExtension: "mp3")!
        zoomInSoundPlayer = try! AVAudioPlayer(contentsOf: zoomInAudioURL)
        zoomInSoundPlayer?.prepareToPlay()
        zoomInSoundPlayer?.volume = 1
        
        let zoomOutAudioURL = Bundle.main.url(forResource: "zoomOut", withExtension: "mp3")!
        zoomOutSoundPlayer = try! AVAudioPlayer(contentsOf: zoomOutAudioURL)
        zoomOutSoundPlayer?.prepareToPlay()
        zoomOutSoundPlayer?.volume = 1
    }
}

// ideias Gui: - bolinhas que se aproximam do centro qnd tocadas - usar acelerometro
