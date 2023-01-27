//
//  UIImage+.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 19/04/22.
//

import UIKit

extension UIImage {
    static func buildGradient(frame: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        gradientLayer.render(in: currentContext)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        
        UIGraphicsEndImageContext()
        return image
    }
}
