//
//  CGPoint+.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 13/04/22.
//

import CoreGraphics

extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }

    static func + (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }

    static func += (left: inout CGPoint, right: CGVector) {
        left = left + right
    }

    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }

    static func - (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
    }

    static func -= (left: inout CGPoint, right: CGVector) {
        left = left - right
    }

    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }

    static func *= (left: inout CGPoint, right: CGPoint) {
        left = left * right
    }

    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point = point * scalar
    }

    static func * (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
    }

    static func *= (left: inout CGPoint, right: CGVector) {
        left = left * right
    }

    static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }

    static func /= (left: inout CGPoint, right: CGPoint) {
        left = left / right
    }

    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    static func /= (point: inout CGPoint, scalar: CGFloat) {
        point = point / scalar
    }

    static func / (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
    }

    static func /= (left: inout CGPoint, right: CGVector) {
        left = left / right
    }
    
    static func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
        return start + (end - start) * t
    }
}
