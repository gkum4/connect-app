//
//  PositionUtils.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 12/04/22.
//

import CoreGraphics

class PositionUtils {
    static func getRandomPosition(
        xRange: ClosedRange<CGFloat>,
        yRange: ClosedRange<CGFloat>
    ) -> CGPoint {
        return CGPoint(
            x: CGFloat.random(in: xRange),
            y: CGFloat.random(in: yRange)
        )
    }
    
    static func getRandomVector(
        xRange: ClosedRange<CGFloat>,
        yRange: ClosedRange<CGFloat>
    ) -> CGVector {
        return CGVector(
            dx: CGFloat.random(in: xRange),
            dy: CGFloat.random(in: yRange)
        )
    }
    
    static func getDistance(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        return sqrt(pow(pointB.x - pointA.x, 2) + pow(pointB.y - pointA.y, 2))
    }
}
